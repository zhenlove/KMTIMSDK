//
//  KMLoginController.m
//  KMTIMSDK_Example
//
//  Created by Ed on 2019/10/21.
//  Copyright © 2019 zhenlove. All rights reserved.
//

#import "KMLoginController.h"
#import "KMH5WebView.h"
#import <KMTIMSDK/KMTIMSDK.h>
#import "KMTIMSDK_Example-Swift.h"
#import <MJExtension/MJExtension.h>
#import <Masonry/Masonry.h>
@import KMAgoraRtc;

@implementation KMUserInfoModel
@end

@implementation KMIMConfigModel
@end

@implementation KMILiveConfig
@end

@implementation KMMediaConfigModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"ILiveConfig":@"KMILiveConfig"};
}
@end

@interface KMLoginController ()<KMH5JSCallBackDelegate,KMRoomStateListenerDelegate,KMFloatViewManagerDelegate>
@property (nonatomic,strong) KMH5WebView * h5WebView;
@property (nonatomic,strong) KMIMConfigModel * imConfigModel;
@property (nonatomic,strong) KMUserInfoModel * userInfoModel;
@property (nonatomic,strong) KMMediaConfigModel * mediaConfigModel;
@end

@implementation KMLoginController
-(KMH5WebView *)h5WebView{
    if (!_h5WebView) {
        _h5WebView = [[KMH5WebView alloc] init];
        _h5WebView.webView.backgroundColor  =  [UIColor whiteColor];
        _h5WebView.delegate = self;
        _h5WebView.hidden = true;
    }
    return _h5WebView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.navigationBarHidden = YES;
    [KMServiceModel setupParameterWithAppid:@"KMZSYY"
                                  appsecret:@"KMZSYY#2016@20161010$$!##"
                                     appkey:@"KMZSYY2016"
                                      orgid:@"B1F0AF7AB9624847A3DDAFD573E2ECF0"
                                environment:EnvironmentRelease1];
    
    [self.view addSubview:self.h5WebView];
    [self.h5WebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(20, 0, 0, 0));
    }];
    
    [KMFloatViewManager sharedInstance].delegate = self;
    [KMRoomStateListener sharedInstance].delegate = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)clickedHangupButton{
    NSLog(@"挂断");
    
//    KMChatRoomState endState = KMChatRoomState_Waiting;
//    if (KMNetworkConfigSharedInstance.userType == KMUserType_Doctor) {
//        endState = KMChatRoomState_Consulted;
//    }
//    [weakSelf updateChatRoomWithRoomState:endState];
    
    [self updateChatRoomChannelID:self.mediaConfigModel.ILiveConfig.ChannelID state:KMRoomState_Waiting];
}
- (void)clickedPrescribeButton{
    NSLog(@"开处方");
}
- (IBAction)clickeMessageBtn:(id)sender {
    
    
//@"https://tuser.kmwlyy.com:8060/h5/"
//@"https://user.kmwlyy.com/h5/yd/"
//@"https://user.kmwlyy.com/h5/szy/V0.1/"
//@"http://10.2.20.179:8080/"
//@"http://yruser.kmwlyy.com/h5/"
//@"http://pruser.kmwlyy.com/h5/yd/"
        
    NSDictionary * dic = @{@"Number":@"wangge",@"Name":@"",@"Mobile":@"",@"IdNumber":@"",@"HeadUrl":@"",@"OrgID":KMServiceModel.orgId};
    NSString * url = [KMServiceModel.baseURL stringByAppendingString:@"/users/InterLoginNoAccount"];
    [KMNetwork requestWithUrl:url
                       method:KMHTTPMethodPost
                   parameters:dic
                   isHttpBody:false
                requestSucess:^(NSHTTPURLResponse * _Nullable response, NSDictionary<NSString *,id> * _Nullable result) {
        self.userInfoModel = [KMUserInfoModel mj_objectWithKeyValues:result[@"Data"]];
        KMServiceModel.usertoken = self.userInfoModel.UserToken;

        self.h5WebView.hidden = false;
        NSDictionary *dic = @{@"AppKey":KMServiceModel.appKey,
                              @"AppToken":KMServiceModel.apptoken,
                              @"UserToken":KMServiceModel.usertoken,
                              @"OrgId":KMServiceModel.orgId};
        NSString * urlString = [NSString stringWithFormat:@"%@?%@",@"https://pruser.kmwlyy.com/h5/",[self spliceStringFromDictionary:dic]];
        self.h5WebView.urlString = urlString;
        [self.h5WebView startLoadRequest];
        NSLog(@"%@",urlString);
        [self performSelector:@selector(requestIMConfig) withObject:nil afterDelay:0.1];
        
    }requestFailure:^(NSHTTPURLResponse * _Nullable response, NSError * _Nullable error) {
        
    }];
}

