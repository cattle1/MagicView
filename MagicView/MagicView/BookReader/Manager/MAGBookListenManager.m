//
//  MAGBookListenManager.m
//  MagicView
//
//  Created by LL on 2021/8/30.
//

#import "MAGBookListenManager.h"

#import <AVFoundation/AVFoundation.h>

#import "MAGImport.h"

static struct DelegateFlags {
    unsigned int didStartSpeechUtterance      : 1;
    unsigned int didStartNewSpeechUtterance   : 1;
    unsigned int didFinishSpeechUtterance     : 1;
    unsigned int didPauseSpeechUtterance      : 1;
    unsigned int didContinueSpeechUtterance   : 1;
    unsigned int didCancelSpeechUtterance     : 1;
    unsigned int willSpeakRangeOfSpeechString : 1;
}delegateFlags;

/// 如果获取不到男声则会返回其他性别的声音，如果获取不到指定名称的声音则会返回英语女声
AVSpeechSynthesisVoice *m_getVoice(NSString *language, BOOL isMale) {
    // 找到指定语言的声音
    NSMutableArray<AVSpeechSynthesisVoice *> *voices = [NSMutableArray array];
    for (AVSpeechSynthesisVoice *obj in [AVSpeechSynthesisVoice speechVoices]) {
        if (![obj.language isEqualToString:language]) continue;
        [voices addObject:obj];
    }
    
    // 找到合适性别的声音
    AVSpeechSynthesisVoice *voice = voices.firstObject;
    if (@available(iOS 13.0, *)) {
        for (AVSpeechSynthesisVoice *obj in voices) {
            if (isMale && (obj.gender == AVSpeechSynthesisVoiceGenderMale)) {
                voice = obj;
                break;
            } else if (!isMale && (obj.gender == AVSpeechSynthesisVoiceGenderFemale)) {
                voice = obj;
                break;
            }
        }
    }
    
    if (voice) return voice;
    return [AVSpeechSynthesisVoice voiceWithLanguage:@"en-GB"];
}

@interface MAGBookListenManager ()<AVSpeechSynthesizerDelegate>

@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, assign) BOOL isUserStop;

@end

@implementation MAGBookListenManager

+ (void)initialize {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
}

+ (instancetype)shareInstance {
    static MAGBookListenManager *_listenManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _listenManager = [[self alloc] init];
    });
    return _listenManager;
}

- (id)copyWithZone:(NSZone *)zone {
    return [MAGBookListenManager shareInstance];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [MAGBookListenManager shareInstance];
}

- (BOOL)startSpeaking {
    self.isUserStop = NO;
    
    if (self.synthesizer.isPaused) {
        return [self.synthesizer continueSpeaking];
    } else {
        if (mObjectIsEmpty(self.strings)) {
            if (delegateFlags.didFinishSpeechUtterance) {
                [self.delegate listenBookDidFinishSpeechUtterance:self];
            }
            return NO;
        }
        
        [self.synthesizer speakUtterance:[self utterance]];
        return YES;
    }
}

- (nullable AVSpeechUtterance *)utterance {
    NSString *text = [self.strings objectOrNilAtIndex:self.pageIndex];
    if (text == nil) return nil;
    
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:text];
    AVSpeechSynthesisVoice *voice = m_getVoice(@"en-GB", NO);
    utterance.voice = voice;
    
    return utterance;
}

- (void)setStartIndex:(NSInteger)startIndex {
    _startIndex = startIndex;
    self.pageIndex = startIndex;
}

- (BOOL)pauseSpeaking {
    return [self.synthesizer pauseSpeakingAtBoundary:AVSpeechBoundaryImmediate];
}

- (BOOL)stopSpeaking {
    self.isUserStop = YES;
    return [self.synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
}


#pragma mark - Setter/Getter
- (void)setDelegate:(id<MAGBookListenDelegate>)delegate {
    _delegate = delegate;
    
    delegateFlags.didStartSpeechUtterance = [delegate respondsToSelector:@selector(listenBookDidStartSpeechUtterance:)];
    delegateFlags.didStartNewSpeechUtterance = [delegate respondsToSelector:@selector(listenBookDidStartNewSpeechUtterance:chapterIndex:pageIndex:)];
    delegateFlags.didFinishSpeechUtterance = [delegate respondsToSelector:@selector(listenBookDidFinishSpeechUtterance:)];
    delegateFlags.didPauseSpeechUtterance = [delegate respondsToSelector:@selector(listenBookDidPauseSpeechUtterance:)];
    delegateFlags.didContinueSpeechUtterance = [delegate respondsToSelector:@selector(listenBookDidContinueSpeechUtterance:)];
    delegateFlags.didCancelSpeechUtterance = [delegate respondsToSelector:@selector(listenBookDidCancelSpeechUtterance:)];
    delegateFlags.willSpeakRangeOfSpeechString = [delegate respondsToSelector:@selector(listenBook:willSpeakRangeOfSpeechString:pageIndex:chapterIndex:)];
}

- (AVSpeechSynthesizer *)synthesizer {
    if (_synthesizer == nil) {
        _synthesizer = [[AVSpeechSynthesizer alloc] init];
        _synthesizer.delegate = self;
    }
    return _synthesizer;
}

- (BOOL)isPaused {
    return self.synthesizer.isPaused;
}

- (BOOL)isSpeaking {
    return self.synthesizer.speaking;
}


#pragma mark - AVSpeechSynthesizerDelegate
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance {
    if (delegateFlags.didStartSpeechUtterance) {
        [self.delegate listenBookDidStartSpeechUtterance:self];
    }
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
    if (delegateFlags.didFinishSpeechUtterance) {
        [self.delegate listenBookDidFinishSpeechUtterance:self];
    }
    
    if (self.isUserStop) return;
    
    self.pageIndex += 1;
    AVSpeechUtterance *speechUtterance = [self utterance];
    [self.synthesizer speakUtterance:speechUtterance];
    
    if (utterance) {
        if (delegateFlags.didStartNewSpeechUtterance) {
            [self.delegate listenBookDidStartNewSpeechUtterance:self chapterIndex:self.chapterIndex pageIndex:self.pageIndex];
        }
    }
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance {
    if (delegateFlags.didPauseSpeechUtterance) {
        [self.delegate listenBookDidPauseSpeechUtterance:self];
    }
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance *)utterance {
    if (delegateFlags.didContinueSpeechUtterance) {
        [self.delegate listenBookDidContinueSpeechUtterance:self];
    }
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance *)utterane {
    if (delegateFlags.didCancelSpeechUtterance) {
        [self.delegate listenBookDidCancelSpeechUtterance:self];
    }
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance {
    if (delegateFlags.willSpeakRangeOfSpeechString) {
        [self.delegate listenBook:self willSpeakRangeOfSpeechString:characterRange pageIndex:self.pageIndex chapterIndex:self.chapterIndex];
    }
}

@end
