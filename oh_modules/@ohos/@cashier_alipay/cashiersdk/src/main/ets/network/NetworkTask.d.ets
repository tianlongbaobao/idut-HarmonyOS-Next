// @keepTs
// @ts-nocheck
/** 标识数据传输是否gzip 特别注意，http header大小写经过传输可能变化，匹配的时候忽略大小写 */
import { BizContext } from '../context/BizContext';
import { JSONObject } from '../utils/Utils';
import { Letter } from './model/Letter';
import { HashMap } from '@kit.ArkTS';
export declare const HTTP_HEADER_MSP_GZIP = "msp-gzip";
export declare const HTTP_HEADER_MSP_PARAM = "Msp-Param";
export declare const HTTP_HEADER_OPERATION_TYPE = "Operation-Type";
export declare const HTTP_HEADER_CONTENT_TYPE = "content-type";
export declare const HTTP_HEADER_VERSION = "Version";
export declare const HTTP_HEADER_APPID = "AppId";
export declare const HTTP_HEADER_DESMODE = "des-mode";
export declare const HTTP_HEADER_CONTENT_TYPE_H = "Content-Type";
export declare const HTTP_HEADER_ACCEPT_CHARSET = "Accept-Charset";
export declare const HTTP_HEADER_CONNECTION = "Connection";
export declare const HTTP_HEADER_KEEP_ALIVE = "Keep-Alive";
export declare const HTTP_HEADER_UTDID = "utdId";
export declare const HTTP_HEADER_LOG_HEADER = "logHeader";
export declare const HTTP_HEADER_BIZ_CODE = "bizCode";
export declare const HTTP_HEADER_PRODUCT_ID = "productId";
export declare const HTTP_HEADER_PRODUCT_VERSION = "productVersion";
export declare const HTTP_HEADER_CONTENT_ENCODING = "Content-Encoding";
export declare const HTTP_HEADER_USER_AGENT = "User-Agent";
export declare abstract class NetworkTask {
    isUpGzip: boolean;
    isEncrypt: boolean;
    buildHeaders(n22: boolean, o22: string): Map<string, string>;
    abstract buildAction(): JSONObject;
    abstract isWifiMocked(): boolean;
    abstract getName(): string;
    needStatic(): boolean;
    getApiVersion(): string;
    buildEnvelop(g22: BizContext): string;
    buildEnvelopInner(v21: BizContext, w21: Map<string, string>, x21: HashMap<string, string>): string;
    static buildAction(j22: string, k22: string): JSONObject;
    buildBody(o21: BizContext, p21: string, q21: JSONObject): string;
    request(m21: BizContext, n21: string): Promise<Letter | null>;
    requestWithUrl(j21: BizContext, k21: string, l21: string): Promise<Letter | null>;
    doRequest(k20: BizContext, l20: string, m20: string, n20: boolean): Promise<Letter | null>;
    updatePublicKey(f20: string): boolean;
}
