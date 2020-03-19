//
//  KMNavigation.h
//  KMTIMSDK
//
//  Created by Ed on 2020/3/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KMNavigation : NSObject
+ (void)creatBackButtonTarget:(UIViewController *)target WithSelect:(SEL)selector;
@end

NS_ASSUME_NONNULL_END
