#!/usr/bin/env bash
# Update docs-versions.txt with the latest patch version for each minor version
# This script fetches all Bazel tags and finds the most recent patch for each minor version

set -euo pipefail

echo "Fetching Bazel tags and finding latest patch versions..."

# Get all tags once and store in temporary file
TAGS_FILE=$(mktemp)
gh api repos/bazelbuild/bazel/tags --paginate | \
  jq -rs '.[] | .[] | .name' | \
  grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' | \
  grep -v "rc" > "$TAGS_FILE"

# Extract unique minor versions (skip versions earlier than 5.4)
MINOR_VERSIONS=$(cat "$TAGS_FILE" | \
  sed 's/\.[0-9]*$//' | \
  sort -V | \
  awk -F. '$1 > 5 || ($1 == 5 && $2 >= 4)' | \
  uniq)

echo "Found minor versions: $MINOR_VERSIONS"

# Create temporary file for versions
TEMP_FILE=$(mktemp)

# For each minor version, find the latest patch from the cached tags
for minor in $MINOR_VERSIONS; do
  echo "Finding latest patch for $minor..."
  
  # Get the latest patch version for this minor version from cached data
  LATEST_PATCH=$(grep -E "^$minor\.[0-9]+$" "$TAGS_FILE" | \
    sort -V | \
    tail -1)
  
  if [ -n "$LATEST_PATCH" ]; then
    echo "$LATEST_PATCH" >> "$TEMP_FILE"
    echo "  → $LATEST_PATCH"
  else
    echo "  → No stable patch found for $minor"
  fi
done

# Clean up tags file
rm "$TAGS_FILE"

# Sort the versions in reverse order (newest first) and add HEAD at the end
echo "Writing versions to docs-versions.json..."
sort -Vr "$TEMP_FILE" > temp_sorted.txt
echo "HEAD" >> temp_sorted.txt

# Convert to JSON array
jq -R -s 'split("\n") | map(select(length > 0))' temp_sorted.txt > docs-versions.json

# Clean up
rm "$TEMP_FILE" temp_sorted.txt

echo "Updated docs-versions.json with $(jq length docs-versions.json) versions:"
jq -r '.[]' docs-versions.json
