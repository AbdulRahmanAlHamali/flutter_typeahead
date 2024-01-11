# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project
adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased
### Added
- Returning null from `suggestionsCallback` hides the box

## 5.0.2 - 2024-01-11
### Changed
- Upgraded flutter\_keyboard\_visibility: ^5.4.1 to ^6.0.0
- Upgraded pointer\_interceptor: ^0.9.3+6 to ^0.10.0

### Fixed
- dispose error in suggestions search

## 5.0.1 - 2023-11-27
### Fixed
- SetState error in suggestions box

## 5.0.0 - 2023-11-25
### Added
- Custom `TextField` builder via the `builder` property, replacing `TextFieldConfiguration`
- `decorationBuilder` property for customizing `SuggestionsBox` decoration
- Suggestions state (items, loading, error) in `SuggestionsController`
- Streams in `SuggestionsController` for notification of selected suggestions

### Changed
- Renamed `SuggestionsBoxController` to `SuggestionsController`
- Renamed `layoutArchitecture` to `listBuilder`
- Renamed `noItemsFoundBuilder` to `emptyBuilder`
- Renamed `onSuggestionSelected` to `onSelected`
- Renamed `suggestionsBoxVerticalOffset` to `offset`, now including horizontal offset
- Renamed `hideSuggestionsOnKeyboardHide` to `hideWithKeyboard`
- Renamed `keepSuggestionsOnSuggestionSelected` to `hideOnSelect` and inverted its functionality
- Renamed `keepSuggestionsOnLoading` to `retainOnLoading`

### Removed
- `SuggestionsBoxDecoration`, replaced by `decorationBuilder`
- `TextFieldConfiguration`, replaced by custom `TextField` builder
- `CupertinoSuggestionsBoxController` in favor of `SuggestionsController`
- `TypeAheadFormFiled`, replaced by custom `TextField` builder
- `intercepting` parameter (now always true)
- `onSuggestionsBoxToggle` parameter (replaced with subscriptions to `SuggestionsController`)
- `ignoreAccessibleNavigation` parameter (no longer required with new `Overlay` code)
- `animationStart` parameter (use animation mapping)
- `minCharsForSuggestions` parameter (implement in client code)
- `autoFlipListDirection` parameter (use `listBuilder`)

