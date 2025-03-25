// @keepTs
// @ts-nocheck
export declare class ApdIdManager {
    private static instance;
    private constructor();
    static getInstance(): ApdIdManager;
    private apdIdModule;
    private apdIdToken;
    init(x23: Context): Promise<string>;
    private initToken;
    getToken(): string;
}
