# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

This is **Casual Friday**, a standalone Hugo theme (not a site). The repository contains theme assets only — `layouts/`, `assets/css/`, `archetypes/`, `static/`, `theme.toml`, and a helper script. There is no top-level `hugo.toml` or `content/` directory. The `exampleSite/` directory is a self-contained demo site used both as documentation and as the way to develop the theme locally.

Requires Hugo ≥ 0.112.0 (extended edition recommended).

## Commands

All development happens from `exampleSite/` against the theme via `--themesDir ../..`. The Makefile in `exampleSite/` is the canonical entry point.

```bash
cd exampleSite
make dev      # generate-parent-tags.sh + hugo server -D --themesDir ../..
make build    # generate-parent-tags.sh + hugo --gc --minify --themesDir ../..
make tags     # run the parent-tag generation script only
make clean    # rm -rf public resources/_gen
```

There is no test suite, linter, or formatter configured. "Building" the theme means rendering `exampleSite/` and checking output visually.

### The parent-tag generation step is mandatory

`scripts/generate-parent-tags.sh` scans front-matter for `parent/child`-style tags and creates `content/tags/<parent>/_index.md` for any parent that lacks one. **It must run before every `hugo` invocation** — `make dev`/`make build` already do this; if running `hugo` directly, run the script first or parent tag pages will 404. For deployment (e.g. Netlify), wire it into the build command: `./scripts/generate-parent-tags.sh && hugo --gc --minify`.

The script lives in the theme root (`scripts/`) on purpose so consumer sites can call it with `../scripts/generate-parent-tags.sh` from their site root when the theme is a submodule.

## Architecture

### Hierarchical tag system (the non-obvious core feature)

Tags use a `parent/child` slug convention (e.g. `devops/slos`, `security/identity`). This is implemented entirely in the templates — Hugo itself has no notion of nested taxonomies, so the templates do the aggregation manually. Understanding this is essential before editing tag-related layouts.

Three layouts coordinate to make it work:

- **`layouts/_default/list.html`** — When rendering a tag page, detects whether `.Data.Term` (or, for `_index.md`-backed parent pages, the URL-derived slug) contains `/`. For parent tags, it walks `.Site.Taxonomies.tags`, matches every slug starting with `<parent>/`, unions those pages with the parent's own `.Pages`, dedupes via `uniq`, and re-sorts by date. It also computes the deduplicated post count and renders the "Subtopics" pill list (parent view) or "Also in <parent>:" sibling list (child view). Post cards on tag pages use **context-aware tag badges**: when viewing `/tags/devops/`, a post tagged `devops/slos` shows the "SLOs" sub-pill rather than just the first tag.
- **`layouts/_default/terms.html`** — Builds the `/tags/` index by partitioning `.Pages` into parent tags and `childTagsByParent` (a dict keyed by parent slug). Calculates per-parent post counts as `len (parent.Pages ++ all children.Pages | uniq)`. Filters out zero-post tags.
- **`layouts/index.html`** — Homepage. Renders the tags cloud by deduplicating parent slugs from `.ByCount` and listing children separately. Latest posts deliberately combine `Section == "posts"` **and** `Section == "not_engineering"`, then sort and trim — if you add new content sections that should appear on the homepage, edit this union.

When editing any tag logic, keep these invariants:
1. Slug detection must handle both taxonomy term pages (`.Data.Term` populated) and `_index.md`-backed parent pages (`.Data.Term` empty — derive from `.RelPermalink`).
2. Aggregating parent posts requires a final `uniq` — a post tagged with both `devops` and `devops/slos` would otherwise count twice.
3. Parent tags need an `_index.md` to render at all; that's what `scripts/generate-parent-tags.sh` exists to guarantee.

### Layout system

`baseof.html` is the single entry; pages override the `main` block. `_default/list.html` handles three layouts via `$pageLayout`/`$useTimeline`: `single-column`, `two-column`, and `timeline` (timeline auto-degrades to single-column under 1024px via CSS). Page-level front matter (`timeline:`, `listLayout:`) overrides site-level (`enableTimeline`, `listLayout`) — preserve this precedence when adding new layout options.

`_default/single.html` injects an inline `<style>` block when TOC is enabled to widen the article container and grid the body — this is intentional, not stray inline CSS, because the layout shift only applies to TOC pages and the breakpoints would otherwise need to live in `main.css` with a class hook.

### CSS

A single hand-authored `assets/css/main.css` (~77 KB). No PostCSS/Sass/Tailwind — Hugo Pipes processes it directly (see `partials/head.html`). Theme variables (accent color presets, background scheme, dark mode tokens) are CSS custom properties; the accent and background scheme are wired up by emitting an inline `:root` block from site params. When adding visual variants, follow that pattern (config → CSS variable → existing rules) rather than introducing new stylesheets.

### JavaScript

Minimal, inline in `partials/scripts.html`. Handles dark mode toggle (with no-flash init in `head.html`), code-block copy buttons, mobile tags expand, and the audio player. No bundler.

### Audio player

Optional feature reading from `data/audio-manifest.json` in the consumer site (not in the theme). The manifest maps post paths to pre-generated MP3 files; the theme just renders a player when `audio: true` is in front matter and the manifest has an entry. `params.audio.baseURL` prefixes file URLs (supports local, S3, Azure Blob, R2, etc.). This is consumer-side wiring — the theme never generates audio.

## Conventions

- **British English** in user-visible strings ("optimised", "colour", "behaviour"). Match this when editing existing copy.
- Hugo template comments use `{{/* ... */}}` (stripped from output), not `{{ /* ... */ }}`.
- Tag slugs are lowercase with `/` separators; parent and child names are humanized + titlecased at render time, with special-casing for `devops` → `DevOps` and `finops` → `FinOps` in `generate-parent-tags.sh` (extend the `sed` block there if adding similar acronym tags).
- Posts default to `draft: true` (see `archetypes/posts.md`); `make dev` passes `-D` to render drafts, production builds do not.
- The `exampleSite/` is committed and acts as both demo and dev harness — keep it working when changing layouts. Its `hugo.toml` is also the reference for documenting every available `[params]` option.
- Versioning: Semantic Versioning, with changes recorded in `CHANGELOG.md` (Keep a Changelog format).
