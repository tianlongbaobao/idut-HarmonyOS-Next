import { IMediaObject, MediaObjectType } from './SendMessageToWX';

export class WXTextObject implements IMediaObject {
  type = MediaObjectType.TYPE_TEXT
  text?: string

  serializeTo(to: object) {
    to['wx_text_object_text'] = this.text
  }

  deserializeFrom(from: object) {
    this.text = from['wx_text_object_text']
  }

  checkArgs(): boolean {
    if (this.text === undefined || this.text.length === 0) {
      return false
    }
    return true
  }
}