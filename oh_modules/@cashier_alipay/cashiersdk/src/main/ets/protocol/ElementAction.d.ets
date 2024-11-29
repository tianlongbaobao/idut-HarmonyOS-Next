// @keepTs
// @ts-nocheck
import { BizContext } from '../context/BizContext';
import { JSONObject } from '../utils/Utils';
import { ActionType } from './ActionType';
export declare class ElementAction {
    actionType: ActionType;
    name: string;
    params: string[];
    constructor(m23: string, n23: ActionType);
    static update(i23: BizContext, j23: ElementAction): void;
    static parse(b23: JSONObject | null): ElementAction[];
    private static parseActionName;
    private static parseParams;
}
