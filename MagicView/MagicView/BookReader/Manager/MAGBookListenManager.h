//
//  MAGBookListenManager.h
//  MagicView
//
//  Created by LL on 2021/8/30.
//

#import <Foundation/Foundation.h>

@class MAGBookListenManager;


NS_ASSUME_NONNULL_BEGIN

@protocol MAGBookListenDelegate <NSObject>

/// 通知观察者已经开始播放
- (void)listenBookDidStartSpeechUtterance:(MAGBookListenManager *)listenManager;

/// 通知观察者已经播放完毕
- (void)listenBookDidFinishSpeechUtterance:(MAGBookListenManager *)listenManager;

/// 通知观察者即将开始播放新的一页
- (void)listenBookDidStartNewSpeechUtterance:(MAGBookListenManager *)listenManager chapterIndex:(NSInteger)chapterIndex pageIndex:(NSInteger)pageIndex;

/// 通知观察者已经暂停播放
- (void)listenBookDidPauseSpeechUtterance:(MAGBookListenManager *)listenManager;

/// 通知观察者已经从暂停中恢复播放
- (void)listenBookDidContinueSpeechUtterance:(MAGBookListenManager *)listenManager;

/// 通知观察者已经取消播放
- (void)listenBookDidCancelSpeechUtterance:(MAGBookListenManager *)listenManager;

/// 通知观察者即将说出某一段话
/// @param characterRange 话语中的字符范围
/// @param pageIndex 正在读的是第几页
- (void)listenBook:(MAGBookListenManager *)listenManager willSpeakRangeOfSpeechString:(NSRange)characterRange pageIndex:(NSInteger)pageIndex chapterIndex:(NSInteger)chapterIndex;

@end

@interface MAGBookListenManager : NSObject<NSCopying, NSMutableCopying>

@property (nonatomic, copy) NSArray<NSString *> *strings;

/// 当前正在阅读的章节索引
@property (nonatomic, assign) NSInteger chapterIndex;

/// 决定从 strings 的第几个元素开始阅读
@property (nonatomic, assign) NSInteger startIndex;

@property (nonatomic, weak) id<MAGBookListenDelegate> delegate;

/**
 * 一个布尔值，指示合成器是否正在说话。
 *
 * 如果合成器正在说话或有话语排队说话，则返回 YES，即使它当前已暂停。 如果合成器已完成其队列中的所有话语或尚未获得发言权，则返回 NO
 */
@property(nonatomic, readonly) BOOL isSpeaking;

/**
 * 一个布尔值，指示语音是否已暂停。
 *
 * 如果合成器已经开始说话并使用 pauseSpeaking 暂停，则返回 YES，否则返回NO。
 */
@property(nonatomic, readonly, getter=isPaused) BOOL paused;

+ (instancetype)shareInstance;

+ (instancetype)allocWithZone:(struct _NSZone *)zone UNAVAILABLE_ATTRIBUTE;
+ (instancetype)alloc UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

/// 如果尚未播放则开始播放，如果已暂停则恢复播放
- (BOOL)startSpeaking;

- (BOOL)pauseSpeaking;

/// 停止播放后将不能恢复
- (BOOL)stopSpeaking;

@end

NS_ASSUME_NONNULL_END
