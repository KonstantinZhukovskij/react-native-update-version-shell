#!/bin/bash

update_package_json() {
  sed -i '' -e "s/\"version\": \".*\"/\"version\": \"$1\"/" package.json
}

update_build_gradle() {
  sed -i '' -e "s/versionName \".*\"/versionName \"$1\"/" android/app/build.gradle

  current_version_code=$(awk -F 'versionCode ' '/versionCode/ {print $2}' android/app/build.gradle | awk '{print $1}')
  new_version_code=$((current_version_code + 1))
  sed -i '' -e "s/versionCode $current_version_code/versionCode $new_version_code/" android/app/build.gradle
}

update_info_plist() {
  current_bundle_version=$(plutil -p ios/$APP_NAME/Info.plist | grep CFBundleVersion | awk '{print $3}' | tr -d ';"')
  new_bundle_version=$((current_bundle_version + 1))
  plutil -replace CFBundleShortVersionString -string $1 ios/$APP_NAME/Info.plist
  plutil -replace CFBundleVersion -string $new_bundle_version ios/$APP_NAME/Info.plist
}

increment_current_project_version() {
  current_project_version=$(sed -n '/CURRENT_PROJECT_VERSION/{s/CURRENT_PROJECT_VERSION = //;s/;//;s/^[[:space:]]*//;p;q;}' ios/$APP_NAME.xcodeproj/project.pbxproj)
  new_project_version=$((current_project_version + 1))
  perl -pi -e "s/CURRENT_PROJECT_VERSION = $current_project_version;/CURRENT_PROJECT_VERSION = $new_project_version;/" ios/$APP_NAME.xcodeproj/project.pbxproj
}

if [ -z "$1" ]; then
  echo "Please provide the version number"
  exit 1
fi

APP_NAME=$(grep -E '"name":' package.json | awk -F'"' '{print $4}')

if [ -z "$APP_NAME" ]; then
  echo "Error: App name not found in package.json. Please set the 'name' field in package.json"
  exit 1
fi

VERSION=$1

update_package_json $VERSION
update_build_gradle $VERSION
update_info_plist $VERSION
increment_current_project_version

echo "App version updated to: $VERSION"
