#!/bin/bash
# Usage: ./publish.sh /path/to/document.odt

if [ -z "$1" ]; then
    echo "Error: Please specify a LibreOffice .odt file."
    echo "Usage: ./publish.sh ~/Documents/my-guide.odt"
    exit 1
fi

ODT_FILE="$1"
FILENAME=$(basename "$ODT_FILE" .odt)
HUGO_DIR="$HOME/Website"

echo "Converting $FILENAME.odt to Markdown..."

# Extract media & convert ODT to Hugo Markdown
pandoc -f odt -t markdown_strict+yaml_metadata_block "$ODT_FILE" \
  -o "$HUGO_DIR/content/posts/$FILENAME.md" \
  --extract-media="$HUGO_DIR/static/images/$FILENAME"

echo "Deploying to GitHub..."
cd "$HUGO_DIR"
git add .
git commit -m "Published $FILENAME"
git push origin main

echo "----------------------------------------"
echo "Done! Your site will update live in ~60 seconds."
echo "----------------------------------------"
