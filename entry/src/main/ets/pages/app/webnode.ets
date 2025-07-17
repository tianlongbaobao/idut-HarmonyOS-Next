import { CustomNodePoolFactory, NodeContainerProxy, NodeItem, TypeReuseConfig, WebData  } from '@hadss/nodepool';
import { webpage } from './webpage';

interface mnv {
  accounts: string
  passwords: string
  url:string
  name:string
}
class Params {
  darkmode: boolean = false;
  vsf:mnv = {
    accounts:"",
    passwords:"",
    url:"",
    name:""
  }
  useragent:boolean = false
  noaccount:string = ""
  navstack:NavPathStack = new NavPathStack()

  constructor(darkmode: boolean,vsf:mnv,useragent:boolean,noaccount:string,navstack:NavPathStack) {
    this.darkmode = darkmode
    this.vsf = vsf
    this.useragent = useragent
    this.noaccount = noaccount
    this.navstack = navstack
  }
}

@Builder
export function WebBuilder(params: Params) {
  webpage({darkmode:params.darkmode,vsf:params.vsf,useragent:params.useragent,noaccount:params.noaccount})
}
let btnBuilder: WrappedBuilder<ESObject> = wrapBuilder<ESObject>(WebBuilder);


const REUSE_VIEW_TYPE_SWIPER: string = 'reuse_type_swiper_'

@Component
export struct preweb {
  @Prop nodePoolFactory: CustomNodePoolFactory
  private  controller: NodeItem | undefined;
  @Link vsf:mnv
  @Link darkmode:boolean
  @Link useragent:boolean
  @Link noaccount:string
  @Consume('pathInfos') pathStack: NavPathStack;

  aboutToAppear(): void {
    // 组件复用
    console.log(this.vsf.name)
    this.controller = this.nodePoolFactory.getCommonNodePool().getNode(REUSE_VIEW_TYPE_SWIPER, {
      darkmode:this.darkmode,vsf:this.vsf,useragent:this.useragent,noaccount:this.noaccount
    }, btnBuilder);
  }

  build() {
      Column() {
        NodeContainerProxy({ nodeItem: this.controller })
      }
  }
}