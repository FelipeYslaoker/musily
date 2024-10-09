version=$(grep 'version:' "pubspec.yaml" | awk '{print $2}' | awk -F'+' '{print $1}')
echo $version