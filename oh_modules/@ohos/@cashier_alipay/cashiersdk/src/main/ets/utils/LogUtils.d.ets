// @keepTs
// @ts-nocheck
export declare class LogUtils {
    private static logCb;
    static setupLogCallback(o36: (logLine: string) => void): void;
    private static writeLog;
    static d(h36: string | undefined, i36: string | undefined): void;
    static i(f36: string | undefined, g36: string | undefined): void;
    static w(d36: string | undefined, e36: string | undefined): void;
    static e(b36: string | undefined, c36: string | undefined): void;
    static eStack(y35: string | undefined, z35: string | undefined, a36: Error | undefined): void;
    static printExceptionStackTrace(x35: Error | undefined): void;
}
