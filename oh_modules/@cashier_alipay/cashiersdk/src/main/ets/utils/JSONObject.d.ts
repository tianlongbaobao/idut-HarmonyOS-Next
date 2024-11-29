import { JSONArray } from './JSONArray';
export declare class JSONObject {
    private object;
    constructor(q35?: string | Record<string, any>);
    getString(n35: string, o35?: string): string;
    getBoolean(k35: string, l35?: boolean): boolean;
    getNumber(h35: string, i35?: number): number;
    getJsonObject(e35: string, f35?: Record<string, any> | null): JSONObject | null;
    getJsonArray(b35: string, c35?: JSONArray | null): JSONArray | null;
    getArray<w34>(x34: string, y34?: w34[] | null): w34[] | null;
    hasKey(v34: string): boolean;
    put(t34: string, u34: any): void;
    remove(s34: string): void;
    applyToArray(o34: string, p34: (item: any, index: number, array: any[]) => void): void;
    toJson(): string;
    toInstance<j34>(k34: {
        new (...args: any[]): j34;
    }): j34;
}
