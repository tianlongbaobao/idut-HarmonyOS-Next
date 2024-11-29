// @keepTs
// @ts-nocheck
export declare class GlobalConstants {
    static readonly URL = "https://mobilegw.alipay.com/mgw.htm";
    static readonly PRE_SANDBOX_URL = "https://mobilegw.alipaydev.com/mgw.htm";
    static readonly SANDBOX_URL = "https://mobilegw.dl.alipaydev.com/mgw.htm";
    static readonly MCGW_LG_URL = "https://mcgw.alipay.com/sdklog.do";
    static readonly MDAP_LG_URL = "https://loggw-exsdk.alipay.com/loggw/logUpload.do";
    static RSA_PUBLIC_KEY: string;
    static readonly APP_KEY = "2014052600006128";
    static readonly SID = "1";
    static readonly SDK_VERSION = "1.0.0";
    static readonly MSP_VERSION = "1.0.0";
    static readonly BUILD_HASH = "1.0.0";
    static readonly SKIP_FLAG_ALIPAYS = "alipays://platformapi/startApp?";
    static readonly SKIP_FLAG_INTENT = "intent://platformapi/startapp?";
    static readonly PAY_RESULT_TAG = "sdklite://h5quit?result=";
    static readonly H5_QUIT_TAG = "sdklite://h5quit";
    static readonly H5_QUIT_TAG_2_PART_1 = "http";
    static readonly H5_QUIT_TAG_2_PART_2 = "://m.alipay.com/?action=h5quit";
    static readonly END_CODE_TAG = "&end_code=";
    static readonly RETURN_URL = "&return_url=";
    static readonly FROM_12306_FLAG = "service=alipay.acquire.mr.ord.createandpay";
    static readonly ONLINE_ORDER_FLAG_1 = "https://wappaygw.alipay.com/home/exterfaceAssign.htm?";
    static readonly ONLINE_ORDER_FLAG_2 = "https://mclient.alipay.com/home/exterfaceAssign.htm?";
    static readonly GENERAL_TAG = "mspl";
    static readonly H5_HOST_ALIPAY_ONLINE = "alipay.com";
    static readonly H5_HOST_ALIPAY_OFFLINE = "alipay.net";
    static isFrom12306: boolean;
}
