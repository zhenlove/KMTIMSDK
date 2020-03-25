//
//  KMChatController.h
//  Pods-KMTIMSDK_Example
//
//  Created by Ed on 2019/10/21.
//

#import <UIKit/UIKit.h>

/**咨询状态 （-1 default 0-未筛选、1-未领取、2-未回复、4-已回复、5-已完成）*/
//咨询状态(0-未筛选、1-未领取、2-已领取、3-未回复、4-已回复、5-已完成)
typedef NS_ENUM(NSInteger, KMConsultationState) {
    /**默认状态 -1*/
    KMConsultationState_Default = -1,//
    /**未筛选 0*/
    KMConsultationState_Unfiltered = 0,//
    /**未领取 1*/
    KMConsultationState_Unclaimed = 1,//
    /**已领取 2*/
    KMConsultationState_Claimed = 2,//
    /**未回复 3*/
    KMConsultationState_NotReply = 3,//
    /**已回复 4*/
    KMConsultationState_Replied = 4,//
    /**已完成 5*/
    KMConsultationState_Finished = 5,//
};

@protocol KMChatControllerDelegate<NSObject>
@optional

/// 点击患者咨询
-(void)clickePatientInfo:(NSDictionary *)patientInfoDic;

/// 点击处方
-(void)clickePrescribe:(NSString *)prescribeUrl oPDRegisterID:(NSString *)OPDRegisterID;

/// 点击返回
- (BOOL)clickeBackBtnController;

@end

NS_ASSUME_NONNULL_BEGIN
@interface KMChatController : UIViewController
/** 咨询状态 */
@property (nonatomic, assign) KMConsultationState consulationState;
@property (nonatomic, copy) NSString *convId;
@property (nonatomic, weak) id<KMChatControllerDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
