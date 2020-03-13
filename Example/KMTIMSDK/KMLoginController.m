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

@interface KMLoginController ()<KMH5JSCallBackDelegate>
@property (nonatomic,strong) KMH5WebView * h5WebView;
@property (nonatomic,strong) KMIMConfigModel * imConfigModel;
@property (nonatomic,strong) KMUserInfoModel * userInfoModel;
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
                                environment:EnvironmentProduction];
    
    [self.view addSubview:self.h5WebView];
    [self.h5WebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(20, 0, 0, 0));
    }];
    
    
    // Do any additional setup after loading the view from its nib.
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
        NSString * urlString = [NSString stringWithFormat:@"%@?%@",@"https://user.kmwlyy.com/h5/yd/",[self spliceStringFromDictionary:dic]];
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
        
        
    } requestFailure:^(NSHTTPURLResponse * _Nullable response , NSError * _Nullable error) {
        
    }];
}

/**
 js回调图文咨询
 */
-(void)jsCallChatWithParameterDictionary:(NSDictionary *)pDictionary{
    NSString * ChanelId = [[pDictionary objectForKey:@"ChanelId"] stringValue];
    NSInteger  ConsultState = [[pDictionary objectForKey:@"ConsultState"] integerValue];
    NSString * DoctorName = [pDictionary objectForKey:@"DoctorName"];
        
    KMChatController  * chatController = [[KMChatController alloc]init];
    chatController.convId = ChanelId;
    chatController.title = [DoctorName stringByAppendingString:@"-医生"];
    chatController.consulationState = ConsultState;
    [self.navigationController pushViewController:chatController animated:true];
    
}

/**
 js回调音视频咨询
 */
-(void)jsCallAudioOrVideoWithParameterDictionary:(NSDictionary *)pDictionary{
    NSString * ChanelId = [[pDictionary objectForKey:@"ChannelID"] stringValue];
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
