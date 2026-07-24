part of '../account_kit_ohos.dart';

typedef OnViewCreated = Function(AccountKitButtonController);

class AccountKitButton extends StatelessWidget {
  final OnViewCreated onViewCreated;

  const AccountKitButton({super.key, required this.onViewCreated});

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.ohos) {
      return OhosView(
        viewType: 'account_kit_ohos/AccountKitButton',
        onPlatformViewCreated: (int viewId) {
          final controller = AccountKitButtonController.initChannel(viewId);
          onViewCreated.call(controller);
        },
        creationParams: const <String, dynamic>{},
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else {
      return Text("$defaultTargetPlatform is not supported");
    }
  }
}
