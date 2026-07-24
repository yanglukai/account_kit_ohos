part of '../account_kit_ohos.dart';

class AccountKitMethodChannel {
  final MethodChannel _channel = const MethodChannel('account_kit_ohos');

  final StreamController<AccountKitResponse> _controller =
      StreamController.broadcast();
  Stream<AccountKitResponse> get response => _controller.stream;

  factory AccountKitMethodChannel() => _getInstance();
  static AccountKitMethodChannel? _instance;
  static AccountKitMethodChannel get instance => _getInstance();
  static AccountKitMethodChannel _getInstance() {
    _instance ??= AccountKitMethodChannel._internal();
    return _instance!;
  }

  AccountKitMethodChannel._internal() {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  /// 获取匿名手机号
  Future<AccountKitResponseString> getQuickLoginAnonymousPhone() async {
    try {
      var res = await _channel.invokeMethod('getQuickLoginAnonymousPhone');
      return AccountKitResponseString(
          code: AccountKitResponseData.SUCCESS, data: res);
    } on PlatformException catch (error) {
      return AccountKitResponseString(
          code: int.tryParse(error.code), message: error.message);
    }
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case '':
        // _controller.sink.add(AccountKitResponse());
        break;
      default:
        throw MissingPluginException();
    }
  }
}
