import { CardListComponent } from '../view/CardListComponent';
import { CardListParameter } from '../viewmodel/CardListParameter';

@Entry
@Component
struct DianwangCard {
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
    title: $r('app.string.card_list_title'),
    content: $r('app.string.card_list_content'),
    icon: $r('app.media.list_item')
  };
  cardList: Array<number> = new Array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9);
  @State cardListParameter: CardListParameter = new CardListParameter($r('sys.color.ohos_id_color_background'),
    $r('app.string.card_list_title'), '', ImageSize.Auto, $r('app.media.startIcon'), true,
    $r('sys.color.ohos_id_color_background'), true, this.cardList.length, $r('sys.color.ohos_id_color_emphasize'),
    $r('app.color.list_item_count_background'), '', true, $r('app.media.bottom_icon'));

  @Builder
  cardListBuilder() {
    ForEach(this.cardList, (item: number) => {
      ListItem() {
        Row() {
          Column() {
            Text(this.cardListData.title)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .fontSize($r('app.float.item_content_font_size'))
              .fontWeight(FontWeight.Medium)
              .fontColor(Color.Black)
              .height($r('app.float.item_text_height'))
              .margin({ top: $r('app.float.item_text_margin') })
            Text(this.cardListData.content)
              .maxLines(1)
              .fontSize($r('app.float.item_content_font_size'))
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .fontWeight(FontWeight.Regular)
              .height($r('app.float.item_text_height'))

            Divider()
              .strokeWidth(0.38)
              .lineCap(LineCapStyle.Square)
              .margin({ top: $r('app.float.list_divider_margin') })
          }
          .margin({ right: $r('app.float.list_row_margin') })
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)

          Image(this.cardListData.icon)
            .width($r('app.float.item_image_size'))
            .height($r('app.float.item_image_size'))
        }
        .alignItems(VerticalAlign.Center)
        .width(this.FULL_WIDTH_PERCENT)
      }
      .width(this.FULL_WIDTH_PERCENT)
      .height($r('app.float.item_height'))
    }, (item: number, index) => index + JSON.stringify(item))
  }

  build() {
    Row() {
      CardListComponent({ cardListParameter: this.cardListParameter }) {
        this.cardListBuilder()
      }
    }
    .height(this.FULL_HEIGHT_PERCENT)
    .onClick(() => {
      postCardAction(this, {
        action: this.ACTION_TYPE,
        abilityName: this.ABILITY_NAME,
        params: {
          message: this.MESSAGE
        }
      });
    })
  }
}

interface CardListItemData {
  title: ResourceStr;
  content: ResourceStr;
  icon?: Resource;
}