import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/src/common/base/connector_widget.dart';

void main() {
  group('ConnectorWidget Tests', () {
    testWidgets('calls connect on create', (WidgetTester tester) async {
      bool connectCalled = false;

      await tester.pumpWidget(
        ConnectorWidget<int, String>(
          value: 1,
          connect: (value) {
            connectCalled = true;
            return 'key';
          },
          child: Container(),
        ),
      );

      expect(connectCalled, isTrue);
    });

    testWidgets('calls disconnect on dispose', (WidgetTester tester) async {
      bool disconnectCalled = false;

      await tester.pumpWidget(
        ConnectorWidget<int, String>(
          value: 1,
          connect: (value) => 'key',
          disconnect: (value, key) {
            disconnectCalled = true;
          },
          child: Container(),
        ),
      );

      await tester.pumpWidget(Container());

      expect(disconnectCalled, isTrue);
    });

    testWidgets('calls connect and disconnect on value change',
        (WidgetTester tester) async {
      bool connectCalled = false;
      bool disconnectCalled = false;

      await tester.pumpWidget(
        ConnectorWidget<int, String>(
          value: 1,
          connect: (value) {
            connectCalled = true;
            return 'key';
          },
          disconnect: (value, key) {
            disconnectCalled = true;
          },
          child: Container(),
        ),
      );

      connectCalled = false;
      disconnectCalled = false;

      await tester.pumpWidget(
        ConnectorWidget<int, String>(
          value: 2,
          connect: (value) {
            connectCalled = true;
            return 'key';
          },
          disconnect: (value, key) {
            disconnectCalled = true;
          },
          child: Container(),
        ),
      );

      expect(connectCalled, isTrue);
      expect(disconnectCalled, isTrue);
    });

    testWidgets('calls disconnect with correct key',
        (WidgetTester tester) async {
      int? disconnectKey;

      await tester.pumpWidget(
        ConnectorWidget<int, int>(
          value: 1,
          connect: (value) => value,
          disconnect: (value, key) => disconnectKey = key,
          child: Container(),
        ),
      );

      await tester.pumpWidget(
        ConnectorWidget<int, int>(
          value: 2,
          connect: (value) => value,
          disconnect: (value, key) => disconnectKey = key,
          child: Container(),
        ),
      );

      expect(disconnectKey, equals(1));
      disconnectKey = null;

      await tester.pumpWidget(Container());

      expect(disconnectKey, equals(2));
    });
  });
}
