import { BinaryMessenger, MessageCodec, MethodChannel, PlatformView, PlatformViewFactory } from '@ohos/flutter_ohos';
import { common } from '@kit.AbilityKit';
import { CustomView } from './AccountKitButton'

export class CustomFactory extends PlatformViewFactory {
  message: BinaryMessenger;

  constructor(message: BinaryMessenger, createArgsCodes: MessageCodec<Object>) {
    super(createArgsCodes);
    this.message = message;
  }

  public create(context: common.Context, viewId: number, args: Object): PlatformView {
    return new CustomView(context, viewId, args, this.message);
  }
}