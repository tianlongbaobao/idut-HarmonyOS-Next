// @keepTs
// @ts-nocheck
import { BizContext } from '../context/BizContext';
export declare class TidStorage {
    static PREF_TID_FILE: string;
    static PREF_TID_INFO: string;
    static KEY_TID: string;
    static KEY_CLIENTKEY: string;
    static KEY_TIMESTAMP: string;
    static KEY_VIMEI: string;
    static KEY_VIMSI: string;
    private static instance;
    private mTid;
    private mClientKey;
    private mTimestamp;
    private mVimei;
    private mVimsi;
    private isInit;
    private constructor();
    load(j30: BizContext): void;
    private isIllegal;
    private resetTid;
    private genClientKey;
    static genVirtualCode(): string;
    static getInstance(x29?: BizContext | undefined): TidStorage;
    setTid(w29: string): void;
    getTid(): string;
    save(t29: BizContext, u29: string, v29: string): void;
    saveToLocal(o29: BizContext): void;
    generateDesKey(m29: BizContext): string;
    getClientKey(): string;
}
