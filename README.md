# Casual Friday

A warm, inviting Hugo theme with elegant serif typography, dark mode support, and thoughtful details for personal blogs and portfolios.

![Hugo](https://img.shields.io/badge/Hugo-%3E%3D0.112.0-ff4088?logo=hugo)
![License](https://img.shields.io/badge/License-MIT-blue.svg)

## Features

- **Elegant Typography** - Playfair Display headings with Source Serif 4 body text
- **Dark Mode** - Automatic detection with manual toggle
- **Fully Responsive** - Mobile-first design with optimised layouts
- **SEO Optimised** - Open Graph, JSON-LD structured data, meta tags
- **Configurable Colors** - 5 accent presets or custom hex colours
- **Background Schemes** - Warm, cool, or neutral background tints
- **Featured Posts** - Highlight your best content on the homepage
- **Date Badge Overlay** - Image cards display date badges on thumbnails
- **Reading Time** - Automatic reading time estimation for articles
- **Post Navigation** - Previous/Next links between articles
- **Timeline Layout** - Chronological timeline view for list pages (desktop only)
- **Flexible Layouts** - Single-column, two-column, or timeline layouts per page
- **Hierarchical Tags** - Nested tag system with parent/child aggregation
- **Audio Player** - Optional "Listen to Articles" TTS feature
- **Analytics Ready** - GoatCounter and Google Analytics support
- **Fast** - Minimal JavaScript, optimised CSS

---

## Quick Start

### Installation

**Option 1: Git Submodule (Recommended)**

```bash
cd your-hugo-site
git submodule add https://github.com/unseen-ants/hugo-casual-friday themes/casual-friday
```

**Option 2: Git Clone**

```bash
cd your-hugo-site/themes
git clone https://github.com/unseen-ants/hugo-casual-friday
```

**Option 3: Download**

Download the [latest release](https://github.com/unseen-ants/hugo-casual-friday/releases) and extract to `themes/casual-friday`.

### Configuration

Update your `hugo.toml`:

```toml
theme = "casual-friday"
```

---

## Configuration

### Basic Setup

```toml
baseURL = "https://yoursite.com/"
title = "Your Site Title"
theme = "casual-friday"
languageCode = "en-gb"
enableRobotsTXT = true

[pagination]
  pagerSize = 10

[params]
  description = "Your site description"

  # Hero section (homepage)
  heroTitle = "Your Name"
  heroSubtitle = "Your tagline or bio"
  heroBanner = "/images/hero-banner.png"
  heroMobilePosition = "center center"

  # Content display
  latestPostsDesktop = 8
  latestPostsMobile = 3
  featuredPostsCount = 1        # Number of featured posts (max: latestPostsDesktop)
  featuredTags = ["blog", "projects"]

  # Card images (optional)
  showCardImages = false        # Show images in post cards
  cardImagePosition = "top"     # Position: "top", "left", or "right"

# Hero action buttons
[[params.heroLinks]]
  text = "About"
  url = "/about/"
[[params.heroLinks]]
  text = "Contact"
  url = "/contact/"

# Navigation menu
[menu]
  [[menu.main]]
    name = "Blog"
    url = "/posts/"
    weight = 1
  [[menu.main]]
    name = "About"
    url = "/about/"
    weight = 2

[taxonomies]
  tag = "tags"

[outputs]
  home = ["HTML", "RSS"]

[markup]
  [markup.goldmark.renderer]
    unsafe = true
```

### Social Links

```toml
[params.social]
  linkedin = "https://linkedin.com/in/yourprofile"
  github = "https://github.com/yourusername"
  twitter = "https://twitter.com/yourhandle"
```

### Analytics

```toml
[params.analytics]
  # GoatCounter (privacy-friendly)
  goatcounter = "your-site-code"

  # Google Analytics (GA4)
  google = "G-XXXXXXXXXX"
```

Analytics only loads in production (not during `hugo server`).

---

## SEO

The theme includes comprehensive SEO support out of the box.

### Features

- **Meta Tags** - Title, description, author, keywords, robots
- **Open Graph** - Full support for Facebook, LinkedIn sharing
- **JSON-LD Structured Data** - Article, WebSite, BreadcrumbList schemas
- **Canonical URLs** - Automatic canonical link generation
- **Sitemap** - Auto-generated via Hugo
- **RSS Feed** - Auto-generated with proper meta links

### Configuration

```toml
[params]
  description = "Your site description for SEO"
  author = "Your Name"
  keywords = ["keyword1", "keyword2", "keyword3"]

  # Default image for social sharing (used when posts don't have an image)
  ogImage = "/images/og-default.png"

  # Optional: tagline appended to homepage title
  tagline = "Your Site Tagline"

  # Optional: custom favicon
  favicon = "/favicon.ico"
  appleTouchIcon = "/apple-touch-icon.png"
```

### Per-Page SEO

In your content front matter:

```yaml
---
title: "Your Post Title"
description: "Custom description for this page (recommended: 150-160 chars)"
image: "/images/post-cover.jpg"  # Used for og:image
author: "Guest Author"           # Override site author
noindex: true                    # Exclude from search engines (optional)
---
```

### Structured Data

The theme automatically generates JSON-LD structured data:

- **Homepage**: `WebSite` schema with search action
- **Articles**: `Article` schema with author, dates, word count
- **Taxonomy pages**: `CollectionPage` schema
- **All pages**: `BreadcrumbList` for navigation

### Open Graph Support

Supported platforms:
- Facebook
- LinkedIn
- Pinterest
- WhatsApp
- Telegram
- Slack

The theme does **not** include Twitter Card meta tags.

---

## Table of Contents

Enable table of contents for long articles.

### Site-wide

```toml
[params]
  toc = true  # Enable TOC on all posts
```

### Per-post

```yaml
---
title: "My Long Article"
toc: true
---
```

The TOC is collapsible and includes all H2 and H3 headings.

---

## Shortcodes

### Callout

Create attention-grabbing boxes for tips, warnings, and notes.

```markdown
{{</* callout type="info" */>}}
This is an informational callout. **Markdown** is supported.
{{</* /callout */>}}

{{</* callout type="warning" title="Warning!" */>}}
Be careful with this action.
{{</* /callout */>}}
```

**Available types:**

| Type | Use case |
|------|----------|
| `info` | General information (default) |
| `tip` | Helpful tips and best practices |
| `warning` | Cautions and important notices |
| `danger` | Critical warnings |
| `note` | Side notes and additional context |

---

## Code Blocks

Code blocks automatically include a copy-to-clipboard button that appears on hover.

---

## Theme Customisation

### Accent Colors

Configure the accent color in your `hugo.toml`:

```toml
[params]
  # Preset options: cerulean (default), crimson, purple, teal, amber
  accentColor = "cerulean"

  # Or use a custom hex color
  accentColor = "#FF5733"
```

**Available presets:**

| Name | Color | Hex |
|------|-------|-----|
| cerulean | Blue (default) | `#0891b2` |
| crimson | Red | `#DC2626` |
| purple | Purple | `#7C3AED` |
| teal | Teal | `#0D9488` |
| amber | Orange | `#D97706` |

### Background Scheme

Configure the background color scheme:

```toml
[params]
  # Options: warm (default), cool, neutral
  backgroundScheme = "warm"
```

| Scheme | Description |
|--------|-------------|
| `warm` | Subtle cream/beige tint (default) |
| `cool` | Subtle blue-gray tint |
| `neutral` | Pure gray tones |

---

## Content Structure

### Posts

Create posts in `content/posts/`:

```markdown
---
title: "My First Post"
date: 2024-01-15
description: "A brief description for SEO and previews"
tags: ["technology", "hugo", "web"]
audio: false
---

Your content here...
```

### Front Matter Options

| Field | Type | Description |
|-------|------|-------------|
| `title` | string | Post title |
| `date` | date | Publication date |
| `description` | string | SEO description and preview text |
| `image` | string | Cover image path (used for cards and social sharing) |
| `tags` | array | Post tags (first tag displayed as primary badge) |
| `audio` | boolean | Enable audio player (requires manifest) |
| `featured` | boolean | Mark as featured post |
| `toc` | boolean | Enable table of contents |

### Pages

Create pages in `content/`:

```markdown
---
title: "About"
---

Your page content...
```

---

## Audio Player (Optional)

The theme includes a "Listen to Articles" feature for text-to-speech audio.

### Configuration

```toml
[params.audio]
  # Base URL for audio files
  # Local:       "/audio"
  # CDN:         "https://cdn.yoursite.com/audio"
  # S3:          "https://your-bucket.s3.amazonaws.com/audio"
  # Azure Blob:  "https://youraccount.blob.core.windows.net/audio"
  baseURL = "/audio"
```

### Audio Manifest

Create `data/audio-manifest.json`:

```json
{
  "generated_at": "2024-01-15T10:00:00Z",
  "posts": {
    "posts/my-first-post": {
      "file": "posts/my-first-post-abc123.mp3",
      "duration": 300,
      "size": 2400000,
      "hash": "abc123"
    }
  }
}
```

### Enable Per-Post

In your post front matter:

```yaml
audio: true
```

### CORS Configuration

If hosting audio externally, configure CORS headers:

**Amazon S3 / Cloudflare R2:**
```json
{
  "CORSRules": [{
    "AllowedOrigins": ["https://yoursite.com"],
    "AllowedMethods": ["GET", "HEAD"],
    "AllowedHeaders": ["*"],
    "MaxAgeSeconds": 86400
  }]
}
```

**Azure Blob Storage:**
```xml
<Cors>
  <CorsRule>
    <AllowedOrigins>https://yoursite.com</AllowedOrigins>
    <AllowedMethods>GET,HEAD</AllowedMethods>
    <AllowedHeaders>*</AllowedHeaders>
    <MaxAgeInSeconds>86400</MaxAgeInSeconds>
  </CorsRule>
</Cors>
```

---

## Featured Posts

Control the number of featured posts displayed on the homepage.

### Configuration

```toml
[params]
  # Number of featured posts to display (default: 1)
  # Note: Cannot exceed latestPostsDesktop value
  featuredPostsCount = 2

  # Maximum posts in latest section (featured count cannot exceed this)
  latestPostsDesktop = 8
```

### Marking Posts as Featured

In your post front matter:

```yaml
---
title: "My Featured Post"
featured: true
---
```

---

## Card Images

Display thumbnail images in post cards on the Posts page and homepage Latest section.

### Configuration

```toml
[params]
  # Enable images in post cards (default: false)
  showCardImages = true

  # Image position in cards: "top", "left", or "right" (default: "top")
  cardImagePosition = "left"
```

### Image Positions

| Position | Description |
|----------|-------------|
| `top` | Image above content (default) |
| `left` | Image on the left, content on the right |
| `right` | Image on the right, content on the left |

### Adding Images to Posts

In your post front matter:

```yaml
---
title: "My Post"
image: "/images/post-cover.jpg"
---
```

When `showCardImages` is enabled:
- Posts with images display the thumbnail
- Posts without images fall back to the date display
- Images are also used for Open Graph social sharing

### Date Badge Overlay (Homepage Latest Section)

In the homepage Latest section, posts with images display a **date badge overlay** that combines the visual date with the thumbnail:

- Badge positioned at the bottom-left corner of the image
- Shows day number and abbreviated month (e.g., "20 JAN")
- Subtle background and shadow for visibility on any image
- Posts without images show the standard date column

---

## List Page Layouts

Control how list pages (Posts, custom sections) display their content.

### Layout Options

| Layout | Description |
|--------|-------------|
| `single-column` | Centered single-column cards (default) |
| `two-column` | Two-column grid layout |
| `timeline` | Chronological timeline with year/month markers |

### Site-Level Configuration

Set default layout behaviour in `hugo.toml`:

```toml
[params]
  # Enable timeline layout globally (default: false)
  enableTimeline = false

  # Default layout for list pages: "single-column", "two-column"
  # Note: Only applies when timeline is disabled
  listLayout = "single-column"
```

### Per-Page Configuration

Override site defaults in your section's `_index.md`:

```yaml
---
title: "Posts"
timeline: true          # Enable timeline for this page
listLayout: "two-column" # Layout when timeline is disabled
---
```

### Timeline Layout

The timeline displays posts chronologically with:
- Year groupings (2025, 2024, etc.)
- Month markers (JAN, FEB, etc.)
- Visual connecting line from page title
- Dots marking each post's position

**Example configuration for Posts:**

```yaml
# content/posts/_index.md
---
title: "Posts"
timeline: true
---
```

**Example configuration for two-column layout:**

```yaml
# content/portfolio/_index.md
---
title: "Portfolio"
timeline: false
listLayout: "two-column"
---
```

### Responsive Behaviour

- **Desktop (>1024px)**: Timeline displays with all visual elements
- **Tablet/Mobile (≤1024px)**: Timeline automatically hides, falls back to single-column cards

This ensures optimal readability on smaller screens while preserving the chronological visual on desktop.

---

## Hierarchical Tags

The theme supports nested/hierarchical tags using a `parent/child` format.

### How It Works

Use tags like `devops/slos`, `devops/azure`, `security/identity` in your posts:

```yaml
---
title: "My Post"
tags:
  - devops/slos
  - devops/observability
---
```

### Features

- **Parent Tag Pages**: `/tags/devops/` aggregates all posts from child tags
- **Subtopics Section**: Parent pages show clickable pills for each child tag
- **Context-Aware Badges**: Post cards show relevant subtopic(s) for the current page
- **Deduplicated Counts**: Post counts reflect unique posts, not tag occurrences
- **Child Tag Pages**: Breadcrumb and title show just the child name (not full path)
- **Homepage Integration**: Post cards show two-level tag bubbles; Topics section shows flat pills
- **Zero-Post Filtering**: Tags with no posts are automatically hidden

### Setup

Parent tags require an `_index.md` file to generate their pages:

```
content/
└── tags/
    ├── devops/
    │   └── _index.md
    ├── security/
    │   └── _index.md
    └── finops/
        └── _index.md
```

**Auto-generate parent tag files:**

Include the helper script `scripts/generate-parent-tags.sh` and run before building:

```bash
# Manual
./scripts/generate-parent-tags.sh && hugo

# Or use Make
make build   # Production build
make dev     # Development server
```

**Netlify/CI integration:**

```toml
# netlify.toml
[build]
  command = "./scripts/generate-parent-tags.sh && hugo --gc --minify"
```

### Example Structure

```
Tags Page (/tags/)
├── DevOps (3 posts)
│   ├── SLOs (1)
│   ├── Azure (1)
│   └── Infrastructure as Code (1)
├── Security (2 posts)
│   ├── Identity (1)
│   └── Incident Response (1)
```

---

## Directory Structure

```
your-site/
├── hugo.toml
├── content/
│   ├── posts/
│   │   └── my-post.md
│   ├── about.md
│   └── contact.md
├── static/
│   └── images/
│       └── hero-banner.png
├── data/
│   └── audio-manifest.json    # Optional
└── themes/
    └── casual-friday/
```

---

## Theme Structure

```
casual-friday/
├── theme.toml
├── LICENSE
├── README.md
├── assets/
│   └── css/
│       └── main.css
├── layouts/
│   ├── 404.html
│   ├── index.html
│   ├── _default/
│   │   ├── baseof.html
│   │   ├── single.html
│   │   ├── list.html
│   │   └── terms.html
│   └── partials/
│       ├── head.html
│       ├── header.html
│       ├── footer.html
│       ├── scripts.html
│       └── audio-player.html
├── static/
│   └── favicon.svg
├── scripts/
│   └── generate-parent-tags.sh
└── exampleSite/
```

---

## Running the Example Site

The `exampleSite` directory contains a complete demo site.

### Quick Start

```bash
cd casual-friday/exampleSite

# Using Make (recommended)
make dev

# Or manually
cd .. && ./scripts/generate-parent-tags.sh && cd exampleSite
hugo server -D --themesDir ../..
```

### What's Included

- Sample posts demonstrating hierarchical tags
- Complete `hugo.toml` with all configuration options
- Parent tag `_index.md` files for the demo tags

---

## Typography

The theme uses Google Fonts:

- **Headings:** Playfair Display
- **Body:** Source Serif 4
- **Code:** JetBrains Mono

Fonts are preconnected for optimal performance.

---

## Requirements

- Hugo v0.112.0 or later (extended edition recommended)
- Modern browser with CSS custom properties support

---

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

## License

MIT License - see [LICENSE](LICENSE) for details.

---

## Credits

Created by [Avijit Ajay](https://avijit.space)

Built with [Hugo](https://gohugo.io)
