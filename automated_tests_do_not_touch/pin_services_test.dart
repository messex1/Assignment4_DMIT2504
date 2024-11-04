// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:assignment_04/services/pin_services.dart';

void main() {
  var pin = '12345678';
  var hash = 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f';
  group('PinServices', () {
    test('Test hashPin()', () {
      var hashValue = hashPin(pin);
      expect(hashValue, hash);
    });
    testWidgets('Test storePin()', (tester) async {
      SharedPreferences.setMockInitialValues({});
      await storePin(pin);
      expect((await SharedPreferences.getInstance()).getString('pin'), hash);
    });
    testWidgets('Test checkPin()', (tester) async {
      final Map<String, Object> values = <String, Object>{'pin': hash};
      SharedPreferences.setMockInitialValues({});
      expect(await checkPin(pin), false);
      SharedPreferences.setMockInitialValues(values);
      expect(await checkPin(pin), true);
    });
    testWidgets('Test pinStored()', (tester) async {
      final Map<String, Object> values = <String, Object>{'pin': hash};
      SharedPreferences.setMockInitialValues({});
      expect(await pinStored(), false);
      SharedPreferences.setMockInitialValues(values);
      expect(await pinStored(), true);
    });
  });
}
