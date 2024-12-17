import { CardListComponent } from '../view/CardListComponent';
import { CardListParameter } from '../viewmodel/CardListParameter';

@Entry
@Component
struct ElecCard {
  @LocalStorageProp('cardmoney') cardmoney: string = ""
  @LocalStorageProp('room') room: string = ""
  @LocalStorageProp('elec') elec: string = ""

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
  cardList: Array<number> = new Array(0, 1);
  @State cardListParameter: CardListParameter = new CardListParameter($r('sys.color.ohos_id_color_background'),
    "余额查询", '', ImageSize.Auto, $r('app.media.check'), true,
    $r('sys.color.ohos_id_color_background'), true, 0, $r('sys.color.ohos_id_color_emphasize'),
    $r('app.color.list_item_count_background'), '', true, $r('app.media.bottom_icon'));

  @Builder
  cardListBuilder() {
    ListItem() {
      Row() {
        Column() {
          Text("玉兰卡余额")
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .fontSize($r('app.float.item_content_font_size'))
            .fontWeight(FontWeight.Medium)
            .fontColor(Color.Black)
            .height(14)
            .margin({ top: "-0.5%" })
          Text(this.cardmoney.replace(/^['"]|['"]$/g, ''))
            .maxLines(1)
            .fontSize(16)
            .fontColor((Number(this.cardmoney.replace(/^['"]|['"]$/g, ''))>20)? "green":"red")
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .fontWeight(FontWeight.Regular)
            .height(14)
            .margin({top:5,bottom:5})

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
          Text("电费余额")
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .fontSize($r('app.float.item_content_font_size'))
            .fontWeight(FontWeight.Medium)
            .fontColor(Color.Black)
            .height(14)
            .margin({top:3})
          Text(this.room.replace(/^['"]|['"]$/g, ''))
            .maxLines(1)
            .fontSize(8)
            .fontColor("black")
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .fontWeight(FontWeight.Regular)
            .height(14)
          Text(this.elec.replace(/^['"]|['"]$/g, ''))
            .maxLines(1)
            .fontSize(14)
            .fontColor((Number(this.elec.replace(/^['"]|['"]$/g, '').split("度")[0])>20)? "green":"red")
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
      CardListComponent({ cardListParameter: this.cardListParameter }) {
        this.cardListBuilder()
      }
    }
    .height(this.FULL_HEIGHT_PERCENT)
    .onClick(() => {
      postCardAction(this, {
        action: "router",
        abilityName: this.ABILITY_NAME,
        params: { targetPage: 'check' }
      });
    })
  }
}

interface CardListItemData {
  title: ResourceStr;
  content: ResourceStr;
  icon?: Resource;
}