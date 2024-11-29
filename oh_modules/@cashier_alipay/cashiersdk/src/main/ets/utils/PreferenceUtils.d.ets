// @keepTs
// @ts-nocheck
import dataPreferences from '@ohos.data.preferences';
export declare class PreferenceUtils {
    static readonly SHARE_PREFERENCE_NAME = "alipay_sdk_preference";
    private static instance;
    private preferences?;
    private constructor();
    static getInstance(): PreferenceUtils;
    get(r36: string, s36: dataPreferences.ValueType): dataPreferences.ValueType;
    put(p36: string, q36: dataPreferences.ValueType): void;
}
