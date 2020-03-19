//
//  KMTIMManager.h
//  KMTIMSDK
//
//  Created by Ed on 2019/10/23.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@protocol KMRoomStateListenerDelegate <NSObject>

- (void)listenerToChannelID:(NSString *)channelID withCustomElem:(NSDictionary *)customElem;

@end

typedef void (^KMTIMLoginSucc)(void);

typedef void (^KMTIMFail)(int code, NSString * msg);

@interface KMTIMManager : NSObject

@property (nonatomic, weak) id<KMRoomStateListenerDelegate>delegate;

+ (instancetype)sharedInstance;

- (void)setupWithAppId:(NSInteger)sdkAppId UserSig:(NSString *)userSig andIdentifier:(NSString *)identifier;

- (void)loginOfSucc:(KMTIMLoginSucc)succ fail:(KMTIMFail)fail;

- (void)logout:(KMTIMLoginSucc)succ fail:(KMTIMFail)fail;

@end

NS_ASSUME_NONNULL_END
