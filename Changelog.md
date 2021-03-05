# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Added `thematicBreak` case to `DiscussionPart` enumeration.
  929d3fe by @mattt.
- Added `authors` case to `Callout` enumeration.
  #10 by @mattt.
- Added support for custom callouts using the `Custom(<#title#>)` delimiter.
  b7eca9 by @mattt.
- Added and expanded symbol documentation throughout project.
  #12 by @mattt.

### Changed

- Changed `CommonMark` dependency to 0.5
  8ce896c by @mattt.
- Changed supported Swift versions to 5.2 and 5.3.
  #5 by @mattt.
- Changed APIs to use exported CommonMark types instead of `String`.
  #6 by @mattt.
  #8 by @mattt.
- Changed `Callout` cases to have titlecase raw values.
  #10 by @mattt.

### Fixed

- Fixed example usage in README.
  795167b by @mattt.

## [0.2.1] - 2020-05-27

### Fixed

- Fixed handling of conventional bullet list items.
  #3 by @mattt.

## [0.2.0] - 2020-05-01

### Changed

- Changed `Documentation` to adopt `Hashable`.
  ec23175 by @mattt.
- Changed `CommonMark` dependency to 0.4
  f395f3b by @mattt.

## [0.1.0] - 2020-04-10

### Added

- Added `Parameter` type.
  6f126307 by @mattt.

### Changed

- Changed `Callout` to be a top-level type.
  db4ae05 by @mattt.
- Changed `Callout` to adopt `CustomStringConvertible`.
  87265cd by @mattt.
- Changed `DiscussionPart` to be an enumeration.
  #2 by @mattt.

## [0.0.5] - 2020-03-16

### Fixed

- Fixed parsing of single parameter items.
  431f418 by @mattt.

## [0.0.4] - 2020-01-25

### Added

- Added `isEmpty` property to `Documentation`.
  b6304e76 by @mattt.

## [0.0.3] - 2020-01-24

### Changed

- Changed CommonMark dependency to 0.2.0.
  9f4e0f42 by @mattt.

## [0.0.2] - 2020-01-23

### Changed

- Changed CommonMark dependency to use tagged release.
  d6897094 by @mattt.

## [0.0.1] - 2020-01-21

Initial release.

[unreleased]: https://github.com/SwiftDocOrg/SwiftMarkup/compare/0.2.1...main
[0.2.1]: https://github.com/SwiftDocOrg/SwiftMarkup/releases/tag/0.2.1
[0.2.0]: https://github.com/SwiftDocOrg/SwiftMarkup/releases/tag/0.2.0
[0.1.0]: https://github.com/SwiftDocOrg/SwiftMarkup/releases/tag/0.1.0
[0.0.5]: https://github.com/SwiftDocOrg/SwiftMarkup/releases/tag/0.0.5
[0.0.4]: https://github.com/SwiftDocOrg/SwiftMarkup/releases/tag/0.0.4
[0.0.3]: https://github.com/SwiftDocOrg/SwiftMarkup/releases/tag/0.0.3
[0.0.2]: https://github.com/SwiftDocOrg/SwiftMarkup/releases/tag/0.0.2
[0.0.1]: https://github.com/SwiftDocOrg/SwiftMarkup/releases/tag/0.0.1
