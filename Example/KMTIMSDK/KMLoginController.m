//
//  KMLoginController.m
//  KMTIMSDK_Example
//
//  Created by Ed on 2019/10/21.
//  Copyright © 2019 zhenlove. All rights reserved.
//

#import "KMLoginController.h"
//#import <KMTIMSDK/TUIKit.h>
//#import <KMTIMSDK/KMChatController.h>
#import <ImSDK/ImSDK.h>
#import "KMChatController.h"
#import "TUIKit.h"
@interface KMLoginController ()

@end

@implementation KMLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)clickeMessageBtn:(id)sender {
    
    NSString * userSig = @"eJw1kF1vgjAUhv9Lb7e4lrYCu2PTZSzqwocQvSEVipyJQKAKZNl-HxA8l89zPvKeX*RvvIWI4-JWqEj1lUSvSOMGI*h5UpDIQkEKsh6ESQnVZiGqCpJIqIjWyaDwjJvkEk1qYIRhjA1dZ3SWsquglpFI1bTOWI4Nj0E4D2i7PrzbzkoETv-SBc25Sb915rDc7T9cWB2zEDZOXtE2C483x96XVmtn1u5kBAcVPoX8vu1byzNNlsf9BWx--9P48BWckp13fft03W4*puA6BiVcJ0uNMv4IdZd1A2Ux-gATTjSKx0J--6TiWHw_";
    NSString * identifier = @"93132";

    NSInteger appid = 1400087743;

    [[TUIKit sharedInstance] setupWithAppId:appid];

    TIMLoginParam * loginParam = [[TIMLoginParam alloc]init];
    loginParam.userSig = userSig;
    loginParam.identifier = identifier;

    if ([[TIMManager sharedInstance] getLoginStatus] == TIM_STATUS_LOGINED) {
        [[TIMManager sharedInstance] logout:^{
            NSLog(@"退出登录");
        } fail:^(int code, NSString *msg) {
            NSLog(@"== %d,== %@",code,msg);
        }];
    }

    __weak typeof(self) weakSelf = self;

    [[TIMManager sharedInstance] login:loginParam succ:^{
        NSLog(@"登录成功");
        TIMConversation *conv = [[TIMManager sharedInstance] getConversation:TIM_GROUP receiver:@"200007228"];
        KMChatController * vc = [[KMChatController alloc] initWithConversation:conv];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    } fail:^(int code, NSString *msg) {
        NSLog(@"== %d,== %@",code,msg);
    }];
    
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
