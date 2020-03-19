//
//  KMLoginController.m
//  KMTIMSDK_Example
//
//  Created by Ed on 2019/10/21.
//  Copyright © 2019 zhenlove. All rights reserved.
//

#import "KMLoginController.h"
#import "KMTIMSDK_Example-Swift.h"
#import <MJExtension/MJExtension.h>
#import "KMModels.h"
#import "KMWebViewController.h"
@import KMNetwork;



@interface KMLoginController ()
@property (nonatomic,strong) KMUserInfoModel * userInfoModel;
@end

@implementation KMLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.navigationBarHidden = YES;
    [KMServiceModel  setupParameterWithAppid:@"KMZSYY"
                                   appsecret:@"KMZSYY#2016@20161010$$!##"
                                      appkey:@"KMZSYY2016"
                                       orgid:@"B1F0AF7AB9624847A3DDAFD573E2ECF0"
                                 environment:EnvironmentRelease1];

    // Do any additional setup after loading the view from its nib.
}

- (IBAction)clickeMessageBtn:(id)sender {
    
    
//@"https://tuser.kmwlyy.com:8060/h5/"
//@"https://user.kmwlyy.com/h5/yd/"
//@"https://user.kmwlyy.com/h5/szy/V0.1/"
//@"http://10.2.20.179:8080/"
//@"http://yruser.kmwlyy.com/h5/"
//@"http://pruser.kmwlyy.com/h5/yd/"
    
    NSDictionary * dic = @{@"Number":@"wangge",@"Name":@"",@"Mobile":@"",@"IdNumber":@"",@"HeadUrl":@"",@"OrgID":[KMServiceModel sharedInstance].orgId};
    NSString * url = [[KMServiceModel sharedInstance].baseURL stringByAppendingString:@"/users/InterLoginNoAccount"];
    [KMNetwork requestWithUrl:url
                       method:@"POST"
                   parameters:dic
                   isHttpBody:false
                requestSucess:^(NSHTTPURLResponse * _Nullable response, NSDictionary<NSString *,id> * _Nullable result) {
        self.userInfoModel = [KMUserInfoModel mj_objectWithKeyValues:result[@"Data"]];
        [KMServiceModel sharedInstance].usertoken = self.userInfoModel.UserToken;

        NSDictionary *dic = @{@"AppKey":[KMServiceModel sharedInstance].appKey,
                              @"AppToken":[KMServiceModel sharedInstance].apptoken,
                              @"UserToken":[KMServiceModel sharedInstance].usertoken,
                              @"OrgId":[KMServiceModel sharedInstance].orgId};
        NSString * urlString = [NSString stringWithFormat:@"%@?%@",@"https://pruser.kmwlyy.com/h5/",[self spliceStringFromDictionary:dic]];

        NSLog(@"%@",urlString);
        
        KMWebViewController * webViewController = [[KMWebViewController alloc]init];
        webViewController.urlString = urlString;
        webViewController.userInfoModel = self.userInfoModel;
        [self.navigationController pushViewController:webViewController animated:true];

        
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



@end
