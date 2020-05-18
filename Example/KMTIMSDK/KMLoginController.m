//
//  KMLoginController.m
//  KMTIMSDK_Example
//
//  Created by Ed on 2019/10/21.
//  Copyright © 2019 zhenlove. All rights reserved.
//

#import "KMLoginController.h"
@import KMNetwork;
@import KMOnlineWeb;
//@import KMModule;
@interface KMLoginController ()
@end

@implementation KMLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [KMServiceModel  setupParameterWithAppid:@"KMZSYY"
                                   appsecret:@"KMZSYY#2016@20161010$$!##"
                                      appkey:@"KMZSYY2016"
                                       orgid:@"B1F0AF7AB9624847A3DDAFD573E2ECF0"
                                 environment:EnvironmentRelease1];
}

- (IBAction)clickeMessageBtn:(id)sender {
    
    
//@"https://tuser.kmwlyy.com:8060/h5/"
//@"https://user.kmwlyy.com/h5/yd/"
//@"https://user.kmwlyy.com/h5/szy/V0.1/"
//@"http://10.2.20.179:8080/"
//@"http://yruser.kmwlyy.com/h5/"
//@"http://pruser.kmwlyy.com/h5/yd/"
    
    NSDictionary * dic = @{@"Number":@"wangge",
                           @"Name":@"",
                           @"Mobile":@"",
                           @"IdNumber":@"",
                           @"HeadUrl":@"",
                           @"OrgID":@"B1F0AF7AB9624847A3DDAFD573E2ECF0"};

//    [[KMOnlineManager sharedInstance] reloadWebViewWithUrl:@"http://pruser.kmwlyy.com/h5/"
//                                                   withDic:dic
//                                        showViewController:self];
    [[OnlineWebManager sharedInstance] reloadWebViewWithUrl:@"http://pruser.kmwlyy.com/h5/"
                                                userInfoDic:dic
                                             fromNavControl:self.navigationController];
//    __weak typeof(self) weakSelf = self;
//    [OnlineWebManager sharedInstance].patientInfoBlock = ^(NSDictionary *info){
//        KMPatientInfoVC *infoVC = [[KMPatientInfoVC alloc]init];
//        [weakSelf.navigationController pushViewController:infoVC animated:YES];
//    };
//    [OnlineWebManager sharedInstance].prescribeBlock = ^(NSString * url, NSString * opdRegisterID) {
//        KMIMWebViewController *webView = [[KMIMWebViewController alloc]init];
//        [weakSelf.navigationController pushViewController:webView animated:YES];
//    };
}




@end
