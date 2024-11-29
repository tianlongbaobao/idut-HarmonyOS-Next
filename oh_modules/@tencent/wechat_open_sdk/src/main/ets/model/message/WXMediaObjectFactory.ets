import { MediaObjectType } from './SendMessageToWX';
import { IMediaObject } from './SendMessageToWX';
import { WXImageObject } from './WXImageObject';
import { WXTextObject } from './WXTextObject';

export class WXMediaObjectFactory {
  static createMediaObject(type: number): IMediaObject | undefined {
    if (type === MediaObjectType.TYPE_TEXT) {
      return new WXTextObject
    } else if (type === MediaObjectType.TYPE_IMAGE) {
      return new WXImageObject
    }
    // add more object convert
    return undefined
  }
}