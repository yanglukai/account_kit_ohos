# account_kit_ohos

[![pub package](https://img.shields.io/pub/v/account_kit_ohos.svg)](https://pub.dev/packages/account_kit_ohos)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A Flutter plugin for HarmonyOS to integrate Huawei Account Quick Login.

`account_kit_ohos` 是一个专为 HarmonyOS 打造的 Flutter 插件，封装了华为 **Account Kit** 的一键登录能力。

通过集成此插件，开发者可以快速实现**手机号一键登录**、获取 **UnionID/OpenID** 等功能，大幅简化用户注册/登录流程，提升转化率。

> 📖 **官方文档**：[HarmonyOS Account Kit 指南](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/account-phone-unionid-login)

---

## ✨ 功能特性

- 🚀 **一键登录**：基于本机号码校验，用户无需输入密码，点击即可完成登录。
- 🆔 **统一标识**：支持获取 UnionID / OpenID，方便跨应用/跨端用户体系打通。
- 📱 **多端适配**：完美支持 HarmonyOS Phone、Tablet、2in1 等设备。
- 🛡️ **安全可靠**：Token 在服务端校验，客户端不接触敏感隐私数据。
- 🎨 **原生 UI**：提供符合 HarmonyOS 设计规范的登录按钮组件。

---

## 📋 前置准备

在使用插件前，请务必完成以下配置：

1. **注册开发者**：在 [华为开发者联盟](https://developer.huawei.com/consumer/cn/) 注册并完成实名认证。
2. **创建应用**：在 AppGallery Connect 中创建应用，并开启 **Account Kit** 服务。
3. **配置签名**：在后台配置应用的签名证书指纹（SHA-256）。
4. **申请权限**：申请 `quickLogin`（一键登录）相关权限。

---

## 🚀 快速开始

### 1. 添加依赖

在 `pubspec.yaml` 中添加：

```yaml
dependencies:
  account_kit_ohos: ^0.0.1
```

### 2. 导入包

```dart
import 'package:account_kit_ohos/account_kit_ohos.dart';
```

### 3. 代码示例

#### 获取匿名手机号（用于登录页展示）
```dart
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
```

#### 使用官方登录按钮
```dart
Widget buildAccountKitButton() {
  return AccountKitButton(
    onViewCreated: (controller) {
      buttonController = controller;
      subscription = controller.dataStream.listen((res) {
        if (res.type == AccountKitResponseType.agreementDialogOpen) {
          setState(() {
            authCode = '未同意协议';
          });
        } else if (res.type == AccountKitResponseType.loginSuccess) {
          // 获取 Authorization Code
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
  );
}
```

#### 同意隐私协议
```dart
buttonController.agreementStatusChanged(true);
```

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---






