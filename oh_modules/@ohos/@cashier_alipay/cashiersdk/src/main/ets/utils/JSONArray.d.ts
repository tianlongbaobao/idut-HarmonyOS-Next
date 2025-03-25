import { JSONObject } from './JSONObject';
export declare class JSONArray {
    private array;
    constructor(h34?: string | any[]);
    get(g34: number): any;
    length(): number;
    applyToArray(c34: (item: any, index: number, array: any[]) => void): void;
    put(b34: any): void;
    put(y33: number, b34: any): void;
    remove(w33: number): void;
    getString(t33: number, u33?: string): string;
    getBoolean(q33: number, r33?: boolean): boolean;
    getNumber(n33: number, o33?: number): number;
    getJsonObject(k33: number, l33?: JSONObject | null): JSONObject | null;
    getJsonArray(h33: number, i33?: JSONArray | null): JSONArray | null;
    getArray<c33>(d33: number, e33?: c33[] | null): c33[] | null;
    toJson(): string;
}
