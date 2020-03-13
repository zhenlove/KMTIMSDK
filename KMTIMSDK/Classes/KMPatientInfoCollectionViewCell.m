//
//  KMPatientInfoCollectionViewCell.m
//  gdhtcm
//
//  Created by Mac on 2018/3/29.
//  Copyright © 2018年 康美健康云. All rights reserved.
//

#import "KMPatientInfoCollectionViewCell.h"
#import <Masonry/Masonry.h>
@implementation KMPatientInfoCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        // 添加一个UIImageView
        self.imgView = [[UIImageView alloc]init];
        self.imgView.backgroundColor = [UIColor lightGrayColor];
        self.imgView.clipsToBounds = YES;
        self.imgView.layer.cornerRadius = 5;
        self.imgView.layer.masksToBounds = YES;
        self.imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.imgView];
        
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return self;
}

@end
