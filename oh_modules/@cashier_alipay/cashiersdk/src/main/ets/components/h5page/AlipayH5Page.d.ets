// @keepTs
// @ts-nocheck
@Builder
export declare function AlipayH5PageBuilder(e9: string, f9: Object): void;
export declare class RouterParams {
    url: string;
    method: string;
    cookie: string;
    title: string;
    isBackExit: boolean;
    containerVersion: string;
    navPathStack?: NavPathStack;
}
@Entry({ routeName: 'alipay/sdk/pages/h5page/index' })
@Component
export declare struct AlipayH5Page {
    private context;
    private url;
    @State
    progress: number;
    private method;
    private cookie;
    @State
    title: string | Resource;
    @State
    showRefresh: boolean;
    @State
    showHeader: boolean;
    @State
    showProgress: boolean;
    navPageIntent?: Map<string, Object>;
    private navPathStack?;
    private isBackExit;
    private containerVersion;
    private isErrorPage;
    private webviewController?;
    @State
    isFullScreen: boolean;
    @State
    statusBarHeight: number;
    private mainWindow?;
    aboutToAppear(): void;
    private getStatusBarHeight;
    private updateCookie;
    aboutToDisappear(): void;
    onBackPress(): boolean | void;
    emitPayResult(j8: Map<string, string>): void;
    goBack(): void;
    finish(): void;
    onPageShow(): void;
    onRefresh(): void;
    isV1(): boolean;
    build(): void;
    @Builder
    buildContent(): void;
    private createWebViewController;
    injectJsApi(): void;
    processJsBridge(b5: string): void;
    processJsBridgeInner(y4: string, z4: string, a5: string): void;
}
