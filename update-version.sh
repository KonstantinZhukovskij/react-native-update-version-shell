#!/bin/bash

if [ -z "$1" ]; then
  echo "Please provide the version number"
  exit 1
fi

VERSION=$1

update_package_json() {
  sed -i '' -e "s/\"version\": \".*\"/\"version\": \"$VERSION\"/" package.json
}

update_build_gradle() {
  sed -i '' -e "s/versionName \".*\"/versionName \"$VERSION\"/" android/app/build.gradle

  current_version_code=$(awk -F 'versionCode ' '/versionCode/ {print $2}' android/app/build.gradle | awk '{print $1}')
  new_version_code=$((current_version_code + 1))
  sed -i '' -e "s/versionCode $current_version_code/versionCode $new_version_code/" android/app/build.gradle
}

update_info_plist() {
  current_bundle_version=$(plutil -p ios/$APP_NAME/Info.plist | grep CFBundleVersion | awk '{print $3}' | tr -d ';"')
  new_bundle_version=$((current_bundle_version + 1))
  plutil -replace CFBundleShortVersionString -string $VERSION ios/$APP_NAME/Info.plist
  plutil -replace CFBundleVersion -string $new_bundle_version ios/$APP_NAME/Info.plist
}

update_pbxproj() {
  current_project_version=$(sed -n '/CURRENT_PROJECT_VERSION/{s/CURRENT_PROJECT_VERSION = //;s/;//;s/^[[:space:]]*//;p;q;}' ios/$APP_NAME.xcodeproj/project.pbxproj)
  new_project_version=$((current_project_version + 1))
  perl -pi -e "s/CURRENT_PROJECT_VERSION = $current_project_version;/CURRENT_PROJECT_VERSION = $new_project_version;/" ios/$APP_NAME.xcodeproj/project.pbxproj
}

APP_NAME=$(grep -E '"name":' package.json | awk -F'"' '{print $4}')

if [ -z "$APP_NAME" ]; then
  echo "Error: App name not found in package.json. Please set the 'name' field in package.json"
  exit 1
fi

update_package_json
update_build_gradle
update_info_plist
update_pbxproj

echo "App version updated to: $VERSION"
