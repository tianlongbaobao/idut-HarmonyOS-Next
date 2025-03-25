import { MediaObjectType } from './SendMessageToWX';
import { IMediaObject } from './SendMessageToWX';
import { WXImageObject } from './WXImageObject';
import { WXMiniProgramObject } from './WXMiniProgramObject';
import { WXTextObject } from './WXTextObject';
import { WXWebpageObject } from './WXWebpageObject';

export class WXMediaObjectFactory {
  static createMediaObject(type: number): IMediaObject | undefined {
    if (type === MediaObjectType.TYPE_TEXT) {
      return new WXTextObject
    } else if (type === MediaObjectType.TYPE_IMAGE) {
      return new WXImageObject
    } else if(type === MediaObjectType.TYPE_URL) {
      return new WXWebpageObject()
    } else if(type === MediaObjectType.TYPE_OPENSDK_APPBRAND) {
      return new WXMiniProgramObject()
    }
    // add more object convert
    return undefined
  }
}