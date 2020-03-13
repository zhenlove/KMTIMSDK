//
//  KMPatientInfoMessageCellData.m
//  KMTIMSDK
//
//  Created by Ed on 2020/3/13.
//

#import "KMPatientInfoMessageCellData.h"

@implementation KMPatientInfoMessageCellData
- (CGSize)contentSize
{
    NSString * msg = [NSString stringWithFormat:@"%@/%@岁/%@",self.memberName,self.age,self.gender];
    CGRect rect = [msg boundingRectWithSize:CGSizeMake(300, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:15] } context:nil];
    CGSize size = CGSizeMake(ceilf(rect.size.width)+1, ceilf(rect.size.height));
    
    NSString * msg1 = @"就诊人信息";
    CGRect rect1 = [msg1 boundingRectWithSize:CGSizeMake(300, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:15] } context:nil];
    CGSize size1 = CGSizeMake(ceilf(rect1.size.width)+1, ceilf(rect1.size.height));

    // 加上气泡边距
    size.height = 20 + 43;
    size.width  = 20 + 43 + MAX(size.width, size1.width);

    return size;
}
@end
