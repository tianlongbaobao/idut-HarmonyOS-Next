import { CardListComponent } from '../view/CardListComponent';
import { CardListParameter } from '../viewmodel/CardListParameter';

let storageWidgetImageUpdate = new LocalStorage();

@Entry(storageWidgetImageUpdate)
@Component
struct ServicecardCard {
  @LocalStorageProp('classes1name') classes1name: string = ""
  @LocalStorageProp('classes1time') classes1time: string = ""
  @LocalStorageProp('classes1add') classes1add: string = ""
  @LocalStorageProp('classes2name') classes2name: string = ""
  @LocalStorageProp('classes2time') classes2time: string = ""
  @LocalStorageProp('classes2add') classes2add: string = ""

  /*
   * The action type.
   */
  readonly ACTION_TYPE: string = 'router';
  /*
   * The ability name.
   */
  readonly ABILITY_NAME: string = 'EntryAbility';
  /*
   * The message.
   */
  readonly MESSAGE: string = 'add detail';
  /*
   * The width percentage setting.
   */
  readonly FULL_WIDTH_PERCENT: string = '100%';
  /*
   * The height percentage setting.
   */
  readonly FULL_HEIGHT_PERCENT: string = '100%';
  cardListData: CardListItemData = {
    title: "今日课表",
    content: "今日课表",
    icon: $r('app.media.list_item')
  };

  @State cardList: CardListParameter = new CardListParameter($r('sys.color.ohos_id_color_background'),
    "今日课表", '', ImageSize.Auto, $r('app.media.class'), true,
    $r('sys.color.ohos_id_color_background'), true, 0, $r('sys.color.ohos_id_color_emphasize'),
    $r('app.color.list_item_count_background'), '', true, $r('app.media.bottom_icon'));
  @Builder
  cardListBuilder() {
      ListItem() {
        Row() {
          Column() {
              Text(this.classes1name.replace(/^['"]|['"]$/g, '').split("\"")[0])
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .fontSize($r('app.float.item_content_font_size'))
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.Black)
                .height(14)
                .margin({ top: "-0.5%" })
              Text(this.classes1add.replace(/^['"]|['"]$/g, ''))
                .maxLines(1)
                .fontSize(10)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .fontWeight(FontWeight.Regular)
                .height(14)
              Text(this.classes1time.replace(/^['"]|['"]$/g, ''))
                .maxLines(1)
                .fontSize(12)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .fontWeight(FontWeight.Regular)
                .height(14)

            Divider()
              .strokeWidth(0.38)
              .lineCap(LineCapStyle.Square)
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)
        }
        .alignItems(VerticalAlign.Center)
        .width(this.FULL_WIDTH_PERCENT)
      }
      .width(this.FULL_WIDTH_PERCENT)
      .height(40)
      ListItem() {
        Row() {
          Column() {
            Text(this.classes2name.replace(/^['"]|['"]$/g, ''))
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .fontSize($r('app.float.item_content_font_size'))
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.Black)
              .height($r('app.float.item_text_height'))
              .margin({top:3})
            Text(this.classes2add.replace(/^['"]|['"]$/g, ''))
              .maxLines(1)
              .fontSize(10)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .fontWeight(FontWeight.Regular)
              .height(14)
            Text(this.classes2time.replace(/^['"]|['"]$/g, ''))
              .maxLines(1)
              .fontSize($r('app.float.item_content_font_size'))
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .fontWeight(FontWeight.Regular)
              .height(14)
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)
        }
        .alignItems(VerticalAlign.Center)
        .width(this.FULL_WIDTH_PERCENT)
      }
      .width(this.FULL_WIDTH_PERCENT)
      .height(40)
  }

  build() {
    Row() {
      CardListComponent({ cardListParameter: this.cardList }) {
        this.cardListBuilder()
      }
    }
    .height(this.FULL_HEIGHT_PERCENT)
    .onClick(() => {
      postCardAction(this, {
        action: "router",
        abilityName: this.ABILITY_NAME,
        params: { targetPage: 'class' }
      });
    })
  }
}

interface CardListItemData {
  title: ResourceStr;
  content: ResourceStr;
  icon?: Resource;
}