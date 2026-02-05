#!/bin/bash
# Auto-generate _index.md files for parent tags
# Run this before hugo build to ensure parent tag pages exist

set -e

CONTENT_DIR="content"
TAGS_DIR="$CONTENT_DIR/tags"

echo "Scanning for parent tags..."

# Extract tags from frontmatter more precisely using awk
# This finds the tags: section and extracts items until next key
PARENT_TAGS=$(find "$CONTENT_DIR" -name "*.md" -exec awk '
    /^tags:/ { in_tags=1; next }
    in_tags && /^[a-zA-Z]/ { in_tags=0 }
    in_tags && /^\s*-\s*[a-z]+\// {
        gsub(/^\s*-\s*/, "");
        split($0, parts, "/");
        print parts[1]
    }
' {} \; | sort | uniq)

# Create _index.md for each parent tag if it doesn't exist
for parent in $PARENT_TAGS; do
    # Skip empty lines
    [ -z "$parent" ] && continue

    PARENT_DIR="$TAGS_DIR/$parent"
    INDEX_FILE="$PARENT_DIR/_index.md"

    if [ ! -f "$INDEX_FILE" ]; then
        echo "Creating $INDEX_FILE"
        mkdir -p "$PARENT_DIR"

        # Convert slug to title (handle common patterns)
        TITLE=$(echo "$parent" | sed -E '
            s/devops/DevOps/g;
            s/finops/FinOps/g;
            s/^(.)/\U\1/;
        ')

        cat > "$INDEX_FILE" << EOF
---
title: "$TITLE"
---
EOF
    else
        echo "Exists: $INDEX_FILE"
    fi
done

echo "Done!"
