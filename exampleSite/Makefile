# Hugo build with automatic parent tag generation
# Note: Run from exampleSite directory with theme symlinked

.PHONY: dev build clean tags

# Generate parent tag pages (script is in theme root)
tags:
	@../scripts/generate-parent-tags.sh

# Development server (runs tag generation first)
dev: tags
	hugo server -D --themesDir ../..

# Production build (runs tag generation first)
build: tags
	hugo --gc --minify --themesDir ../..

# Clean generated files
clean:
	rm -rf public resources/_gen
