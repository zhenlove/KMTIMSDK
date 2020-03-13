//
//  KMPatientInfoMessageCellData.h
//  KMTIMSDK
//
//  Created by Ed on 2020/3/13.
//

#import "TUIMessageCellData.h"

NS_ASSUME_NONNULL_BEGIN

@interface KMPatientInfoMessageCellData : TUIMessageCellData
@property (nonatomic, copy) NSString * memberName;
@property (nonatomic, copy) NSString * age;
@property (nonatomic, copy) NSString * gender;
@property (nonatomic, copy) NSString * consultContent;
@property (nonatomic, strong) NSArray * userFile;
@property (nonatomic, strong) NSDictionary * userInfoDic;
@end

NS_ASSUME_NONNULL_END
