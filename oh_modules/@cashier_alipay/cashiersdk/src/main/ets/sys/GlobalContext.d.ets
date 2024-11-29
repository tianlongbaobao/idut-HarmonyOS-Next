// @keepTs
// @ts-nocheck
import { MspConfig } from '../data/MspConfig';
import { Context } from '@kit.AbilityKit';
export declare class GlobalContext {
    private static instance;
    private constructor();
    static getInstance(): GlobalContext;
    getConfig(): MspConfig;
    getUtdid(l29: Context): string;
}
