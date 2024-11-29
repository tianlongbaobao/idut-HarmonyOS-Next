// @keepTs
// @ts-nocheck
import { Context } from '@kit.AbilityKit';
export type JSONObject = Record<string, ESObject>;
export declare function formatResult(k38: string): Map<string, string>;
export declare function isEmpty(j38: string | null | undefined): boolean;
export declare function getRandomString(c38: number): string;
export declare function stringToUint8ArrayWithEncoder(a38: string): Uint8Array;
export declare function uint8ArrayToStringWithDecoder(y37: Uint8Array): string;
export declare function formatNumber(v37: number, w37: number): string;
export declare function debug(t37: string, u37: string): void;
export declare function getQueryMap(n37: string): Map<string, string>;
export declare function getProcessUid(m37: Context): number;
export declare function elapsedRealtime(): number;
export declare function doLoopSHA256(c37: string): Promise<string>;
/**
 * 截取制定字符串中的字符
 *
 * @param startTag
 *            开始标记
 * @param engTag
 *            结束标记
 * @param str
 *            进行分析处理的字符串
 */
export declare function subString(t36: string, u36: string, v36: string): string;
