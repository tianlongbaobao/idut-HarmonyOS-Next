// @keepTs
// @ts-nocheck
export declare class Crypt {
    static encryptRSA2048(x16: string, y16: string): Promise<Uint8Array>;
    /**
     * @param key
     * @param content
     * @param iSrc
     * @returns
     */
    static encrypt3DES192(h16: string, i16: Uint8Array): Promise<Uint8Array>;
    static decrypt3DES192(r15: string, s15: Uint8Array): Promise<Uint8Array>;
    private static genIVParamsSpec;
}
