//
//  KMPatientInfoVC.m
//  gdhtcm
//
//  Created by Mac on 2018/3/29.
//  Copyright © 2018年 康美健康云. All rights reserved.
//

#import "KMPatientInfoVC.h"
#import "KMPatientInfoHeaderView.h"
#import "KMPatientInfoCollectionViewCell.h"
#import "KMVerticalFlowLayout.h"
#import "KMNavigation.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>
@interface KMPatientInfoVC () <UICollectionViewDelegate,UICollectionViewDataSource,KMVerticalFlowLayoutDelegate>

@property (nonatomic, strong) UIScrollView              *scrollView;
@property (nonatomic, strong) UIView                    *contentView;
@property (nonatomic, strong) KMPatientInfoHeaderView   *headerView;
@property (nonatomic, strong) UICollectionView          *collectionView;

@end

@implementation KMPatientInfoVC

- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIView *)contentView
{
    if (_contentView == nil) {
        _contentView = [[UIView alloc]init];
    }
    return _contentView;
}

-(UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.scrollEnabled = NO;
        KMVerticalFlowLayout *layout = [[KMVerticalFlowLayout alloc]initWithDelegate:self];
        _collectionView.collectionViewLayout = layout;
        [_collectionView registerClass:[KMPatientInfoCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([KMPatientInfoCollectionViewCell class])];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (KMPatientInfoHeaderView *)headerView {
    if (_headerView == nil) {
        _headerView = [[KMPatientInfoHeaderView alloc]init];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}
-(void)setUserInfoDic:(NSDictionary *)userInfoDic {
    _userInfoDic = userInfoDic;
    
    self.patientName = userInfoDic[@"MemberName"];
    self.age = userInfoDic[@"Age"];
    NSArray * genderArr = @[@"男",@"女",@"未知"];//性别（0-男、1-女、2-未知)
    self.sex = genderArr[[userInfoDic[@"Gender"] integerValue]];
    self.desc = userInfoDic[@"ConsultContent"];
    self.pictureArray = userInfoDic[@"UserFiles"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"就诊人信息";
    self.view.backgroundColor = [UIColor whiteColor];
    [KMNavigation creatBackButtonTarget:self WithSelect:@selector(clickeBackBtn)];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.headerView];
    [self.contentView addSubview:self.collectionView];
    
    if (@available(iOS 11.0, *)){
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }];
    }else{
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.view.mas_width);
        make.height.greaterThanOrEqualTo(@0.f);
    }];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(400);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(3 *120);
    }];
    
}

- (void)updateViewConstraints{
    
    self.headerView.DoctorNameLabe.text = self.patientName;
    self.headerView.descLabe.text = [NSString stringWithFormat:@"%@岁 | %@",self.age,self.sex];
    self.headerView.detailLabel.text = self.desc;
    CGFloat ScreenWidth = [UIScreen mainScreen].bounds.size.width;
    CGSize size = [self.headerView.detailLabel sizeThatFits:CGSizeMake(ScreenWidth - 50, MAXFLOAT)];
    
    [self.headerView.detailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(size.height);
    }];
    
    [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(130 + 40 + size.height + 50 + 33);
    }];
    
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(3 *120);
    }];
    
    [super updateViewConstraints];
}


#pragma mark -Action

- (void)clickeBackBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -UICollectionViewDelegate, UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.pictureArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    KMPatientInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([KMPatientInfoCollectionViewCell class]) forIndexPath:indexPath];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:self.pictureArray[indexPath.item][@"FileUrl"]] placeholderImage:nil];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",indexPath.item);
}


#pragma mark - ZJVerticalFlowLayoutDelegate

/**
 * 需要显示的列数, 默认3
 */
- (NSInteger)km_waterflowLayout:(KMVerticalFlowLayout *)waterflowLayout columnsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

/**
 * 设置cell的高度
 
 @param indexPath 索引
 @param itemWidth 宽度
 */
-(CGFloat)km_waterflowLayout:(KMVerticalFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth{
    return itemWidth;
}

/**
 * 列间距
 */
-(CGFloat)km_waterflowLayout:(KMVerticalFlowLayout *)waterflowLayout columnsMarginInCollectionView:(UICollectionView *)collectionView{
    return 20;
}

/**
 * 行间距, 默认10
 */
- (CGFloat)km_waterflowLayout:(KMVerticalFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView linesMarginForItemAtIndexPath:(NSIndexPath *)indexPath{
    return 10;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
