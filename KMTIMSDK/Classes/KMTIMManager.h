//
//  KMTIMManager.h
//  KMTIMSDK
//
//  Created by Ed on 2019/10/23.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

typedef void (^KMTIMLoginSucc)(void);

typedef void (^KMTIMFail)(int code, NSString * msg);

@interface KMTIMManager : NSObject

+ (instancetype)sharedInstance;

- (void)setupWithAppId:(NSInteger)sdkAppId UserSig:(NSString *)userSig andIdentifier:(NSString *)identifier;

- (int)loginOfSucc:(KMTIMLoginSucc)succ fail:(KMTIMFail)fail;

- (int)logout:(KMTIMLoginSucc)succ fail:(KMTIMFail)fail;

@end

NS_ASSUME_NONNULL_END
