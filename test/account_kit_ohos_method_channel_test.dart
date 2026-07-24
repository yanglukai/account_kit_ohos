import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:account_kit_ohos/account_kit_ohos_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelAccountKitOhos platform = MethodChannelAccountKitOhos();
  const MethodChannel channel = MethodChannel('account_kit_ohos');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
