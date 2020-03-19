//
//  KMNavigation.m
//  KMTIMSDK
//
//  Created by Ed on 2020/3/17.
//

#import "KMNavigation.h"
#import "UIImage+KMTIM.h"
@implementation KMNavigation

+ (void)creatBackButtonTarget:(UIViewController *)target WithSelect:(SEL)selector {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 60, 40);
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btn setImage:[UIImage kmtim_imageNamed:@"back"] forState:UIControlStateNormal];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    target.navigationItem.leftBarButtonItem = barItem;
    [target.navigationController.interactivePopGestureRecognizer setEnabled:NO];
    target.navigationController.interactivePopGestureRecognizer.delegate = (id)target;
}
@end
