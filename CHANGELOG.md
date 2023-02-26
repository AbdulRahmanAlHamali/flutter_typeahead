## 4.3.7 - 26-February-2023

Update Changelog file

## 4.3.6 - 18-February-2023
Fixed visibility of cupertino decoration and formated code

## 4.3.5 - 17-February-2023
Fix in visibility of suggestions box classes

## 4.3.4 - 16-February-2023
Improved the main example to be able to read it in pub dev,

## 4.3.3 - 1-Feburary-2023

-- Apply PR to fix onSelected issue introduced in Flutter 3.7.0

## 4.3.2 - 28-January-2023

-- Update sdk level to 2.19.0 for Flutter 3.7.0

## 4.3.1 - 28-January-2023

-- PR #447 - fix: Use maybeOf for scrollable to not throw an exception in flutter …

## 4.3.0 - 15-November-2022

-- PR #436 - Added onReset callback to TypeAheadFormField
-- PR #435 - Block up and down keys

## 4.2.0 - 27-October-2022

-- PR #432 - Fix suggestions box behavior on web
-- PR #431 - Add autoFlipListDirection option

## 4.1.1 - 17-September-2022

-- PR #428 - Fix some issues with web / arrows etc.

## 4.1.0 - 5-September-2022

-- PR #409 - Add null safety to suggestions box controller
-- PR #417 - Improved support for VoiceOver/TalkBack
-- PR #418 - Feat/key up down
-- PR #422 - Adding hideKeyboardOnDrag option
-- PR #424 - Updated README: added pub.dev shield

## 4.0.0 - 15-May-2022

-- PR #395 - Fix Flutter 3.0 warnings

## 3.2.7 - 15-May-2022

-- REVERT PR #395 - Fix Flutter 3.0 warnings

## 3.2.6 - 15-May-2022

-- PR #393 - Hide suggestion on close issue fix
-- PR #395 - Fix Flutter 3.0 warnings

## 3.2.5 - 18-Apr-2022

-- PR #383 - Fix maxLengthEnforced deprecation

## 3.2.4 - 9-Dec-2021

-- PR #360 - Resize before opening box (fixes issue 220)

## 3.2.3 - 21-Nov-2021

-- PR #354 - Make maxLines nullable
-- PR #349 - Add option for min number of chars before suggestionsCallback is called
-- PR #347 - Un private some variables
-- PR #347 - Fix deprecated info's in example
-- PR #344 - Add textAlignVertical support, fixes #231

## 3.2.2 - 20-Aug-2021

-- PR #333 - support Windows and MacOS by making keyboard_visibility optional

## 3.2.1 - 10-Sept-2021

-- PR #327 - Added Scrollcontroler as optional parameter
-- PR #335 - Fix ErrorBuilder Widget display
-- PR #339 - Strong mode and type fixes

## 3.2.0 - 9-Jul-2021

-- PR #326 - file structure reorganisation
-- PR #325 - Fix Scrollbar ScrollController

## 3.1.3 - 7-May-2021

-- PR #308 - Allow suggestionsCallback to return null

## 3.1.2 - 1-May-2021

-- PR #303 - Guard against missing size in \_adjustMaxHeightAndOrientation
-- PR #306 - Fixed Issue #286 - Suggestions callback called immediately

## 3.1.1 - 28-March-2021

-- PR #297 - Fix styling of CHANGELOG.md

## 3.1.0 - 21-March-2021

-- PR #295 - autoFillHints for TextFieldConfiguration
-- PR #294 - Check if the overlay is open
-- PR #292 - Various bug fixes, including null safety
-- PR #291 - Check for platform and run the correct example demo
-- PR #287 - Cancel the debounce timer when widget is destroyed
-- PR #285 - Fix possible race condition by doing an await

## 3.0.0-nullsafety.0 - 9-Feburary-2021

-- PR #290 Null-safety pre-release

## 2.0.0 - 11-January-2021

-- NOTE!! BREAKING CHANGE! Not major but changed Types for some calls
-- RE-APPLY : 1.9.2 will become 2.0.0

## 1.9.3 - 10-January-2021

-- REVERT : Reverting back to 1.9.1 as 1.9.3. 1.9.2 will become 2.0.0

## 1.9.2 - 06-January-2021

-- #267 : Remove undeeded typecasts and add String types

## 1.9.1 - 03-December-2020

-- #256 : Change default to disabled for autovalidateMode and fix typo

## 1.9.0 - 01-December-2020

- Merged 4 PRs:
  -- #238 : Added hideKeyboard even if textfield has focus (edge case)
  -- #248 : Added enabled and autovalidateMode properties. Resolves Issue #247
  -- #249 : Added enableSuggestions to Textfield Configuration. Resolves Issue #210
  -- #255 : Update to use flutter_keyboard_visibility 4.X from 3.X

## 1.8.8 - 12-August-2020

- Merged PR to fix typo and validator tests and examples using deprecated consts.

## 1.8.7 - 30-July-2020

- Merged PR to fix dispose() error in tests.

## 1.8.6 - 05/07/2020

