# Extract musily current version
version=$(./musily_version.sh)

# Extract the corresponding description from CHANGELOG.md
description=$(awk '/^##[[:blank:]]*'"${version}"'[[:blank:]]*$/ { flag=1; next } flag && /^##/ { flag=0 } flag { buffer=buffer $0 "\n" } END { print buffer }' "CHANGELOG.md")

# Check if the description was found
if [ -z "$description" ]; then
  echo "Description not found in $changelog_path for version $version"
  exit 1
fi

echo $description
