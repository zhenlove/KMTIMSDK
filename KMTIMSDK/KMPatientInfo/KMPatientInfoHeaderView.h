//
//  KMPatientInfoHeaderView.h
//  gdhtcm
//
//  Created by Mac on 2018/3/29.
//  Copyright © 2018年 康美健康云. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMPatientInfoHeaderView : UIView

@property (nonatomic, strong) UIImageView   *headerPic;         //图像
@property (nonatomic, strong) UILabel       *DoctorNameLabe;    //医生姓名
@property (nonatomic, strong) UILabel       *descLabe;          //外科医生

@property (nonatomic, strong) UILabel       *titleLabe;         //图文咨询
@property (nonatomic, strong) UIView        *line;
@property (nonatomic, strong) UILabel       *detailLabel;        //病情描述

@property (nonatomic, strong) UIView        *line2;
@property (nonatomic, strong) UILabel       *pictureLabe;         //图片
@property (nonatomic, strong) UIView        *line3;

@end
