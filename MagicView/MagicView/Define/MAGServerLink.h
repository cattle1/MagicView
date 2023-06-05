//
//  MAGServerLink.h
//  MagicView
//
//  Created by LL on 2021/8/23.
//

#ifndef MAGServerLink_h
#define MAGServerLink_h

/*
 带 check 关键字都是壳子专用的接口
 */

// 系统配置信息
#define mCheckSettingLink @"/check/service/check-setting"

//  用户服务协议
#define mNotifyProtocolLink MAGInitializeManager.notifyProtocolLink

//  隐私政策
#define mPrivacyProtocolLink MAGInitializeManager.privacyProtocolLink

//  注销协议
#define mLogoffProtocolLink MAGInitializeManager.logoffProtocolLink

//  用户协议
#define mUserProtocolLink MAGInitializeManager.userProtocolLink

//  会员说明协议
#define mVipProtocolLink MAGInitializeManager.vipProtocolLink

//  首页
#define mBookMallLink @"/check/book/channel-index"

// 书籍详情
#define mBook_Mall_Detail @"/check/book/info"

// 查看更多
#define mBook_Recommend_More @"/check/book/recommend"

//  搜索首页(推荐热词和推荐书籍)
#define mBookSearchIndex @"/check/book/search-index"

//  搜索内容
#define mBookSearch @"/check/book/search"

//  个人中心
#define mUser_Center @"/check/user/index"

//  上传头像
#define mSet_Avatar @"/check/user/set-avatar"

//  商品列表
#define mGoodsListLink @"/check/review/goods"

//  小说全量目录接口
#define mBookFullCatalogLink @"/check/chapter/catalog"

//  小说分页目录接口
#define mBookPaginationCatalogLink @"/check/chapter/new-catalog"

//  小说章节内容接口
#define mBookChapterContentLink @"/check/review/chapter-text"

//  广告信息获取接口
#define mADInfoLink @"/check/advert/video-check"

//  小说分类
#define mBook_Category_List @"/check/book/category-index"

//  游客登录
#define mTourists_Login @"/check/user/device-login"

#endif /* MAGLink_h */
