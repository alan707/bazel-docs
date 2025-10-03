#!/usr/bin/env bash
# Create or update versioned subfolder for docs of a specific Bazel release.
#
# This script does the following:
# takes a version as the first command-line argument, such as "8.4"
# Locates the most recent tag on the bazelbuild/bazel repo that is prefixed with the version, such as "8.4.1"
# Resets the upstream/ submodule to point to that tag
# Runs the ./copy-upstream-docs.sh script to copy the docs to a new directory named after the argument, for example /8.4

set -euo pipefail

# Check if version argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <version>"
    echo "Example: $0 8.4"
    exit 1
fi

VERSION="$1"
echo "Locking to version: $VERSION"

# Use GitHub CLI to find the latest tag (with pagination)
echo "Looking for most recent tag starting with $VERSION..."
LATEST_TAG=$(gh api repos/bazelbuild/bazel/tags --paginate | jq -rs '.[] | .[] | .name' | grep -E "^$VERSION\." | grep -v "rc" | sort -V | tail -1)

if [ -z "$LATEST_TAG" ]; then
    echo "Error: No tag found starting with $VERSION"
    exit 1
fi

echo "Found latest tag: $LATEST_TAG"

# Change to upstream directory and reset to the specific tag
cd upstream
echo "Resetting submodule to tag: $LATEST_TAG"
git fetch origin "refs/tags/$LATEST_TAG:refs/tags/$LATEST_TAG"
git reset --hard "$LATEST_TAG"

# Go back to the root directory
cd ..

# Run the copy-upstream-docs.sh script with the version directory
echo "Copying docs to directory: $LATEST_TAG"
./copy-upstream-docs.sh "$LATEST_TAG"

echo "Successfully locked to version $LATEST_TAG and copied docs to $LATEST_TAG/"