export declare class JsonUtils {
    /**
     * 将 JSON 字符串 或者 Record 解析为指定类型的对象，并为其赋予类的方法
     * @param data
     * @param type
     * @returns
     */
    static parseJsonToInstance<s35>(t35: string | Record<string, any>, u35: {
        new (...args: any[]): s35;
    }): s35;
}
