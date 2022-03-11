# Changelog

All notable changes to this project will be documented in this file.
The format is based on [Keep a
Changelog](https://keepachangelog.com/en/1.0.0/).

## 2.0.0 (2022-03-10)

* Breaking changes
    * Previously, when running `pass ln TARGET LINK_NAME` where
      `LINK_NAME` referred to an existing directory, the symlink would
      be created inside `LINK_NAME` with the same basename as
      `TARGET`. This behavior has been eliminated by default, but you
      can maintain it by suffixing `LINK_NAME` with a trailing slash.
      Without a trailing slash, if `TARGET` is a directory, `pass ln`
      with exit with an error; if `TARGET` is a file, `pass ln` will
      create it, since both a file and directory can exist at the same
      path (files have a `.gpg` extension to disambiguate them).
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
