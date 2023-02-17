import 'package:flutter/material.dart';

@visibleForTesting
class TestKeys {
  TestKeys._();

  static const textFieldKey = ValueKey("text-field");
  static ValueKey<String> getSuggestionKey(int index) =>
      ValueKey<String>("suggestion-$index");
}