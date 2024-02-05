# react-native-update-helper

## Description
This small project is equipped with a handy bash script that automates the version update process for your React Native app. The script takes care of updating the version in various files, ensuring a smooth workflow for developers.

## Usage
To use the script, simply run it with the desired version number as an argument. Make sure your `package.json` has the "name" field set. The script will automatically update the version in App's `package.json`, Android's `build.gradle`, iOS's `Info.plist`, and `project.pbxproj`.

```bash
./update_version.sh 1.2.3
