//
//  KMPatientInfoHeaderView.m
//  gdhtcm
//
//  Created by Mac on 2018/3/29.
//  Copyright © 2018年 康美健康云. All rights reserved.
//

#import "KMPatientInfoHeaderView.h"
#import "KMHeader.h"
#import <Masonry/Masonry.h>
#import "UIImage+KMTIM.h"
@implementation KMPatientInfoHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self creatingInterfaceElements];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self creatingInterfaceElements];
    }
    return self;
}

-(UILabel *)createLabel{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (UIImageView *)headerPic {
    if (!_headerPic) {
        _headerPic = [[UIImageView alloc]initWithImage:[UIImage kmtim_imageNamed:@"defualt_head"]];
        _headerPic.layer.cornerRadius = 24;
        _headerPic.clipsToBounds = YES;
        _headerPic.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _headerPic.layer.borderWidth =   0.5;
    }
    return _headerPic;
}

- (UILabel *)DoctorNameLabe {
    if (_DoctorNameLabe == nil) {
        _DoctorNameLabe = [self createLabel];
        _DoctorNameLabe.textColor = UIColorFromRGB(0xffffff);//[self createLabelwithTextColor:@"#ffffff"];
        _DoctorNameLabe.font = [UIFont systemFontOfSize:15];
    }
    return _DoctorNameLabe;
}

- (UILabel *)descLabe {
    if (_descLabe == nil) {
        _descLabe = [self createLabel];
        _descLabe.textColor = UIColorFromRGB(0xffffff);//[self createLabelwithTextColor:@"#ffffff"];
        _descLabe.font = [UIFont systemFontOfSize:13];
    }
    return _descLabe;
}

- (UILabel *)titleLabe {
    if (_titleLabe == nil) {
        _titleLabe = [self createLabel];
        _titleLabe.textColor = UIColorFromRGB(0x333333);//[self createLabelwithTextColor:@"#333333"];
        _titleLabe.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabe;
}

-(UIView *)line{
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = [UIColor colorWithRed:(238)/255.f green:(238)/255.f blue:(238)/255.f alpha:1.f];
    }
    return _line;
}

- (UILabel *)detailLabel {
    if (_detailLabel == nil) {
        _detailLabel = [self createLabel];
        _detailLabel.textColor = UIColorFromRGB(0x666666);//[self createLabelwithTextColor:@"#666666"];
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.numberOfLines = 0;
        _detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _detailLabel;
}

-(UIView *)line2{
    if (!_line2) {
        _line2 = [[UIView alloc]init];
        _line2.backgroundColor = [UIColor colorWithRed:(238)/255.f green:(238)/255.f blue:(238)/255.f alpha:1.f];
    }
    return _line2;
}

- (UILabel *)pictureLabe{
    if (_pictureLabe == nil) {
        _pictureLabe = [self createLabel];
        _pictureLabe.textColor = UIColorFromRGB(0x333333);//[self createLabelwithTextColor:@"#333333"];
        _pictureLabe.textAlignment = NSTextAlignmentLeft;
    }
    return _pictureLabe;
}

-(UIView *)line3{
    if (!_line3) {
        _line3 = [[UIView alloc]init];
        _line3.backgroundColor = [UIColor colorWithRed:(238)/255.f green:(238)/255.f blue:(238)/255.f alpha:1.f];
    }
    return _line3;
}

- (void)creatingInterfaceElements {
    
    UIImageView *bgImgView = [[UIImageView alloc]initWithImage:[UIImage kmtim_imageNamed:@"background_benren"]];

    self.titleLabe.text = @"病情描述";
    self.pictureLabe.text = @"图片";
    
    [self addSubview:bgImgView];
    [self addSubview:self.headerPic];
    [self addSubview:self.DoctorNameLabe];
    [self addSubview:self.descLabe];
    [self addSubview:self.titleLabe];
    [self addSubview:self.line];
    [self addSubview:self.detailLabel];
    
    [self addSubview:self.line2];
    [self addSubview:self.pictureLabe];
    [self addSubview:self.line3];
    
    [bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(130);
    }];
    
    [self.headerPic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(15);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(47, 47));
    }];
    
    [self.DoctorNameLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.headerPic.mas_bottom).offset(10);
        make.height.mas_equalTo(20);
    }];
    
    [self.descLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.DoctorNameLabe.mas_bottom).offset(5);
        make.height.mas_equalTo(20);
    }];
    
    [self.titleLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgImgView.mas_bottom).offset(10);
        make.right.equalTo(self);
        make.left.equalTo(self.mas_left).offset(16);
        make.height.mas_equalTo(20);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabe.mas_bottom).offset(10);
        make.left.equalTo(self.titleLabe.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).offset(10);
        make.right.equalTo(self.titleLabe.mas_right).offset(-10);
        make.left.equalTo(self.titleLabe.mas_left);
        make.height.mas_equalTo(0);
    }];
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailLabel.mas_bottom).offset(20);
        make.right.left.equalTo(self);
        make.height.mas_equalTo(10);
    }];
    
    [self.pictureLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line2.mas_bottom).offset(10);
        make.right.equalTo(self);
        make.left.equalTo(self.mas_left).offset(16);
        make.height.mas_equalTo(20);
    }];
    
    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pictureLabe.mas_bottom).offset(10);
        make.left.equalTo(self.pictureLabe.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
}

@end