-(NSString*)spliceStringFromDictionary:(NSDictionary *)dic {
    NSMutableArray *muArr = [[NSMutableArray alloc]init];
    for (NSString * key in  dic.allKeys) {
        NSString *str = [NSString stringWithFormat:@"%@=%@",key,dic[key]];
        [muArr addObject:str];
    }
    return [muArr componentsJoinedByString:@"&"];
}

// 获取IM配置
-(void)requestIMConfig {
    NSString * url = [KMServiceModel.baseURL stringByAppendingString:@"/IM/Config"];
    [KMNetwork requestWithUrl:url
                       method:KMHTTPMethodGet
                   parameters:nil
                   isHttpBody:false
                requestSucess:^(NSHTTPURLResponse * _Nullable response, NSDictionary<NSString *,id> * _Nullable result) {
        self.imConfigModel = [KMIMConfigModel mj_objectWithKeyValues:result[@"Data"]];
        [self logInIM];
        
    } requestFailure:^(NSHTTPURLResponse * _Nullable response , NSError * _Nullable error) {
        
    }];
}
// 登录IM
-(void)logInIM {
    [[KMTIMManager sharedInstance] setupWithAppId:self.imConfigModel.sdkAppID.integerValue
                                          UserSig:self.imConfigModel.userSig
                                    andIdentifier:self.imConfigModel.identifier];

    [[KMTIMManager sharedInstance] loginOfSucc:^{
        NSLog(@"IM登录成功");
        NSDictionary *dic = @{TIMProfileTypeKey_Nick:self.userInfoModel.UserCNName,TIMProfileTypeKey_FaceUrl:self.userInfoModel.PhotoUrl};
        [[TIMFriendshipManager sharedInstance] modifySelfProfile:dic succ:^{
            NSLog(@"设置用户资料成功");
        } fail:^(int code, NSString *msg) {
            NSLog(@"设置用户资料 code:%d msg:%@",code,msg);
        }];
    } fail:^(int code, NSString * _Nonnull msg) {
        NSLog(@"IM登录失败 code:%d msg:%@",code,msg);
    }];
}
// 获取媒体配置
-(void)getMediaConfigWithChannelID:(NSString *)channelID {
    NSString * url = [KMServiceModel.baseURL stringByAppendingString:@"/IM/MediaConfig"];
    NSDictionary *paramsDict = @{@"ChannelID":[NSNumber numberWithInteger:channelID.integerValue],@"Identifier":self.imConfigModel.identifier};
    [KMNetwork requestWithUrl:url
                       method:KMHTTPMethodGet
                   parameters:paramsDict
                   isHttpBody:false
                requestSucess:^(NSHTTPURLResponse * _Nullable response, NSDictionary<NSString *,id> * _Nullable result) {
        self.mediaConfigModel = [KMMediaConfigModel mj_objectWithKeyValues:result[@"Data"]];
        NSNumber *number = [NSNumber numberWithInteger:self.mediaConfigModel.ILiveConfig.Identifier.integerValue];
        [[KMFloatViewManager sharedInstance] showViewWithChannelKey:self.mediaConfigModel.MediaChannelKey
                                                          channelId:self.mediaConfigModel.ILiveConfig.ChannelID
                                                             userId:number.unsignedIntegerValue
                                                              appId:self.mediaConfigModel.AppID
                                                           userType:1];
        [self updateChatRoomChannelID:self.mediaConfigModel.ILiveConfig.ChannelID state:KMRoomState_Waiting];
    } requestFailure:^(NSHTTPURLResponse * _Nullable response , NSError * _Nullable error) {
        
    }];
}

