//
//  KMPrescribeMessageCellData.h
//  KMTIMSDK
//
//  Created by Ed on 2020/3/20.
//

#import "TUIMessageCellData.h"

NS_ASSUME_NONNULL_BEGIN

@interface KMPrescribeMessageCellData : TUIMessageCellData
@property (nonatomic, copy) NSString * recipeImgUrl;
@property (nonatomic, copy) NSString * OPDRegisterID;
@end

NS_ASSUME_NONNULL_END
