# Dropbox Swift Lint

A fork of swift-lint.

## Overview

## Install

To rebase and generate a binary:
`./build_and_run`
This will copy the 

## Development Tips for Adding a Rule
`sourcekitten structure --file ./Sources/LintTestProject/FooPresenter.swift`

## Instructions to Add New Rule

- add to Rules folder
- add correctly to xcode project
- run make sourcery

## Instructions to Run in a Project

Add run script to build phases:
```
if which swiftlintdropbox >/dev/null; then
  swiftlintdropbox
else
  echo "warning: SwiftLintDropbox not installed"
fi
```
Add `.swiftlintdropbox.yml` config file.

