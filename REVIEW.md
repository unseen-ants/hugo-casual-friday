# Casual Friday Hugo Theme - Code Review

## Overview

Casual Friday is a feature-rich Hugo theme targeting personal blogs and portfolio sites. It offers dark/light mode, hierarchical taxonomies, an audio player, configurable accent colors, and comprehensive SEO markup. The codebase is well-organized with clean template structure, no external JS dependencies, and Hugo-native asset processing.

This review covers bugs, security, performance, accessibility, code quality, and architectural concerns.

---

## Bugs

### 1. Broken links in list page card images (`layouts/_default/list.html`)

In the standard grid layout, post card image links use `$.Permalink` and `$.Title` inside a `{{ range $pages }}` / `{{ with .Params.image }}` nesting. In Hugo, `$` refers to the top-level template context (the list page), not the current post being iterated. This means all card image links point to the list page itself instead of individual posts.

**Affected lines:**

- `list.html:303-304` (top image position):
  ```
  <a href="{{ $.Permalink }}">
    <img src="{{ . }}" alt="{{ $.Title }}" loading="lazy">
  ```
- `list.html:314-315` (left image position):
  ```
  <a href="{{ $.Permalink }}">
    <img src="{{ . }}" alt="{{ $.Title }}" loading="lazy">
  ```
- `list.html:376-377` (right image position):
  ```
  <a href="{{ $.Permalink }}">
    <img src="{{ . }}" alt="{{ $.Title }}" loading="lazy">
  ```

**Fix:** Assign the post to a variable before entering `with`, e.g.:
```go
{{ $post := . }}
{{ with .Params.image }}
<a href="{{ $post.Permalink }}">
  <img src="{{ . }}" alt="{{ $post.Title }}" loading="lazy">
```

### 2. Duplicate author meta tags (`layouts/partials/head.html:13-14`)

Both site-level and page-level author meta tags are emitted unconditionally:
```html
{{ with .Site.Params.author }}<meta name="author" content="{{ . }}">{{ end }}
{{ with .Params.author }}<meta name="author" content="{{ . }}">{{ end }}
```

If a post overrides the author, two conflicting `<meta name="author">` tags appear in the HTML. The page-level author should suppress the site-level one.

### 3. JSON-LD SearchAction references nonexistent search page (`layouts/partials/head.html:117-120`)

```json
"potentialAction": {
  "@type": "SearchAction",
  "target": "{{ .Site.BaseURL }}search?q={search_term_string}",
  "query-input": "required name=search_term_string"
}
```

The theme has no search functionality. This structured data is misleading to search engines and will produce a broken experience if Google surfaces the search action.

### 4. CSS header naming mismatch (`assets/css/main.css:1-3`)

The CSS file header reads "SOVEREIGN THEME" but the theme is called "Casual Friday". This suggests a rename occurred without updating the CSS comment block.

### 5. Hero banner file extension mismatch (FIXED)

The example config (`exampleSite/hugo.toml:44`) references `/images/hero-banner.png` but the actual static file is `exampleSite/static/images/hero-banner.svg`. The same `.png` extension was used in the fallback path in `layouts/index.html:7`. This causes the hero banner to 404 on the example site, resulting in:

- **Desktop**: The hero section shows the page background color instead of the dark banner image. Light-colored hero text (`#fafafa`) becomes invisible against the light page background.
- **Mobile**: The header hero background image fails to load, though the dark gradient overlay partially masks the issue.

**Fix applied:** Changed both references from `.png` to `.svg`.

### 6. Hardcoded `not_engineering` section (`layouts/index.html:245`)

```go
{{ $notEng := where .Site.RegularPages "Section" "not_engineering" }}
{{ $combined := $allPosts | append $notEng }}
```

The homepage pulls posts from a hardcoded `not_engineering` section that isn't part of the theme's documentation or example site. This appears to be site-specific code that leaked into the theme and will produce unexpected behavior for other users.

---

## Security

### 1. Unsafe HTML rendering enabled by default (`exampleSite/hugo.toml:157`)

```toml
[markup.goldmark.renderer]
  unsafe = true
```

This allows arbitrary HTML and JavaScript injection through markdown content. While noted as intentional for HTML-in-markdown support, the example config should either set this to `false` or add a prominent warning comment explaining the risk for sites with untrusted content contributors.

### 2. `safeHTML` on user-configurable content (`layouts/partials/header.html:57`)

```go
{{ . | safeHTML }}
```

Applied to `heroSubtitle`, which comes from `hugo.toml`. Since only the site owner controls this, the risk is low, but it establishes a pattern that could be misapplied to user-submitted content.

---

## Performance

### 1. No `prefers-reduced-motion` respect for `scroll-behavior: smooth`

`main.css:79` sets `scroll-behavior: smooth` globally. Users with vestibular motion sensitivities who set `prefers-reduced-motion: reduce` will still get smooth scrolling. Add:

```css
@media (prefers-reduced-motion: reduce) {
  html { scroll-behavior: auto; }
}
```

### 2. Three Google Fonts families in a single blocking request

`head.html:212` loads Playfair Display, Source Serif 4, and JetBrains Mono in one request. While `display=swap` is used (preventing render blocking), the combined download weight is significant. Consider whether JetBrains Mono (used only for code blocks) could be loaded asynchronously or deferred.

### 3. Inline SVG duplication

SVG icons for social links, navigation arrows, theme toggle, etc. are inlined throughout multiple templates. The same chevron icon appears in `list.html`, `single.html`, `scripts.html`, and `terms.html`. An SVG sprite or partial would reduce HTML payload.

### 4. Audio player JavaScript always loaded

