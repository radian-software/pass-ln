# Changelog

All notable changes to this project will be documented in this file.
The format is based on [Keep a
Changelog](https://keepachangelog.com/en/1.0.0/).

## Unreleased

* Documentation
    * Fixed a few typography issues in man page
* Bugfixes - functionality
    * Fixed issue where error handling was disabled, so all errors
      would be ignored and a zero exit status would be reported in
      almost all circumstances
* Bugfixes - packaging
    * Failing installation via Homebrew on macOS has been corrected
    * PKGBUILD now uses pluses instead of underscores in pkgver,
      following Arch packaging conventions

## 1.0.0 (2022-02-28)

Initial release of `pass-ln`.
