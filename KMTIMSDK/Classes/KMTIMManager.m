//
//  KMTIMManager.m
//  KMTIMSDK
//
//  Created by Ed on 2019/10/23.
//

#import "KMTIMManager.h"
#import "KMChatController.h"
#import <TXIMSDK_TUIKit_iOS/TUIKit.h>

@interface KMTIMManager()

@property(nonatomic,strong) TIMLoginParam * loginParam;

@end

@implementation KMTIMManager


+ (instancetype)sharedInstance
{
    static KMTIMManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[KMTIMManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)setupWithAppId:(NSInteger)sdkAppId {
    [[TUIKit sharedInstance] setupWithAppId:sdkAppId logLevel:TIM_LOG_NONE];
}

-(TIMLoginParam *)loginParam {
    if (!_loginParam) {
        _loginParam = [[TIMLoginParam alloc]init];
    }
    return _loginParam;
}

- (void)setupWithAppId:(NSInteger)sdkAppId UserSig:(NSString *)userSig andIdentifier:(NSString *)identifier {
    [self setupWithAppId:sdkAppId];
    self.loginParam.userSig = userSig;
    self.loginParam.identifier = identifier;
}


- (int)loginOfSucc:(KMTIMLoginSucc)succ fail:(KMTIMFail)fail {
    [[TIMManager sharedInstance] login:self.loginParam succ:succ fail:fail];
}

- (int)logout:(KMTIMLoginSucc)succ fail:(KMTIMFail)fail {
    [[TIMManager sharedInstance] logout:succ fail:fail];
}

- (UIViewController *)enterClinicWithChannleId:(NSString *)channleId {
    
}

- (UIViewController *)enterMessageRoomWithChannleId:(NSString *)channleId {
    TIMConversation *conv = [[TIMManager sharedInstance] getConversation:TIM_GROUP receiver:channleId];
    KMChatController * vc = [[KMChatController alloc] initWithConversation:conv];
//    [weakSelf.navigationController pushViewController:vc animated:YES];
    return vc;
}
@end
