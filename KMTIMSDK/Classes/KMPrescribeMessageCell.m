//
//  KMPrescribeMessageCell.m
//  KMTIMSDK
//
//  Created by Ed on 2020/3/20.
//

#import "KMPrescribeMessageCell.h"
#import "KMPrescribeMessageCellData.h"
#import <MMLayout/UIView+MMLayout.h>
#import <SDWebImage/SDWebImage.h>
@implementation KMPrescribeMessageCell

-(UIImageView *)prescribeImageView {
    if (!_prescribeImageView) {
        _prescribeImageView = [[UIImageView alloc]init];
        _prescribeImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _prescribeImageView;
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
        
        [self.container addSubview:self.prescribeImageView];
        self.container.backgroundColor = [UIColor whiteColor];
        [self.container.layer setMasksToBounds:YES];
        [self.container.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [self.container.layer setBorderWidth:1];
        [self.container.layer setCornerRadius:5];
    }
    return self;
}

- (void)fillWithData:(KMPrescribeMessageCellData *)data;
{
    [super fillWithData:data];
    [self.prescribeImageView sd_setImageWithURL:[NSURL URLWithString:data.recipeImgUrl]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.prescribeImageView.mm_top(0).mm_left(0).mm_width(self.container.mm_w).mm_height(self.container.mm_h);
}

@end
