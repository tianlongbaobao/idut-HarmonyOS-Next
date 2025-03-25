// @keepTs
// @ts-nocheck
export declare class ActionType {
    static None: ActionType;
    static WapPay: ActionType;
    static Update: ActionType;
    static OpenWeb: ActionType;
    static SetResult: ActionType;
    static Exit: ActionType;
    static typeList: ActionType[];
    action: string;
    private constructor();
    static getActionType(q22: string): ActionType;
}
