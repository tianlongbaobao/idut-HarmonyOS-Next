// @keepTs
// @ts-nocheck
import { BizContext } from '../context/BizContext';
import { JSONObject } from '../utils/Utils';
import { NetworkTask } from './NetworkTask';
import { HashMap } from '@kit.ArkTS';
export declare class DynamicConfigPacket extends NetworkTask {
    getApiVersion(): string;
    buildAction(): JSONObject;
    isWifiMocked(): boolean;
    getName(): string;
    buildEnvelopInner(t17: BizContext, u17: Map<string, string>, v17: HashMap<string, string>): string;
    private generateRequestParams;
}
