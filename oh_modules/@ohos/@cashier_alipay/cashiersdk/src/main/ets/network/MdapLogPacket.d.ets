// @keepTs
// @ts-nocheck
import { BizContext } from '../context/BizContext';
import { JSONObject } from '../utils/Utils';
import { Letter } from './model/Letter';
import { NetworkTask } from './NetworkTask';
export declare class MdapLogPacket extends NetworkTask {
    buildHeaders(u18: boolean, v18: string): Map<string, string>;
    buildAction(): JSONObject;
    isWifiMocked(): boolean;
    getName(): string;
    buildBody(r18: BizContext, s18: string, t18: JSONObject): string;
    request(w17: BizContext, x17: string): Promise<Letter | null>;
}
