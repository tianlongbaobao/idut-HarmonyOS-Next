// @keepTs
// @ts-nocheck
import { Letter } from './Letter';
import cryptoFramework from '@ohos.security.cryptoFramework';
export declare class PackInfo {
    private isGzip;
    private bytes;
    constructor(d20: boolean, e20: Uint8Array);
    getIsGzip(): boolean;
    getBytes(): Uint8Array;
}
export declare class LetterPacker {
    /**
     * 是否加密(上下行保持一致)
     */
    isEncrypt: boolean;
    /**
     * 加密 key
     */
    key: string;
    constructor(c20: boolean);
    packet(u19: Letter, v19: boolean): Promise<PackInfo | null>;
    /**
     * 将一系列 dataField 封装为 05d%length - dataField 的形式
     */
    packetMulti(...n19: Uint8Array[]): Uint8Array;
    static genIVParamsSpec(): cryptoFramework.IvParamsSpec;
    unPacket(a19: PackInfo): Promise<Letter | null>;
}
