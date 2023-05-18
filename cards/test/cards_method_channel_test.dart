import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cards/moengage_cards.dart';

void main() {
  MoEngageCards platform = MoEngageCards();
  const MethodChannel channel = MethodChannel('cards');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
}
