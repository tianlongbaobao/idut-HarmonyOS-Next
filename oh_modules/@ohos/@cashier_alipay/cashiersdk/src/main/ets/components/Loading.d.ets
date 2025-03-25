// @keepTs
// @ts-nocheck
import { window } from '@kit.ArkUI';
export declare class Loading {
    loadingWindow?: window.Window;
    show(): Promise<void>;
    hide(): Promise<void>;
}
