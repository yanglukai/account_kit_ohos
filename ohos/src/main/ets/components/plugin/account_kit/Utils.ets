/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 * */

import { hilog } from "@kit.PerformanceAnalysisKit";
import { ErrorCode } from "./ErrorCodeEntity";
import { BusinessError } from "@kit.BasicServicesKit";
import { authentication } from "@kit.AccountKit";

export const logTag: string = 'account_kit';
export const domainId: number = 0x0000;

export function dealAllError(error: BusinessError): string {
  const showErrorCode = error.code ? `errorCode: ${error.code}, ` : '';
  const showErrorMessage = error.message ? `errorMsg: ${error.message}` : '';
  hilog.error(domainId, logTag, `${showErrorCode}${showErrorMessage}`);

  if (error.code === ErrorCode.ERROR_CODE_CERTIFICATE_VERIFICATION_FAIL) {
    return '应用指纹证书校验失败';
  } else if (error.code === ErrorCode.ERROR_CODE_LOGIN_OUT) {
    return '华为账号未登录';
  } else if (error.code === ErrorCode.ERROR_CODE_NOT_SUPPORTED) {
    return '该账号不支持一键登录';
  } else if (error.code === ErrorCode.ERROR_CODE_NETWORK_ERROR) {
    return '网络异常，请检查当前网络状态';
  } else if (error.code === ErrorCode.ERROR_CODE_INTERNAL_ERROR) {
    return '登录失败'; // 内部错误
  } else if (error.code === ErrorCode.ERROR_CODE_USER_CANCEL) {
    return '用户取消';
  } else if (error.code === ErrorCode.ERROR_CODE_SYSTEM_SERVICE) {
    return '系统服务异常，请稍后重试';
  } else if (error.code === ErrorCode.ERROR_CODE_REQUEST_REFUSE) {
    return '重复请求';
  } else if (error.code === ErrorCode.ERROR_CODE_PARAMETER_ERROR) {
    return '参数错误';
  } else {
    return `请求失败:${error.code}`;
  }
}

// Obtain the anonymous mobile number.
export async function getQuickLoginAnonymousPhone(waitTime = 5000): Promise<string> {
  // Create an authorization request.
  const authRequest = new authentication.HuaweiIDProvider().createAuthorizationWithHuaweiIDRequest();
  // User information requested by the app.
  authRequest.scopes = ['quickLoginAnonymousPhone'];
  // In the one-tap sign-in scenario, forceAuthorization must be set to false.
  authRequest.forceAuthorization = false;
  const controller = new authentication.AuthenticationController();
  return new Promise((resolve: (str: string) => void, reject: (err: BusinessError) => void) => {
    controller.executeRequest(authRequest).then((response: authentication.AuthorizationWithHuaweiIDResponse) => {
      /*
       * If code obfuscation is enabled,
       * configure a trustlist for the quickLoginAnonymousPhone attribute to prevent it from being obfuscated.
       * */
      const quickLoginAnonymousPhone = response?.data?.extraInfo?.quickLoginAnonymousPhone as string ?? '';
      resolve(quickLoginAnonymousPhone);
    }).catch(reject);

    // Set the timeout interval. If the timeout interval is exceeded, a network error will be returned.
    setTimeout(reject, waitTime, {
      code: ErrorCode.ERROR_CODE_NETWORK_ERROR,
      message: 'Network error.'
    });
  });
}

export class AvoidRepeatClick {
  static lastClickTime: number = 0; // Record the time of the last repeated tap.
  public static avoidRepeatClick(callback: VoidCallback, interval: number = 400) {
    const currentTime = Date.now();
    if (Math.abs(currentTime - AvoidRepeatClick.lastClickTime) > interval) {
      AvoidRepeatClick.lastClickTime = currentTime;
      hilog.info(domainId, logTag, 'Effective click');
      callback();
    } else {
      hilog.info(domainId, logTag, 'Invalid click');
    }
  }
}
