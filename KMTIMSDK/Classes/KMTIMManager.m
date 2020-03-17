//
//  KMTIMManager.m
//  KMTIMSDK
//
//  Created by Ed on 2019/10/23.
//

#import "KMTIMManager.h"
#import "UIImage+KMTIM.h"
#import <TXIMSDK_TUIKit_iOS/TUIKit.h>
#import "KMRoomStateListener.h"
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
        [KMRoomStateListener sharedInstance];
    }
    return self;
}

- (void)setupWithAppId:(NSInteger)sdkAppId {
    [[TUIKit sharedInstance] setupWithAppId:sdkAppId logLevel:TIM_LOG_NONE];
    
    TUIKitConfig * config = [TUIKitConfig defaultConfig];
    config.avatarType = TAvatarTypeRadiusCorner;
//    config.avatarCornerRadius = 20.f; // 如果需要设置头像为圆形时，取消注释即可
    config.faceGroups = @[config.faceGroups.firstObject];
    
    //患者默认
//    config.defaultAvatarImage = [UIImage kmtim_imageNamed:@"defualt_head"];
//    config.defaultGroupAvatarImage = [UIImage kmtim_imageNamed:@"defualt_head"];
    //医生默认
    config.defaultAvatarImage = [UIImage kmtim_imageNamed:@"icon_Default_Head"];
    config.defaultGroupAvatarImage = [UIImage kmtim_imageNamed:@"icon_Default_Head"];
    
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
@end
