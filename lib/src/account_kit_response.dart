part of '../account_kit_ohos.dart';

enum AccountKitResponseType {
  loginStart,
  loginEnd,
  loginSuccess,
  loginError,
  agreementDialogOpen,
  continueLoginError,
}

abstract class AccountKitResponseData {
  static int SUCCESS = 0;

  int? code;
  String? message;
}

class AccountKitResponseString extends AccountKitResponseData {
  String? data;

  AccountKitResponseString({
    int? code,
    String? message,
    this.data,
  }) {
    this.code = code;
    this.message = message;
  }

  AccountKitResponseString.fromJson(dynamic json) {
    code = json?['code'];
    message = json?['message'];
    data = json?['data'];
  }
}

class AccountKitResponse {
  AccountKitResponseType? type;
  AccountKitResponseData? data;

  AccountKitResponse({
    this.type,
    this.data,
  });
}