-(void)updateChatRoomChannelID:(NSString *)channelID state:(KMRoomState)state {
    NSString * url = [KMServiceModel.baseURL stringByAppendingString:@"/IM/Room/State"];
    NSDictionary *paramsDict = @{@"ChannelID":[NSNumber numberWithInteger:channelID.integerValue],@"State":@(state)};
    [KMNetwork requestWithUrl:url
                       method:KMHTTPMethodPut
                   parameters:paramsDict
                   isHttpBody:false
                requestSucess:^(NSHTTPURLResponse * _Nullable response, NSDictionary<NSString *,id> * _Nullable result) {
        NSLog(@"设置房间状态--成功");
    } requestFailure:^(NSHTTPURLResponse * _Nullable response , NSError * _Nullable error) {
        NSLog(@"设置房间状态--失败");
    }];
}

- (void)listenerToChannelID:(NSString *)channelID withRoomState:(KMRoomState)state {
    if ([self.mediaConfigModel.ILiveConfig.ChannelID isEqualToString:channelID]) {
        switch (state) {
            case KMRoomState_Calling:
                [self updateChatRoomChannelID:channelID state:KMRoomState_Consulting]; //设置接听
                break;
            case KMRoomState_Leaving:
                
                break;
            case KMRoomState_PatientsLeaving:
                
                break;
                
            default:
                break;
        }
    }
}

/**
 js回调图文咨询
 */
-(void)jsCallChatWithParameterDictionary:(NSDictionary *)pDictionary{
    NSString * ChanelId = [[pDictionary objectForKey:@"ChanelId"] stringValue];
    NSInteger  ConsultState = [[pDictionary objectForKey:@"ConsultState"] integerValue];
//    NSString * DoctorName = [pDictionary objectForKey:@"DoctorName"];
        
    KMChatController  * chatController = [[KMChatController alloc]init];
    chatController.convId = ChanelId;
    chatController.title = @"图文问诊";
    chatController.consulationState = ConsultState;
    [self.navigationController pushViewController:chatController animated:true];
    
}

/**
 js回调音视频咨询
 */
-(void)jsCallAudioOrVideoWithParameterDictionary:(NSDictionary *)pDictionary{
//    CallType = 3;
//    ChannelID = 400048904;
//    UserFace = "https://prstore.kmwlyy.com/images/doctor/default.jpg";
//    UserID = b8dfd8d46727452b9c7d5147e9122090;
//    UserInfo = "\U5eb7\U7f8e\U533b\U9662";
//    UserName = "\U5eb7\U7f8e\U4e91";
//    UserPhone = "\U5185\U79d1";
    NSString * ChanelId = [[pDictionary objectForKey:@"ChannelID"] stringValue];
    
    KMChatController  * chatController = [[KMChatController alloc]init];
    chatController.convId = ChanelId;
    chatController.title = @"视频问诊";
//    chatController.title = [DoctorName stringByAppendingString:@"-医生"];
//    chatController.consulationState = ConsultState;
    [self.navigationController pushViewController:chatController animated:true];
    
    [self getMediaConfigWithChannelID:ChanelId];
    
    
}

/**
 js回调首页返回
 */
-(void)jsCallBack{
    self.h5WebView.hidden = true;
}

/**
 js回调刷新Token
 */
-(void)jsRefreshLoginInfo{
    NSMutableDictionary * loginInfo = [NSMutableDictionary dictionary];
    [loginInfo setObject:KMServiceModel.appKey forKey:@"AppKey"];
    [loginInfo setObject:KMServiceModel.apptoken forKey:@"AppToken"];
    [loginInfo setObject:KMServiceModel.usertoken forKey:@"UserToken"];
    [loginInfo setObject:KMServiceModel.orgId forKey:@"OrgId"];
    [loginInfo setObject:@"ios" forKey:@"Platform"];
    NSString * loginInfoJSONStr = [self dictionaryToJson:loginInfo];
    [self.h5WebView refreshLoginInfoWithJSONString:loginInfoJSONStr];
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
