# JQ Filter to fill in the docs.json file with versions and languages.
# Run with:
#   jq -f docs.jq --argfile tabs docs-tabs.json docs-no-versions.json > docs.json
#
# Reads the docs.json file to find the navigation.versions property.
# Replaces it with versions for HEAD, 8.4, 8.3
# For HEAD version, uses tabs.json content as-is
# For other versions, prepends the version to each page path

# Function to add version prefix to all page paths in tabs
def add_version_prefix(version; tabs):
  if version == "HEAD" then
    tabs
  else
    tabs | map(
      .groups = (.groups | map(
        .pages = (.pages | map(version + "/" + .))
      ))
    )
  end;

# Create versions array
.navigation.versions = [
  {
    "version": "HEAD",
    "languages": [
      {
        "language": "en",
        "tabs": add_version_prefix("HEAD"; $tabs)
      }
    ]
  },
  {
    "version": "8.4",
    "languages": [
      {
        "language": "en", 
        "tabs": add_version_prefix("8.4"; $tabs)
      }
    ]
  },
  {
    "version": "8.3",
    "languages": [
      {
        "language": "en",
        "tabs": add_version_prefix("8.3"; $tabs)
      }
    ]
  }
]
