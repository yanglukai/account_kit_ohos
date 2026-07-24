import 'package:flutter_test/flutter_test.dart';
import 'package:account_kit_ohos/account_kit_ohos.dart';
import 'package:account_kit_ohos/account_kit_ohos_platform_interface.dart';
import 'package:account_kit_ohos/account_kit_ohos_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAccountKitOhosPlatform
    with MockPlatformInterfaceMixin
    implements AccountKitOhosPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AccountKitOhosPlatform initialPlatform = AccountKitOhosPlatform.instance;

  test('$MethodChannelAccountKitOhos is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAccountKitOhos>());
  });

  test('getPlatformVersion', () async {
    AccountKitOhos accountKitOhosPlugin = AccountKitOhos();
    MockAccountKitOhosPlatform fakePlatform = MockAccountKitOhosPlatform();
    AccountKitOhosPlatform.instance = fakePlatform;

    expect(await accountKitOhosPlugin.getPlatformVersion(), '42');
  });
}
