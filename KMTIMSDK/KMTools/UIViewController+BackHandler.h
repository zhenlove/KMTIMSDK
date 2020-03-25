//
//  UIViewController+BackHandler.h
//  KMTIMSDK
//
//  Created by Ed on 2020/3/25.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KMBackHandlerProtocol <NSObject>
@optional
// Override this method in UIViewController derived class to handle 'Back' button click
-(BOOL)navigationShouldPopOnBackButton;
@end

@interface UIViewController (BackHandler)<KMBackHandlerProtocol>

@end

NS_ASSUME_NONNULL_END
