// @keepTs
// @ts-nocheck
export declare class Result {
    static getParamsError(): Map<string, string>;
    static getCancel(): Map<string, string>;
    static getDoubleRequest(): Map<string, string>;
    static parseResult(u4: ResultStatus, v4?: string): Map<string, string>;
    static parseResultV1(r4: number | string, s4: string, t4: string): Map<string, string>;
}
export declare class ResultStatus {
    static SUCCEEDED: ResultStatus;
    static FAILED: ResultStatus;
    static CANCELED: ResultStatus;
    static NETWORK_ERROR: ResultStatus;
    static ACTIVITY_NOT_START_EXIT: ResultStatus;
    static PARAMS_ERROR: ResultStatus;
    static DOUBLE_REQUEST: ResultStatus;
    static PAY_WAITTING: ResultStatus;
    status: number;
    memo: string;
    constructor(p4: number, q4: string);
    toString(): string;
    static getResultStatus(o4: number): ResultStatus;
}
