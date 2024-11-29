// @keepTs
// @ts-nocheck
import { BizContext } from '../context/BizContext';
export declare class StatisticRecord {
    static readonly ET_NET = "net";
    static readonly ET_BIZ = "biz";
    static readonly KEY_TRADE_PARTNER = "partner";
    static readonly KEY_TRADE_OUT_TRADE_NO = "out_trade_no";
    static readonly KEY_TRADE_NO = "trade_no";
    static readonly KEY_BIZ_CONTENT = "biz_content";
    static readonly KEY_APP_ID = "app_id";
    private mTime;
    private mTrade;
    private mApp;
    private mSDK;
    private mIds;
    private mDevice;
    private mResult;
    private mBehavior;
    private mException;
    private mTemplate;
    private mBizContext;
    constructor(j29: BizContext, k29: boolean);
    putError(f29: string, g29: string, h29: Error | undefined): void;
    putErrorWithRes(a29: string, b29: string, c29: Error | undefined, d29: string): void;
    putErrorInner(w28: string, x28: string, y28: string): void;
    putErrorWithMsg(t28: string, u28: string, v28: string): void;
    putActionWithDetail(q28: string, r28: string, s28: string): void;
    putAction(o28: string, p28: string): void;
    putActionInner(k28: string, l28: string, m28: string): void;
    genEventTime(): string;
    private filter;
    private filterField;
    private getStackTraceMessage;
    format(g28: string): string;
    private buildTime;
    private randomUuid;
    private buildTrade;
    private buildApp;
    private buildSDK;
    private buildIds;
    private buildDevice;
}