- Merged PR to fix "flashing" bug.

## 1.8.5 - 01/07/2020

- Dependency Update : Updated flutter_Keyboard_visibility to ^3.0.0 from ^2.0.0

## 1.8.4 - 30/06/2020

- Bug Fix : Merged 3 PRs for various bug fixes.

## 1.8.3 - 11/06/2020

- Bug Fix : PR to address keyboard visibility issues from @alphamikle

## 1.8.1 - 08/04/2020

- Bug fixes

## 1.8.0 - 23/01/2020

- Change from List to Iterable for flexibility
- Added `onTap` property to `TextFieldConfiguration`
- Added `offsetX` property to `SuggestionsBoxDecoration` and `CupertinoSuggestionsBoxDecoration`
- Support iOS 13 dark mode
- Bug fixes

## 1.7.0 - 16/10/2019

- Updated keyboard_visibility dependency
- Scolling bug fix
- Added new property `enableInteractiveSelection`
- Fix disposing overlay

Thanks to MisterJimson, davidmartos96, pparadox11, diegoveloper

## 1.6.1 - 05/06/2019

- Fixed onChanged not being called for TypeAheadFormField

## 1.6.0 - 19/05/2019

- Added CupertinoTypeAheadField for Cupertino users
- Updated example project
- Bug fixes

## 1.5.0 - 25/04/2019

- Added `suggestionsBoxController` property and `SuggestionsBoxController` class to allow manual control of the suggestions box
- Fix suggestions box height problems in dialogs
- Add `textDirection` property to `TextFieldConfiguration`

## 1.4.1 - 09/04/2019

- Fixed BoxConstraints width parameters being ignored in `SuggestionsBoxDecoration`

## 1.4.0 - 26/03/2019

- Added property `autoFlipDirection` to allow automatic direction flipping if
  there is not enough space for the suggestions list

## 1.3.0 - 19/03/2019

- Limit number of suggestionsCallbacks until current call is finished

## 1.2.1 - 19/03/2019

- Bug fixes & optimizations

## 1.2.0 - 05/03/2019

- Added property `keepSuggestionsOnLoading`
- Changed default behavior: suggestions box will no longer
  show circular progress indicator when loading; it will maintain previous results if available

## 1.1.0 - 01/03/2019

- Suggestions box now closes on keyboard hide by default
- Added property `hideSuggestionsOnKeyboardHide`
- Width now properly resizes on orientation changes
- Suggestions box will display above keyboard when keyboard hides the box for AxisDirection.Up
- Fix FocusNode errors
- Fix keyboard height calculation

## 1.0.4/5 - 21/02/2019

- Fix suggestions being called on TextBox focus

## 1.0.3 - 12/02/2019

- Resize suggestion box when scrolling

## 1.0.2 - 07/02/2019

- Bug fix for `maxHeight` property

## 1.0.1 - 06/02/2019

- Added properties `hideOnLoading`, `hideOnEmpty`, and `hideOnError` to hide the suggestions box

## 0.6.1 - 26/01/2019

- Allow types <T> to properly work.
- Add documentation for direction: option.

## 0.6.0 - 23/01/2019

- Added property `direction` to allow the suggestions to grow either up or down

## 0.5.2 - 19/01/2019

- Added contributing guidelines and reverse sorted the CHANGLELOG.md file.

## 0.5.1 - 10/01/2019

- Bug fixes

## 0.5.0 - 05/01/2019

- Added the hasScrollbar property which allows the optional display of a `Scrollbar`
- Fixed the case where the suggestion box becomes hidden behind the keyboard
- Fixed the bug of not disposing the animations controller

## 0.4.1 - 20/09/2018

- Added property `getImmediateSuggestions` to the form field implementation

## 0.4.0 - 20/09/2018

- Added property `getImmediateSuggestions` to allow fetching
  suggestions before the user types
- Added assertion in the form field to disallow having `initialValue`
  and `textFieldConfiguration.controller` defined at the same time

## 0.3.0 - 15/09/2018

- Added a constraints property to the `SuggestionsBoxDecorations`
  which allows to set the height and width of the suggestions box

## 0.2.1 - 04/09/2018

- Added mention of 'autocomplete' in README and pubspec
- Executed 'flutter format'

## 0.2.0 - 02/09/2018

- Changed the suggestions box decoration
  to decorate a material sheet instead of
  decorating a container
- Moved the `TextField` properties inside a class
  called `TextFieldConfiguration`, which is provided
  to the `TypeAhead` widgets through a
  `textFieldConfiguration` property. This was done to
  decrease the clutter in the interface
- Added more configuration properties to the
  `TextField`
- Added a configurable vertical offset for the
  suggestions box
- Changed the mechanism used to open/close the suggestions box
- Added meta-tags to README for SEO
- Updated the GIF to show the changes
- Added "How you can help" section to README

## 0.1.2 - 31/08/2018

- Small fix to README

## 0.1.1 - 31/08/2018

- Fixed CHANGELOG.
- Small fix to documentation

## 0.1.0 - 31/08/2018

- Initial Release.
