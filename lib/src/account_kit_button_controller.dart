part of '../account_kit_ohos.dart';

const String channelId = 'account_kit_ohos/AccountKitButtonController';

class AccountKitButtonController {
  MethodChannel? _channel;
  final StreamController<AccountKitResponse> _controller =
      StreamController<AccountKitResponse>();
  Stream<AccountKitResponse> get dataStream => _controller.stream;

  AccountKitButtonController.initChannel(int viewId) {
    _channel = MethodChannel('${channelId}_$viewId');
    _channel?.setMethodCallHandler(_handleMethodCall);
  }

  /// 同意协议
  Future<void> agreementStatusChanged(bool accepted) async {
    try {
      await _channel?.invokeMethod('agreementStatusChanged', accepted);
    } catch (_) {}
  }

  /// 调用此方法，同意协议与登录一并完成，无需再次点击登录按钮
  Future<void> continueLogin() async {
    try {
      await _channel?.invokeMethod('continueLogin');
    } catch (_) {}
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'loginStart':
        _controller.sink
            .add(AccountKitResponse(type: AccountKitResponseType.loginStart));
        break;
      case 'loginEnd':
        _controller.sink
            .add(AccountKitResponse(type: AccountKitResponseType.loginEnd));
        break;
      case 'loginSuccess':
        var data = jsonDecode(call.arguments);
        _controller.sink.add(
          AccountKitResponse(
            type: AccountKitResponseType.loginSuccess,
            data: AccountKitResponseString.fromJson(data),
          ),
        );
        break;
      case 'loginError':
        var data = jsonDecode(call.arguments);
        _controller.sink.add(
          AccountKitResponse(
            type: AccountKitResponseType.loginError,
            data: AccountKitResponseString.fromJson(data),
          ),
        );
        break;
      case 'agreementDialogOpen':
        _controller.sink.add(AccountKitResponse(
            type: AccountKitResponseType.agreementDialogOpen));
        break;
      case 'continueLoginError':
        var data = jsonDecode(call.arguments);
        _controller.sink.add(
          AccountKitResponse(
            type: AccountKitResponseType.continueLoginError,
            data: AccountKitResponseString.fromJson(data),
          ),
        );
        break;
      default:
        throw MissingPluginException();
    }
  }

  Future close() => _controller.close();
}