## 4.8.0 - 2023-09-24
### Changed
- General cleanup of the codebase (#523)

## 4.7.0 - 2023-09-05
### Added
- `expands` property to TextFieldConfiguration (#512)
- `scrollbarAlwaysVisible` argument (#512)

### Fixed
- `ignoreAccessibleNavigation` flag to prevent non-selection bug (#512)

## 4.6.2 - 2023-06-19
### Added
- `itemSeparatorBuilder` to Material `TypeAheadFormField` (#500)

## 4.6.1 - 2023-06-04
### Fixed
- Issue with scrollbar click-through (#494)
- Mouse events propagating through the `SuggestionBox` to the underlying `HTMLElementView` (#495)

## 4.6.0 - 2023-05-29
### Added
- Support for alternative layouts of results, such as Grid (#493)

## 4.5.0 - 2023-05-28
### Added
- `itemSeparatorBuilder` option (#489)
- `autofillHints` properties (#489)

### Fixed
- Removed top padding on scrollbar (#489)

## 4.4.0 - 2023-05-20
### Added
- `onTapOutside` callback to typeahead (#486)
- Placeholder style customization (#485)
- `autoFlipMinHeight` option (#468)

## 4.3.8 - 2023-04-30
### Fixed
- Incorrect vertical offset calculation of suggestion box for Flutter mobile web (#484)

## 4.3.7 - 2023-02-26
### Changed
- Updated the changelog file

## 4.3.6 - 2023-02-18
### Fixed
- Visibility of Cupertino decoration and formatted code

## 4.3.5 - 2023-02-17
### Fixed
- Visibility of suggestions box classes

## 4.3.4 - 2023-02-16
### Changed
- Improved the main example for better readability on pub.dev

## 4.3.3 - 2023-02-01
### Fixed
- Applied PR to fix `onSelected` issue introduced in Flutter 3.7.0

## 4.3.2 - 2023-01-28
### Changed
- Updated SDK level to 2.19.0 for Flutter 3.7.0

## 4.3.1 - 2023-01-28
### Fixed
- Used `maybeOf` for scrollable to prevent exceptions in Flutter (#47)

## 4.3.0 - 2022-11-15
### Added
- `onReset` callback to `TypeAheadFormField` (#36)
- Feature to block up and down keys (#35)

## 4.2.0 - 2022-10-27
### Added
- `autoFlipListDirection` option (#31)

### Fixed
- Suggestions box behavior on web platforms (#32)

## 4.1.1 - 2022-09-17
### Fixed
- Issues with web platforms and arrow keys (#28)

## 4.1.0 - 2022-09-05
### Added
- Null safety to suggestions box controller (#09)
- Improved support for VoiceOver/TalkBack (#17)
- Key up and down features (#18)
- `hideKeyboardOnDrag` option (#22)

### Changed
- Updated README with a pub.dev shield (#24)

## 4.0.0 - 2022-05-15
### Fixed
- Warnings related to Flutter 3.0 (#95)

## 3.2.7 - 2022-05-15
### Changed
- Reverted previous fix for Flutter 3.0 warnings (#95)

## 3.2.6 - 2022-05-15
### Fixed
- Issue of suggestions not hiding on close (#93)
- Warnings related to Flutter 3.0 (#95)

## 3.2.5 - 2022-04-18
### Fixed
- Deprecated `maxLengthEnforced` property (#83)

## 3.2.4 - 2021-12-09
### Fixed
- Resizing issue before opening the suggestion box (#60)

## 3.2.3 - 2021-11-21
### Added
- Option for minimum number of characters before `suggestionsCallback` is called (#49)
- Support for `textAlignVertical` (#44)

### Changed
- Made `maxLines` nullable (#54)
- Made some variables public (#47)

### Fixed
- Deprecated information in example (#47)

## 3.2.1 - 2021-09-10
### Added
- `Scrollcontroller` as an optional parameter (#27)

### Fixed
- Display issues with `ErrorBuilder` Widget (#35)
- Strong mode and type issues (#39)

## 3.2.2 - 2021-08-20
### Added
- Support for Windows and MacOS by making `keyboard_visibility` optional (#33)

## 3.2.0 - 2021-07-09
### Changed
- File structure reorganization (#26)

### Fixed
- Scrollbar `ScrollController` issue (#25)

## 3.1.3 - 2021-05-07
### Changed
- Allowed `suggestionsCallback` to return null (#08)

## 3.1.2 - 2021-05-01
### Fixed
- Missing size guard in `_adjustMaxHeightAndOrientation` (#03)
- Issue with suggestions callback being called immediately (#06)

## 3.1.1 - 2021-03-28
### Fixed
- Styling of CHANGELOG.md (#97)

## 3.1.0 - 2021-03-21
### Added
- `autoFillHints` for `TextFieldConfiguration` (#95)
- Feature to check if the overlay is open (#94)
- Check for platform and run the correct example demo (#91)

### Fixed
- Various bug fixes, including null safety (#92)
- Cancel the debounce timer when widget is destroyed (#87)
- possible race condition with await (#85)

## 3.0.0-nullsafety.0 - 2021-02-09
### Changed
- Null-safety pre-release (#90)

## 2.1.0-nullsafety.0 - 2021-01-21
### Changed
- Opt into null-safety

## 2.0.0 - 2021-01-11
### Changed
- Re-applied changes from 1.9.2
- Types for some calls

## 1.9.3 - 2021-01-10
### Changed
- Reverted back to settings of 1.9.1; changes in 1.9.2 will be part of 2.0.0

## 1.9.2 - 2021-01-06
### Fixed
- Removed unneeded typecasts and added String types (#267)

## 1.9.1 - 2020-12-03
### Fixed
- Changed default setting to disabled for `autovalidateMode` and fixed typo (#256)

## 1.9.0 - 2020-12-01
### Added
- `hideKeyboard` property to handle edge cases where text field has focus (#238)
- `enabled` and `autovalidateMode` properties (#248)
- `enableSuggestions` to TextField Configuration (#249)

### Changed
- Updated `flutter_keyboard_visibility` to version 4.X (#255)

## 1.8.8 - 2020-08-12
### Fixed
- Fixed typos and updated validator tests and examples to remove deprecated constants

## 1.8.7 - 2020-07-30
### Fixed
- Fixed `dispose()` error in tests

## 1.8.6 - 2020-07-05
### Fixed
- Fixed "flashing" bug

## 1.8.5 - 2020-07-01
### Changed
- Updated `flutter_Keyboard_visibility` dependency to ^3.0.0

## 1.8.4 - 2020-06-30
### Added
- suggestions box clip parameter

### Fixed
- Erratic suggestions callback behaviour
- Exception with cut/paste

## 1.8.3 - 2020-06-11
### Fixed
- Addressed keyboard visibility issues (contribution from @alphamikle)

## 1.8.2 - 2020-04-12
### Fixed
- Various issues

## 1.8.1 - 2020-04-08
### Fixed
- Various issues

## 1.8.0 - 2020-01-23
### Added
- `onTap` property to `TextFieldConfiguration`
- `offsetX` property to `SuggestionsBoxDecoration` and `CupertinoSuggestionsBoxDecoration`
- Support for iOS 13 dark mode

### Changed
- Switched from List to Iterable for flexibility

### Fixed
- Various issues

## 1.7.0 - 2019-10-16
### Added
- `enableInteractiveSelection` property

### Changed
- Updated `keyboard_visibility` dependency

### Fixed
- Scrolling bug
- Disposing overlay issue

## 1.6.1 - 2019-06-05
### Fixed
- `onChanged` now properly triggers for TypeAheadFormField

## 1.6.0 - 2019-05-19
### Added
- `CupertinoTypeAheadField` for Cupertino users

### Changed
- Updated example project

### Fixed
- Various issues

## 1.5.0 - 2019-04-25
### Added
- `suggestionsBoxController` property and `SuggestionsBoxController` class for manual control
- `textDirection` property to `TextFieldConfiguration`

### Fixed
- Height issues of suggestions box in dialogs

## 1.4.1 - 2019-04-09
### Fixed
- Width parameters in `BoxConstraints` are now respected in `SuggestionsBoxDecoration`

## 1.4.0 - 2019-03-26
### Added
- `autoFlipDirection` property for automatic direction flipping of the suggestions list when space is limited

## 1.3.0 - 2019-03-19
### Changed
- Limited the number of `suggestionsCallbacks` until the current call is finished

## 1.2.1 - 2019-03-19
### Changed
- Optimizations

### Fixed
- Various issues

## 1.2.0 - 2019-03-05
### Added
- Property `keepSuggestionsOnLoading` for maintaining suggestions during loading

### Changed
- Suggestions box no longer shows circular progress indicator by default when loading

## 1.1.0 - 2019-03-01
### Added
- Property `hideSuggestionsOnKeyboardHide` to control suggestions box behavior

### Changed
- Suggestions box now closes by default when keyboard hides
- Width resizes properly on orientation changes
- Suggestions box displays above the keyboard for AxisDirection.Up

### Fixed
- FocusNode errors
- Keyboard height calculation errors

## 1.0.5 - 2019-02-21
### Fixed
- Suggestions no longer called on TextBox focus

## 1.0.4 - 2019-02-21
### Fixed
- Suggestions no longer called on TextBox focus

## 1.0.3 - 2019-02-12
### Changed
- Suggestions box resizes when scrolling

## 1.0.2 - 2019-02-07
### Fixed
- Bug in `maxHeight` property

## 0.7.0 - 2019-02-07
### Added
- Added properties `hideOnLoading`, `hideOnEmpty`, and `hideOnError` to hide the suggestions box

## 1.0.1 - 2019-02-06
### Added
- Properties `hideOnLoading`, `hideOnEmpty`, `hideOnError` to control visibility of suggestions box

## 0.6.1 - 2019-01-26
### Added
- Documentation for the `direction` option

### Fixed
- Types <T> now work properly

## 0.6.0 - 2019-01-23
### Added
- Property `direction` for controlling the growth direction of suggestions

## 0.5.2 - 2019-01-19
### Added
- Contributing guidelines

### Changed
- CHANGLELOG.md is now reverse sorted

## 0.5.1 - 2019-01-10
### Fixed
- Various issues

## 0.5.0 - 2019-01-05
### Added
- `hasScrollbar` property for optional scrollbar display

### Fixed
- Suggestion box no longer hides behind the keyboard
- Animations controller is now properly disposed

## 0.4.1 - 2018-09-20
### Added
- Property `getImmediateSuggestions` to the form field implementation

## 0.4.0 - 2018-09-20
### Added
- `getImmediateSuggestions` property for fetching suggestions before user input

### Changed
- Added assertion to disallow simultaneous definition of `initialValue` and `textFieldConfiguration.controller`

## 0.3.0 - 2018-09-15
### Added
- Constraints property to the `SuggestionsBoxDecorations` allowing setting of the height and width of the suggestions box

## 0.2.1 - 2018-09-04
### Added
- Mention of 'autocomplete' in README and pubspec

### Changed
- Executed 'flutter format'

## 0.2.0 - 2018-09-02
### Added
- More configuration properties to the `TextField`
- Configurable vertical offset for the suggestions box
- Meta-tags to README for SEO
- "How you can help" section to README

### Changed
- Suggestions box decoration
- Moved the `TextField` properties inside a class
- Mechanism used to open/close the suggestions box
- Updated the GIF to show the changes

## 0.1.2 - 2018-08-31
### Fixed
- Small issue in README

## 0.1.1 - 2018-08-31
### Fixed
- CHANGELOG format
- Small issue in documentation

## 0.1.0 - 2018-08-31
### Added
- Initial Release
