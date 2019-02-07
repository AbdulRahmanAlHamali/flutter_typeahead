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
