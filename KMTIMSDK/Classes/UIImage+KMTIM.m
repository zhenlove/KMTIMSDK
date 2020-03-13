//
//  UIImage+KMTIM.m
//  KMTIMSDK
//
//  Created by Ed on 2020/3/13.
//

#import "UIImage+KMTIM.h"
#import "KMHeader.h"
@implementation UIImage (KMTIM)
+ (UIImage *)kmtim_imageNamed:(NSString *)name {
    return [UIImage imageNamed:KMTIMResource(name)];
}
@end
