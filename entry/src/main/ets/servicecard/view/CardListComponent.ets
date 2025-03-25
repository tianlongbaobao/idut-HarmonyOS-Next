import { CardListParameter } from '../viewmodel/CardListParameter';

@Component
export struct CardListComponent {
  /**
   * The max quantity of list items.
   */
  readonly MAX_QUANTITY: number = 99;
  /*
 * The width percentage setting.
 */
  readonly FULL_WIDTH_PERCENT: string = '100%';
  /*
   * The height percentage setting.
   */
  readonly FULL_HEIGHT_PERCENT: string = '100%';
  @BuilderParam customBuilderParam: () => void = this.customBuilder;
  @Link cardListParameter: CardListParameter;

  @Builder
  customBuilder() {
  }

  build() {
    if (this.cardListParameter !== undefined) {
      Stack({ alignContent: Alignment.Bottom }) {
        Column({ space: FlexAlign.Start }) {
          Row() {
            Row() {
              Text(this.cardListParameter.title)
                .fontSize($r('app.float.list_title_font_size'))
                .fontWeight(FontWeight.Bold)
                .height($r('app.float.list_title_height'))
                .fontColor(this.cardListParameter.titleColor)
                .padding({ right: $r('app.float.list_title_padding_right') })
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })

              if (this.cardListParameter.isItemCount && this.cardListParameter.itemCount) {
                Text(this.cardListParameter.itemCount > this.MAX_QUANTITY
                  ? '99+' : this.cardListParameter.itemCount + '')
                  .textAlign(TextAlign.Center)
                  .fontSize($r('app.float.item_count_font_size'))
                  .fontWeight(FontWeight.Medium)
                  .fontColor(this.cardListParameter.itemCountColor)
                  .backgroundColor(this.cardListParameter.itemCountBackgroundColor)
                  .width($r('app.float.item_count_width'))
                  .height($r('app.float.item_count_height'))
                  .borderRadius($r('app.float.item_count_radius'))
              }
            }.layoutWeight(1)

            Image(this.cardListParameter.logo)
              .width($r('app.float.list_logo_size'))
              .height($r('app.float.list_logo_size'))
              .margin({ left: $r('app.float.icon_margin') })
          }
          .width(this.FULL_WIDTH_PERCENT)
          .alignItems(VerticalAlign.Top)
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({ bottom: $r('app.float.list_row_padding_bottom') })

          List() {
            this.customBuilderParam()
          }
          .width(this.FULL_WIDTH_PERCENT)
          .height(this.FULL_HEIGHT_PERCENT)
          .layoutWeight(1)
          .scrollBar(BarState.Off)
        }
        .pixelRound({ bottom: PixelRoundCalcPolicy.FORCE_CEIL })

        Stack({ alignContent: Alignment.BottomEnd }) {
          if (this.cardListParameter.isMask) {
            Row()
              .width(this.FULL_WIDTH_PERCENT)
              .height($r('app.float.list_mask_height'))
              .linearGradient({
                direction: GradientDirection.Top,
                repeating: false,
                colors: [[this.cardListParameter.maskColor, 0.0], ['#00ffffff', 1]]
              })
              .pixelRound({ bottom: PixelRoundCalcPolicy.FORCE_CEIL })
              .hitTestBehavior(HitTestMode.None)
          }

          if (this.cardListParameter.isBottomIcon) {
            Image(this.cardListParameter.bottomIcon)
              .width($r('app.float.bottom_icon_size'))
              .height($r('app.float.bottom_icon_size'))
          }
        }
        .width(this.FULL_WIDTH_PERCENT)
      }
      .backgroundImage(this.cardListParameter.backgroundImage)
      .backgroundImageSize(this.cardListParameter.backgroundImageSize)
      .backgroundColor(this.cardListParameter.backgroundColor)
      .padding({
        top: $r('app.float.list_side_padding'),
        bottom: $r('app.float.list_side_padding'),
        left: $r('app.float.list_side_padding'),
        right: $r('app.float.list_side_padding')
      })
    }
  }
}