// @keepTs
// @ts-nocheck
import { BizContext } from '../context/BizContext';
import { TidStorage } from '../tid/TidStorage';
import { Context } from '@kit.AbilityKit';
export declare class MspConfig {
    static SHARE_PREFERENCE_NAME: string;
    static PREFERENCE_VIRTUAL_IMSI: string;
    static PREFERENCE_VIRTUAL_IMEI: string;
    mUserAgent: string | undefined;
    mKernelVersion: string | undefined;
    mClientKey: string | undefined;
    static instance: MspConfig;
    private constructor();
    static getInstance(): MspConfig;
    getUserAgent(n14: BizContext, o14: TidStorage, p14: boolean): string;
    static getPa(j14: Context): string;
    private getNetworkTypeSync;
    getVirtualImsi(b14: BizContext): string;
    getVirtualImei(x13: BizContext): string;
    static setRsaPublicKey(w13: string): void;
}