The audio player JS in `scripts.html:59-208` initializes on every page, even when no audio player exists. The `querySelectorAll('.audio-player-wrapper').forEach(...)` gracefully handles this, but the code itself is ~150 lines of dead weight on non-audio pages.

---

## Accessibility

### 1. No skip-to-content link

There is no skip navigation link for keyboard and screen reader users to bypass the header and navigation. This is a WCAG 2.1 Level A requirement (2.4.1 Bypass Blocks).

Add before the header in `baseof.html`:
```html
<a href="#main-content" class="skip-link">Skip to content</a>
```

### 2. Mobile menu lacks focus trap

When the mobile menu opens (`scripts.html:17-20`), focus can tab to elements behind the menu overlay. A focus trap should confine keyboard navigation to the menu when it's open.

### 3. Theme toggle lacks state indication

The theme toggle button (`header.html:27`) uses `aria-label="Toggle dark mode"` but doesn't indicate the current state. Using `aria-pressed` would communicate whether dark mode is active:

```html
<button class="theme-toggle" aria-label="Toggle dark mode" aria-pressed="false">
```

### 4. Expandable mobile TOC missing `aria-controls`

The `<details>` element in `single.html:75-84` for mobile table of contents doesn't use `aria-controls` to associate the summary with its content panel.

### 5. Color contrast concerns

The accent color options (cerulean `#0891b2`, teal `#0D9488`) may not meet WCAG AA contrast requirements (4.5:1) against the light background (`#f7f6f3`). This should be verified with a contrast checker for each preset.

---

## Code Quality

### 1. Duplicated tag cloud logic (`layouts/index.html`)

The tag cloud rendering logic is copy-pasted between the desktop section (lines 183-229) and mobile section (lines 316-364). This should be extracted into a `partials/tag-cloud.html` partial.

### 2. Duplicated context-aware tag matching (`layouts/_default/list.html`)

The tag matching logic for context-aware display appears twice: once in the timeline layout block (lines 241-274) and again in the standard grid block (lines 324-357). Extract to a partial.

### 3. Magic numbers throughout templates

Several hardcoded values appear without explanation:
- `200.0` for words-per-minute reading time calculation (appears 6+ times across templates)
- Truncation lengths: `200`, `140`, `100` for different excerpt contexts
- Tag display limits: `8` parent tags, `7` child tags on homepage
- `3` visible mobile tags in tag bar

These should be configurable via `hugo.toml` params or at minimum defined as template variables at the top of each file.

### 4. Inline `<style>` block in `single.html`

The TOC layout styles (lines 8-28) are injected as an inline `<style>` tag instead of being in `main.css`. This bypasses Hugo's asset pipeline (no minification/fingerprinting) and prevents caching. These rules belong in the main stylesheet with the existing `.article.has-toc` selectors at `main.css:889-893`.

### 5. `!important` overrides for background schemes (`layouts/partials/head.html:259-275`)

The background scheme configuration uses `!important` on all CSS custom property overrides. This makes it difficult for users to further customize these values and is a code smell. Since the inline `<style>` appears after the main CSS, specificity should be sufficient without `!important`.

---

## Missing Features / Gaps

1. **No Twitter Card meta tags**: Only Open Graph tags are present. Adding `twitter:card`, `twitter:title`, `twitter:description`, and `twitter:image` would improve social sharing on Twitter/X.

2. **Limited social link options**: Footer only supports LinkedIn, GitHub, and Twitter. Common platforms like Mastodon, Bluesky, YouTube, and email are missing.

3. **No configurable 404 page**: The `404.html` has hardcoded text ("Oops! Page not found"). The message and suggestion text should come from `hugo.toml` params.

4. **No RSS template customization**: The theme relies on Hugo's default RSS output with no custom `layouts/_default/rss.xml` template for controlling feed content.

5. **`categories` taxonomy declared but unused**: `hugo.toml:145` declares `category = "categories"` but the theme templates only work with `tags`. This creates an unused taxonomy.

---

## Architecture Assessment

**Strengths:**
- Clean template hierarchy (`baseof.html` -> block pattern)
- Hugo-native asset pipeline (minification, fingerprinting, SRI)
- CSS custom properties for theming with sensible defaults
- Comprehensive JSON-LD structured data
- Dark mode with flash prevention via inline script
- No external JS runtime dependencies
- Good separation of concerns (partials for head, header, footer, scripts, audio)
- Hierarchical tag system is a genuinely useful differentiator
- Well-documented example site configuration

**Weaknesses:**
- Template complexity is high -- `list.html` (419 lines) and `index.html` (370 lines) are doing too much work inline that should be decomposed into partials
- Code duplication between mobile and desktop tag rendering
- Site-specific code leaked into the theme (`not_engineering` section)
- CSS file is monolithic (~1800 lines) with no logical splitting

---

## Summary

The theme is well-conceived with strong SEO, theming, and content organization features. The main areas needing attention are:

| Priority | Issue | Type |
|----------|-------|------|
| High | Card image links broken in list.html (`$.Permalink` bug) | Bug |
| High | Hero banner `.png` vs `.svg` extension mismatch (FIXED) | Bug |
| High | Hardcoded `not_engineering` section in index.html | Bug |
| High | No skip-to-content link | Accessibility |
| Medium | Duplicate author meta tags | Bug |
| Medium | Phantom SearchAction in JSON-LD | Bug |
| Medium | CSS header says "SOVEREIGN THEME" | Bug |
| Medium | Duplicated tag cloud / tag matching code | Code Quality |
| Medium | No Twitter Card meta tags | Feature Gap |
| Medium | `!important` overrides in background scheme | Code Quality |
| Low | Audio JS loaded on all pages | Performance |
| Low | Inline styles in single.html | Code Quality |
| Low | No `prefers-reduced-motion` for smooth scroll | Accessibility |
