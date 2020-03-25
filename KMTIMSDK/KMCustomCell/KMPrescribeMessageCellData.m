//
//  KMPrescribeMessageCellData.m
//  KMTIMSDK
//
//  Created by Ed on 2020/3/20.
//

#import "KMPrescribeMessageCellData.h"

@implementation KMPrescribeMessageCellData
- (CGSize)contentSize
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width/4,[UIScreen mainScreen].bounds.size.height/4);
}
@end

