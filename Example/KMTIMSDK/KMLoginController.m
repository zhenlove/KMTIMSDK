//
//  KMLoginController.m
//  KMTIMSDK_Example
//
//  Created by Ed on 2019/10/21.
//  Copyright © 2019 zhenlove. All rights reserved.
//

#import "KMLoginController.h"
#import "KMTIMManager.h"
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
    
    __weak typeof(self) weakSelf = self;
    [[KMTIMManager sharedInstance] setupWithAppId:appid];
    [[KMTIMManager sharedInstance] setupWithUserSig:userSig andIdentifier:identifier];
    [[KMTIMManager sharedInstance] loginOfSucc:^{
        UIViewController *vc =[[KMTIMManager sharedInstance] enterMessageRoomWithChannleId:@"200007228"];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    } fail:^(int code, NSString * _Nonnull msg) {
        
    }];
}

@end
