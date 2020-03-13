//
//  KMURLMessageCellData.m
//  KMTIMSDK
//
//  Created by Ed on 2020/3/13.
//

#import "KMURLMessageCellData.h"

@implementation KMURLMessageCellData
- (CGSize)contentSize
{
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(300, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:15] } context:nil];
    CGSize size = CGSizeMake(ceilf(rect.size.width)+1, ceilf(rect.size.height));

    // 加上气泡边距
    size.height += 60;
    size.width += 20;

    return size;
}
@end
