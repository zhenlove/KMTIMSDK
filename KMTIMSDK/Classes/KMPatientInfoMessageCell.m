//
//  KMPatientInfoMessageCell.m
//  KMTIMSDK
//
//  Created by Ed on 2020/3/13.
//

#import "KMPatientInfoMessageCell.h"
#import "KMPatientInfoMessageCellData.h"
#import "KMHeader.h"
#import "UIImage+KMTIM.h"
#import <MMLayout/UIView+MMLayout.h>
@implementation KMPatientInfoMessageCell
-(UIImageView *)iconImage {
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc]init];
        [_iconImage setImage:[UIImage kmtim_imageNamed:@"icon_messagePatient"]];
    }
    return _iconImage;
}
- (UILabel *)patientInfo {
    if (!_patientInfo) {
        _patientInfo = [[UILabel alloc]init];
        _patientInfo.textColor = UIColorFromRGB(0x999999);
        _patientInfo.font = [UIFont systemFontOfSize:13];
        _patientInfo.text = @"陈佳音 / 25岁 / 女";
    }
    return _patientInfo;
}
- (UILabel *)patientTitle {
    if (!_patientTitle) {
        _patientTitle = [[UILabel alloc]init];
        _patientTitle.textColor = UIColorFromRGB(0x333333);
        _patientTitle.font = [UIFont systemFontOfSize:15];
        _patientTitle.text = @"就诊人信息";
    }
    return _patientTitle;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.container addSubview:self.iconImage];
        [self.container addSubview:self.patientTitle];
        [self.container addSubview:self.patientInfo];

        self.container.backgroundColor = [UIColor whiteColor];
        [self.container.layer setMasksToBounds:YES];
        [self.container.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [self.container.layer setBorderWidth:1];
        [self.container.layer setCornerRadius:5];
    }
    return self;
}

- (void)fillWithData:(KMPatientInfoMessageCellData *)data;
{
    [super fillWithData:data];

    self.patientInfo.text = [NSString stringWithFormat:@"%@/%@岁/%@",data.memberName,data.age,data.gender];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.iconImage.mm_left(10).mm_height(43).mm_width(43).mm_top(10);
    self.patientTitle.mm_sizeToFit().mm_top(self.iconImage.mm_x).mm_left(self.iconImage.mm_w+20);
    self.patientInfo.mm_sizeToFit().mm_bottom(self.iconImage.mm_b).mm_left(self.iconImage.mm_w+20);

}

@end
