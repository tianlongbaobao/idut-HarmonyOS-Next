// @keepTs
// @ts-nocheck
import { JSONObject } from '../../utils/Utils';
export declare class Letter {
    private envelop;
    private body;
    constructor(y18: string, z18: string);
    getEnvelop(): string;
    getBody(): string;
    getTemplate(): JSONObject;
}
