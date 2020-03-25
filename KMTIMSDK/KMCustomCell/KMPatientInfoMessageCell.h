//
//  KMPatientInfoMessageCell.h
//  KMTIMSDK
//
//  Created by Ed on 2020/3/13.
//

#import <TXIMSDK_TUIKit_iOS/TUIMessageCell.h>
NS_ASSUME_NONNULL_BEGIN

@interface KMPatientInfoMessageCell : TUIMessageCell
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *patientTitle;
@property (nonatomic, strong) UILabel *patientInfo;
@end

NS_ASSUME_NONNULL_END
