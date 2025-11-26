import {
  AbilityAware,
  AbilityPluginBinding,
  FlutterPlugin,
  FlutterPluginBinding,
  Log,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
} from '@ohos/flutter_ohos';
import { UfoKeyboardConstant } from './UfoKeyboardConstant';
import { UIAbility } from '@kit.AbilityKit';
import { FlutterWindowUtils } from './FlutterWindowUtils';

const TAG: string = "FlutterPluginKeyboardPlugin";

/** FlutterPluginKeyboardPlugin **/
export default class FlutterPluginKeyboardPlugin implements FlutterPlugin, MethodCallHandler, AbilityAware {
  private channel: MethodChannel | null = null;
  private ability: UIAbility | null = null;

  constructor() {
  }

  getUniqueClassName(): string {
    return TAG;
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), UfoKeyboardConstant.methodChannelName);
    this.channel.setMethodCallHandler(this)
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null)
    }
  }

  onAttachedToAbility(binding: AbilityPluginBinding): void {
    this.ability = binding.getAbility();
  }

  onDetachedFromAbility(): void {
    this.ability = null;
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    if (call.method == "getPlatformVersion") {
      result.success("OpenHarmony ^ ^ ")
    } else if (call.method == UfoKeyboardConstant.methodSecureModeOn) {
      this.secureModeOn(call, result);
    } else if (call.method == UfoKeyboardConstant.methodSecureModeOff) {
      this.secureModeOff(call, result);
    } else {
      result.notImplemented()
    }
  }

  /**
   * 启用安全模式
   */
  private secureModeOn(call: MethodCall, result: MethodResult): void {
    Log.i(TAG, 'secureModeOn: 启用安全模式');
    if (this.ability?.context != null) {
      FlutterWindowUtils.setWindowPrivacyModeInPage(this.ability?.context, true);
      result.success(null);
    } else {
      result.error("error", "ability 等于 null", null);
    }
  }

  /**
   * 关闭安全模式
   */
  private secureModeOff(call: MethodCall, result: MethodResult): void {
    Log.i(TAG, 'secureModeOff: 关闭安全模式');
    if (this.ability?.context != null) {
      FlutterWindowUtils.setWindowPrivacyModeInPage(this.ability?.context, false);
      result.success(null);
    } else {
      result.error("error", "ability 等于 null", null);
    }
  }
}