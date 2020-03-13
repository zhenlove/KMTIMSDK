//
//  KMPatientInfoVC.h
//  gdhtcm
//
//  Created by Mac on 2018/3/29.
//  Copyright © 2018年 康美健康云. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMPatientInfoVC : UIViewController

@property (nonatomic, copy) NSString  *patientName;  //患者姓名
@property (nonatomic, copy) NSString  *age;          //岁数
@property (nonatomic, copy) NSString  *sex;          //性别
@property (nonatomic, copy) NSString  *desc;         //病情描述
@property (nonatomic, strong) NSArray *pictureArray; //图片数组
@property (nonatomic, strong) NSDictionary * userInfoDic;
@end
