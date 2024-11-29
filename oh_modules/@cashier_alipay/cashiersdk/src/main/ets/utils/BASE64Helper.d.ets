// @keepTs
// @ts-nocheck
export declare class BASE64Helper {
    base64Alphabet: Uint8Array;
    lookUpBase64Alphabet: Uint8Array;
    BASELENGTH: number;
    LOOKUPLENGTH: number;
    constructor();
    decode(h31: string): ArrayBuffer | null;
    removeWhiteSpace(d31: Uint8Array): number;
    arrayCopy(x30: Uint8Array, y30: number, z30: Uint8Array, a31: number, b31: number): void;
    isData(w30: number): boolean;
    isPad(v30: number): boolean;
    isWhiteSpace(u30: number): boolean;
}
