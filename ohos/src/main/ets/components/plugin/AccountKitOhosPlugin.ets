import {
  FlutterPlugin,
  FlutterPluginBinding,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
  StandardMessageCodec,
} from '@ohos/flutter_ohos';

import { CustomFactory } from './account_kit/AccountKitFactory';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { getQuickLoginAnonymousPhone, domainId, logTag, dealAllError } from './account_kit/Utils';

/** AccountKitOhosPlugin **/
export default class AccountKitOhosPlugin implements FlutterPlugin, MethodCallHandler {
  private channel: MethodChannel | null = null;

  constructor() {
  }

  getUniqueClassName(): string {
    return "AccountKitOhosPlugin"
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), "account_kit_ohos");
    this.channel.setMethodCallHandler(this)
    binding.getPlatformViewRegistry()?.registerViewFactory('account_kit_ohos/AccountKitButton', new CustomFactory(binding.getBinaryMessenger(), StandardMessageCodec.INSTANCE));
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null)
    }
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    hilog.info(domainId, logTag, call.method);
    if (call.method == "getQuickLoginAnonymousPhone") {
      this.getQuickLoginAnonymousPhone(result);
    } else {
      result.notImplemented()
    }
  }

  // 获取匿名手机号
  private async getQuickLoginAnonymousPhone(result: MethodResult) {
    try {
      const quickLoginAnonymousPhone = await getQuickLoginAnonymousPhone();
      if (quickLoginAnonymousPhone !== '') {
        hilog.info(domainId, logTag, quickLoginAnonymousPhone);
        result.success(quickLoginAnonymousPhone);
      } else {
        result.error('-1', '获取匿名手机号失败', '');
      }
    } catch (error) {
      result.error(String(error.code), dealAllError(error), '');
    }
  }
}