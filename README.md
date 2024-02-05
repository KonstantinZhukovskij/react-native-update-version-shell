# react-native-update-version-shell

## Description

This project is equipped with a handy bash script that automates the version update process for your React Native
app.
<br>The script will automatically update the version in App's `package.json`, Android's `build.gradle`,
iOS's `Info.plist` and `project.pbxproj`.

## Usage
To use the script, follow these steps:

1. Ensure that your `package.json` contains the "name" field.
2. Make the script executable by running the following command:

```bash
chmod +x update_version.sh
```

```bash
react-native-update-version-shell 1.2.3
```
