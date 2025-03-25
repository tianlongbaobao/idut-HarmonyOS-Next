// @keepTs
// @ts-nocheck
import { Context } from '@kit.AbilityKit';
import { Loading } from '../components/Loading';
export declare class Pay {
    context: Context;
    showLoading: boolean;
    loading?: Loading;
    navPathStack?: NavPathStack;
    navCallback?: (name: string, params: Map<string, Object>) => void;
    constructor();
    getVersion(): string;
    /**
     *
     * @param orderInfo
     * @param showPayLoading 为 true时需要传入对应的component
     * @returns
     */
    pay(m4: string, n4?: boolean): Promise<Map<string, string>>;
    /**
     *
     * @param orderInfo
     * @param showPayLoading
     * @param navCallback 商户传入自定义的nav跳转，由商户控制H5跳转
     * @param navPathStack 商户自定义跳转时的navPath，以及使用系统路由表的navPath
     * @returns
     */
    payWithNav(d4: string, e4?: boolean, f4?: (name: string, params: Map<string, Object>) => void, g4?: NavPathStack | undefined): Promise<Map<string, string>>;
    /**
     * 支付宝H5支付URL拦截器，完成拦截及支付方式转化
     * @param h5PayUrl 待过滤拦截的 url string
     * @param showPayLoading 是否出现loading
     * @param callback 异步回调接口
     * @returns true：表示URL为支付宝支付URL，URL已经被拦截并支付转化；false：表示URL非支付宝支付URL；
     */
    payInterceptorWithUrl(m3: string, n3: boolean, o3: (result: Map<string, string>) => void): boolean;
    private shouldInterceptUrlForCashier;
    private innerPay;
    private payResult;
    private openAlipay;
    private requestH5Pay;
    private processH5Pay;
    private router;
    private updateTid;
    private showPayLoading;
    private hidePayLoading;
}
