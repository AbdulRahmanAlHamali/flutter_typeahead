import 'package:flutter/widgets.dart';

/// Finds the root MediaQuery of the context and depends on it.
MediaQuery? rootMediaQueryOf(BuildContext context) {
  MediaQuery? rootMediaQuery;
  context.visitAncestorElements((element) {
    if (element.widget is MediaQuery) {
      rootMediaQuery = element.widget as MediaQuery;
      context.dependOnInheritedElement(element as InheritedModelElement);
      return false;
    }
    return true;
  });

  return rootMediaQuery;
}
