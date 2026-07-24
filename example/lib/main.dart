import 'dart:async';

import 'package:account_kit_ohos/account_kit_ohos.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AccountKitButtonController buttonController;
  StreamSubscription<AccountKitResponse>? subscription;
  bool agreementStatus = false;
  String? anonymousPhone;
  String? authCode;

  @override
  void initState() {
    super.initState();
  }

  /// 获取匿名手机号（用于登录页展示）
  void getQuickLoginAnonymousPhone() async {
    AccountKitResponseString res =
        await AccountKitMethodChannel.instance.getQuickLoginAnonymousPhone();
    if (res.code == AccountKitResponseData.SUCCESS) {
      setState(() {
        anonymousPhone = res.data;
      });
    } else {
      setState(() {
        anonymousPhone = res.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('华为账号一键登录'),
        ),
        body: Container(
          child: platformView(),
        ),
      ),
    );
  }

  Widget platformView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 100),
        GestureDetector(
          onTap: getQuickLoginAnonymousPhone,
          child: Container(
            color: Colors.yellow,
            width: 300,
            height: 50,
            alignment: Alignment.center,
            child: const Text('获取虚拟手机号'),
          ),
        ),
        const SizedBox(height: 20),
        Text('anonymousPhone = ${anonymousPhone ?? ''}'),
        const SizedBox(height: 60),
        Text('authCode = ${authCode ?? ''}'),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          height: 40,
          child: AccountKitButton(
            onViewCreated: (controller) {
              buttonController = controller;
              subscription = controller.dataStream.listen((res) {
                if (res.type == AccountKitResponseType.agreementDialogOpen) {
                  setState(() {
                    authCode = '未同意协议';
                  });
                } else if (res.type == AccountKitResponseType.loginSuccess) {
                  AccountKitResponseString? resData =
                      res.data as AccountKitResponseString;
                  setState(() {
                    authCode = resData.data;
                  });
                } else if (res.type == AccountKitResponseType.loginError) {
                  AccountKitResponseString? resData =
                      res.data as AccountKitResponseString;
                  setState(() {
                    authCode = resData.message;
                  });
                }
              });
            },
          ),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            agreementStatus = !agreementStatus;
            buttonController.agreementStatusChanged(agreementStatus);
          },
          child: Container(
            color: Colors.yellow,
            width: 100,
            height: 40,
            alignment: Alignment.center,
            child: const Text('同意协议'),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }
}
