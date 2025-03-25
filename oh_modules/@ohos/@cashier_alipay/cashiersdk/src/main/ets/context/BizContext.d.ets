// @keepTs
// @ts-nocheck
import { StatisticRecord } from '../statistic/StatisticRecord';
export declare class BizContext {
    static NEW_EXTERNAL_INFO_WITH_DOUBLE_EQUAL: string;
    context: Context | undefined;
    uniquePayload: string;
    invokeTag: string | undefined;
    record: StatisticRecord | undefined;
    apLinkToken: string | undefined;
    private constructor();
    static createInstance(s13: Context, t13?: string, u13?: string | undefined): Promise<BizContext>;
    init(p13: Context, q13?: string, r13?: string | undefined): Promise<void>;
    private generateExtPayTradeToken;
    format(k13: string): string;
    getSafeContext(): Context;
    private formatEncoded;
    private formatNoEncoded;
    private formatBizContextForKeyValueOrderStr;
    /**
     * 构造一个新的bizcontext。
     *
     * @param header
     *            bizcontext的头，如:"bizcontext="或"bizcontext=\""
     * @param tail
     *            bizcontext的尾，如：""或"\""
     * @return
     */
    private buildBizContext;
    /**
     * 找到bizcontext键值对。如果订单信息orderInfo使用pairConnection拆分之后，其前缀为pairPrefix则认为匹配到。
     *
     * @param orderInfo
     *            订单信息
     * @param pairConnection
     *            拆分字符串
     * @param pairPrefix
     *            键值对前缀
     * @return
     */
    private findBizContext;
    private isTradeEncoded;
    private formatJsonEncode;
    private formatBizContextForJsonOrderStr;
    private buildSimpleBizContext;
    static buildSimpleBizContextForUrlIntercepting(): string;
}
