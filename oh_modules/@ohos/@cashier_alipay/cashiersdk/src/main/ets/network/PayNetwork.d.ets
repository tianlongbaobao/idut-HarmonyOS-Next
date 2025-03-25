// @keepTs
// @ts-nocheck
import { JSONObject } from '../utils/Utils';
import { NetworkTask } from './NetworkTask';
export declare class PayNetwork extends NetworkTask {
    buildAction(): JSONObject;
    isWifiMocked(): boolean;
    needStatic(): boolean;
    getName(): string;
}
