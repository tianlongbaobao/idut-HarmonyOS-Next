// @keepTs
// @ts-nocheck
import { BizContext } from '../context/BizContext';
export declare class StatisticManager {
    private constructor();
    static stash(y26: BizContext | undefined, z26: string, a27: string): void;
    static submit(v26: BizContext | undefined, w26: string, x26: string): void;
    static forceUploadExisting(u26: BizContext | undefined): void;
    static putError(q26: BizContext | undefined, r26: string, s26: string, t26: Error | undefined): void;
    static putErrorWithRes(l26: BizContext | undefined, m26: string, n26: string, o26: Error | undefined, p26: string): void;
    static putAction(h26: BizContext | undefined, i26: string, j26: string, k26?: string | undefined): void;
    static localSequence(): number;
    static requestSequence(): number;
}
