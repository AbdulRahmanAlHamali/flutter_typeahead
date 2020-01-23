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
