import { window } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { Log } from '@ohos/flutter_ohos';

const TAG: string = "FlutterWindowUtils";

export class FlutterWindowUtils {
  static setWindowPrivacyModeInPage(context: common.UIAbilityContext, isFlag: boolean) {
    window.getLastWindow(context).then((lastWindow) => {
      lastWindow.setWindowPrivacyMode(isFlag, (err: BusinessError) => {
        const errCode: number = err.code;
        if (errCode) {
          Log.e(TAG, 'Failed to set the window to privacy mode. 1Cause:' + JSON.stringify(err));
          return;
        }
        Log.i(TAG, 'Succeeded in setting the window to privacy mode.');
      });
    })
  }
}