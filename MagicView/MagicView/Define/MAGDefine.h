//
//  MAGDefine.h
//  MagicView
//
//  Created by LL on 2021/7/8.
//

/*
 禁止在工程内直接使用标识符，所有标识符统一在 MAGDefine 中定义
 */
#ifndef MAGDefine_h
#define MAGDefine_h

#define mUserDefault MAGUserDefaults

#define mNotificationCenter NSNotificationCenter.defaultCenter

#define mFileManager NSFileManager.defaultManager

#define mPlaceholdImage [UIImage imageNamed:@"m_placeholderImage"]


#pragma mark - 小说相关标识符
// 小说阅读器背景存储标识符
#define mBookReaderBackgroundImageStyleKey @"magic_book_reader_background_image_style"

// 小说阅读器翻页动画标识符
#define mBookReaderAnimateStyleKey @"magic_book_reader_animate_style"

// 小说阅读器字体大小标识符
#define mBookReaderTextFontSizeKey @"magic_book_reader_text_font_size"

// 小说阅读器无数据标识符
#define mBookNoDataIdentifier @"magic_book_no_data"


#pragma mark - 用户相关标识符
// 当前登录用户的token标识符
#define mCurrentUserToken @"magic_current_login_user_token"


#pragma mark - APP相关标识符
// 启动次数标识符
#define mStartNumberIdentifier @"magic_start_number"

#define mLanguageIdentifier @"magic_language"

#define mIsDarkmodeIdentifier @"magic_is_darkmode"

// APP内购状态标识符
#define mCanPaymentsIdentifier @"magic_is_can_make_payments"

// AES密钥本地存储标识符
#define mAESKeyIdentifier @"magic_aes_key_identifier"

// 埋点数据标识符
#define mClickEventDataIdentifier @"magic_event_list"

// 壳子禁用状态标识符
#define mDisableState @"magic_disable_state"

// URL的缓存标识符
#define mNoChineseCharCacheKey @"magic_no_chinese_char"

// UUID本地缓存标识符
#define mUUIDKey @"magic_property_uuid_key"

// 穿山甲广告Key
#ifdef BUA_App_Key
    #define mPangolinAppKey BUA_App_Key
#else
    #define mPangolinAppKey @""
#endif

//  用户金币数
#define mUserGoldRemain @"mUserGoldRemain"

#endif /* MAGDefine_h */
