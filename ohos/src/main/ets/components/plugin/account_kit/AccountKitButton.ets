
import { Params } from '@ohos/flutter_ohos/src/main/ets/plugin/platform/PlatformView';
import { loginComponentManager, LoginWithHuaweiIDButton } from '@kit.AccountKit';
import { BinaryMessenger,
  MethodCall,
  MethodCallHandler, MethodChannel,
  MethodResult,
  PlatformView,
  StandardMethodCodec } from '@ohos/flutter_ohos';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { ErrorCode } from './ErrorCodeEntity'
import { hilog } from '@kit.PerformanceAnalysisKit';
import { domainId, logTag, dealAllError } from './Utils';
import { JSON } from '@kit.ArkTS';

@Component
struct ButtonComponent {
  @StorageLink('agreementStatus') @Watch('watchAgreementStatus') agreementStatus: boolean = false;
  @Prop params: Params;
  customView: CustomView = this.params?.platformView as CustomView;
  controller = new loginComponentManager.LoginWithHuaweiIDButtonController()
    .setAgreementStatus(loginComponentManager.AgreementStatus.NOT_ACCEPTED)
    .onClickEvent(() => {
      this.customView.sendMessage('loginStart', '');
    })
    .onClickLoginWithHuaweiIDButton((error: BusinessError, response: loginComponentManager.HuaweiIDCredential) => {
      this.customView.sendMessage('loginEnd', '');
      // Process the sign-in result.
      if (error) {
        if (error.code === ErrorCode.ERROR_CODE_AGREEMENT_STATUS_NOT_ACCEPTED) {
          // 协议弹窗
          this.customView.sendMessage('agreementDialogOpen', '');
        } else {
          this.customView.sendMessage('loginError', JSON.stringify(new LoginInfo(error.code, dealAllError(error), null)));
        }
        return;
      }
      const authCode = response.authorizationCode;
      this.customView.sendMessage('loginSuccess', JSON.stringify(new LoginInfo(0, null, authCode)));
    });

  aboutToAppear(): void {
    this.customView.setButtonContinueLogin(() => {
      this.controller.setAgreementStatus(loginComponentManager.AgreementStatus.ACCEPTED);
      this.controller.continueLogin((error: BusinessError) => {
        if (error) {
          this.customView.sendMessage('continueLoginError', JSON.stringify(new LoginInfo(error.code, error.message, null)));
        }
      });
    });
  }

  watchAgreementStatus(changedPropertyName: string) {
    hilog.info(domainId, logTag, `this.agreementStatus is ${this.agreementStatus}`);
    if (this.agreementStatus) {
      this.controller.setAgreementStatus(loginComponentManager.AgreementStatus.ACCEPTED);
    } else {
      this.controller.setAgreementStatus(loginComponentManager.AgreementStatus.NOT_ACCEPTED);
    }
  }

  build() {
    LoginWithHuaweiIDButton({
      params: {
        // Custom button style.
        style: loginComponentManager.Style.BUTTON_CUSTOM,
        extraStyle: {
          buttonStyle: new loginComponentManager.ButtonStyle().loadingStyle({
            show: true
          })
        },
        loginType: loginComponentManager.LoginType.QUICK_LOGIN,
        supportDarkMode: true
      },
      controller: this.controller
    }).id('login_with_huaweiId_button')
  }
}

@Builder
function ButtonBuilder(params: Params) {
  ButtonComponent({ params: params })
}

@Observed
export class CustomView extends PlatformView implements MethodCallHandler {

  channel: MethodChannel;
  context?: common.Context;
  args?: Object;
  buttonContinueLogin?: () => void;

  constructor(context: common.Context, viewId: number, args: object, message: BinaryMessenger) {
    super();
    this.context = context;
    this.args = args;
    this.channel =
      new MethodChannel(message, `account_kit_ohos/AccountKitButtonController_${viewId}`, StandardMethodCodec.INSTANCE);
    this.channel.setMethodCallHandler(this);
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    let method: string = call.method;
    hilog.info(domainId, logTag, call.method);
    switch (method) {
      case 'agreementStatusChanged': {
        let value: boolean = call.args;
        let link: SubscribedAbstractProperty<boolean> = AppStorage.link('agreementStatus');
        link.set(value);
        result.success(true);
        break;
      }
      case 'continueLogin': {
        if (this.buttonContinueLogin) {
          this.buttonContinueLogin();
          result.success(true);
        } else {
          result.success(false);
        }
        break;
      }
      default: {
        // Unprocessed messages.
        break;
      }
    }
  }

  public sendMessage = (method: string, data: string) => {
    hilog.info(domainId, logTag, `method = ${method}`);
    this.channel.invokeMethod(method, data);
  }

  public setButtonContinueLogin = (callback: VoidCallback) => {
    this.buttonContinueLogin = callback;
  }

  getView(): WrappedBuilder<[Params]> {
    return new WrappedBuilder(ButtonBuilder);
  }

  dispose(): void {

  }
}

class LoginInfo {
  public code?: number;
  public message?: string;
  public data?: string;

  constructor(code?: number, message?: string, data?: string) {
    this.code = code;
    this.message = message;
    this.data = data;
  }
}