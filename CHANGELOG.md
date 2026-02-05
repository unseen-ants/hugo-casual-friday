# Changelog

All notable changes to the Casual Friday theme will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-02-04

### Added
- **Typography**: Playfair Display headings, Source Serif 4 body, JetBrains Mono code
- **Dark Mode**: Automatic detection with manual toggle, no flash on load
- **Responsive Design**: Mobile-first with optimised layouts for all screen sizes
- **Theme Customisation**:
  - 5 accent colour presets (cerulean, crimson, purple, teal, amber) plus custom hex
  - 3 background schemes (warm, cool, neutral)
- **SEO Features**:
  - Open Graph meta tags for social sharing
  - JSON-LD structured data (Article, WebSite, BreadcrumbList)
  - Canonical URLs and meta robots
- **Homepage**:
  - Hero section with configurable banner image
  - Featured post highlight with date badge overlay
  - Latest posts list with image support
  - Mobile tag bar and tags cloud section
- **Hierarchical Tag System**:
  - Nested tags using `parent/child` format (e.g., `devops/slos`)
  - Parent tag pages aggregate posts from all child tags
  - Subtopics section with clickable child tag pills
  - Context-aware tag badges on post cards
  - Deduplicated post counts
  - Auto-generation script for parent tag pages
- **Timeline Layout**: Chronological timeline view for list pages (desktop)
  - Year groupings with visual separators
  - Month markers with connecting lines
- **Flexible Layouts**: Single-column, two-column, or timeline per page
- **Audio Player**: Optional "Listen to Articles" TTS feature
  - Supports local, CDN, S3, Azure Blob, Cloudflare R2 storage
- **Article Features**:
  - Reading time estimation
  - Previous/Next navigation
  - Optional Table of Contents
  - Code blocks with copy button
- **Analytics**: GoatCounter and Google Analytics (GA4) support
- **Shortcodes**: Callout boxes for tips, warnings, notes, info
- **Accessibility**: Keyboard navigation, ARIA labels, focus states

### Security
- No external JavaScript dependencies (except optional analytics)
- Content Security Policy friendly

[1.0.0]: https://github.com/unseen-ants/hugo-casual-friday/releases/tag/v1.0.0
