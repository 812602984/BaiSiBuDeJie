# 百思不得姐（BaiSiBuDeJie）

一个**完整的第三方内容社区客户端仿写**，Objective-C，纯代码 + xib 混合布局。

从启动广告、四个主 Tab、四类内容形态（文字 / 图片 / 视频 / 音频）、评论、发布、登录注册，到自定义 TabBar，是一套能完整跑通业务闭环的 iOS 工程。代码按模块分层，适合直接拿来读结构、拆组件。

## 五个 Tab

| Tab | 内容 |
| --- | --- |
| **精华** | 帖子瀑布流，按"全部 / 视频 / 图片 / 段子 / 音频"切换 |
| **新帖** | 最新发布的帖子流 |
| **关注** | 推荐用户、推荐标签，未登录引导注册 |
| **我** | 个人中心，九宫格功能入口 |
| **发布**（中间按钮） | 弹出式发布面板：发文字帖、发图片、加标签 |

## 主要功能

- **四类帖子形态**：纯文字、图片（带进度条加载）、视频（内联播放）、音频（波形进度）
- **图片浏览器**：点击图片进入全屏查看，支持缩放、下滑退出
- **评论**：帖子详情下方的盖楼式评论列表
- **登录注册**：手机号注册 + 第三方 OAuth 登录，账号信息持久化
- **推荐关注**：左侧分类、右侧用户列表的两栏联动
- **下拉刷新 / 上拉加载**：MJRefresh 封装
- **自定义 TabBar**：中间的发布按钮凸起，用 KVC 替换系统 tabBar

## 技术要点

**1. 模型驱动的高度计算**
`BSTopic` 里除了接口字段，还带 `cellHeight`、`pictureFrame`、`voiceFrame` 这些只读属性，在 getter 里按文字宽度、图片比例实时算出每个 cell 的高度和内部控件的位置。cell 只负责摆放，不做计算，滚动时不会重复算导致卡顿。

**2. pop 动画做发布面板**
发布页的按钮弹射展开用的是 Facebook 的 `pop` 引擎，`POPSpringAnimation` 控制 `kPOPViewFrame` 和 `kPOPViewCenter`，`springBounciness` 和 `springSpeed` 是调弹性手感的两个参数。

**3. 三种帖子视图拆开**
`BSTopicPictureView`、`BSTopicVideoView`、`BSTopicVoiceView` 各自独立，同一行 cell 里按 `topic.type` 决定显示哪个。避免了在一个 cell 里塞一堆 `if` 判断和隐藏逻辑。

**4. 图片查看器的转场**
从列表小图进全屏大图，截图 + 位移动画的写法，退出时反向播放回原位。

**5. 模块化分层**
`Classes/` 下按业务模块划分（Essence、FriendTrends、Me、New、Publish、AdVertise、Main、Others），每个模块内部再分 `Controller` / `Model` / `View`，找代码不用翻几十个平铺文件。

## 依赖

通过 CocoaPods 管理，`Podfile` 声明：

| 库 | 用途 |
| --- | --- |
| `AFNetworking ~> 3.1.0` | 网络请求 |
| `SDWebImage+ExtensionSupport ~> 3.7.1.2` | 图片加载（带 GIF 支持） |
| `SVProgressHUD ~> 2.1.2` | 轻提示 |
| `MJExtension ~> 3.0.13` | JSON → 模型 |
| `MJRefresh ~> 3.1.12` | 下拉刷新 / 上拉加载 |
| `DACircularProgress ~> 2.3.1` | 图片加载的环形进度 |
| `pop ~> 1.0.9` | 弹性动画 |

`Pods/` 目录已经提交到仓库，**不用再 `pod install`**。

## 怎么跑起来

1. 用 Xcode 打开 `百思不得姐.xcworkspace`（**不是 `.xcodeproj`**，工程依赖 Pods）
2. 选任意 iPhone 模拟器，直接 Run
3. 部署目标 iOS 10.3

> 注意：工程里请求的是百思不得姐官方接口 `https://api.budejie.com/api/api_open.php`。这个接口是多年前的公开接口，**随时可能已经不可用**。如果跑起来列表是空的，先看控制台请求返回，多半是接口挂了，换成本地 mock 数据即可，界面逻辑本身不受影响。

## 目录结构

```
百思不得姐/
├── Classes/
│   ├── Main/              TabBar 控制器、导航控制器、AppDelegate
│   ├── Essence/           精华：帖子列表、帖子详情、评论、图片浏览、推荐标签
│   ├── New/               新帖
│   ├── FriendTrends/      关注：推荐用户、登录注册、OAuth
│   ├── Me/                我的：九宫格、Web 页
│   ├── Publish/           发布：文字帖、选图、加标签
│   ├── AdVertise/         启动广告页
│   └── Others/            网络状态、各类 Category
└── Assets.xcassets/       图标与占位图
```

## 已知限制

- `Podfile` 里 `SDWebImage/GIF ~> 4.0.0` 那一行是注释掉的，实际用的是 `SDWebImage+ExtensionSupport`（3.x 版本），GIF 支持来自后者。
- 依赖第三方接口，接口失效则列表为空，需要自行替换数据源。
- 只写了 iOS 端，服务端不在仓库里。
- 部分 xib 是用 Interface Builder 拖的，和纯代码布局混用，改样式时注意两边都要看。

## License

未声明。代码可自由参考。
