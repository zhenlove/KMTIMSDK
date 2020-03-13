//
//  ZJVerticalFlowLayout.m
//  ZJUIKit
//
//  Created by dzj on 2018/1/30.
//  Copyright © 2018年 kapokcloud. All rights reserved.
//

#import "KMVerticalFlowLayout.h"
#define ZJXX(x) floorf(x)
#define ZJXS(s) ceilf(s)

static const NSInteger KM_Columns_ = 3;
static const CGFloat KM_XMargin_ = 26;
static const CGFloat KM_YMargin_ = 26;
static const UIEdgeInsets KM_EdgeInsets_ = {20, 20, 10, 20};

/**
 *  ZJUIKitTool
 *
 *  GitHub地址：https://github.com/Dzhijian/ZJUIKitTool
 *
 *  本库会不断更新工具类，以及添加一些模块案例，请各位大神们多多指教，支持一下,给个Star。😆
 */

@interface KMVerticalFlowLayout()
/** 所有的cell的attrbts */
@property (nonatomic, strong) NSMutableArray *km_AtrbsArray;

/** 每一列的最后的高度 */
@property (nonatomic, strong) NSMutableArray *km_ColumnsHeightArray;

- (NSInteger)columns;

- (CGFloat)xMargin;

- (CGFloat)yMarginAtIndexPath:(NSIndexPath *)indexPath;

- (UIEdgeInsets)edgeInsets;
@end

@implementation KMVerticalFlowLayout

/**
 *  刷新布局的时候回重新调用
 */
- (void)prepareLayout
{
    [super prepareLayout];
    
    //如果重新刷新就需要移除之前存储的高度
    [self.km_ColumnsHeightArray removeAllObjects];
    
    //复赋值以顶部的高度, 并且根据列数
    for (NSInteger i = 0; i < self.columns; i++) {
        
        [self.km_ColumnsHeightArray addObject:@(self.edgeInsets.top)];
    }
    
    // 移除以前计算的cells的attrbs
    [self.km_AtrbsArray removeAllObjects];
    
    // 并且重新计算, 每个cell对应的atrbs, 保存到数组
    for (NSInteger i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++)
    {
        [self.km_AtrbsArray addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]]];
    }
}

/**
 *在这里边所处每个cell对应的位置和大小
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *atrbs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat w = 1.0 * (self.collectionView.frame.size.width - self.edgeInsets.left - self.edgeInsets.right - self.xMargin * (self.columns - 1)) / self.columns;
    
    w = ZJXX(w);
    
    // 高度由外界决定, 外界必须实现这个方法
    CGFloat h = [self.delegate km_waterflowLayout:self collectionView:self.collectionView heightForItemAtIndexPath:indexPath itemWidth:w];
    
    // 拿到最后的高度最小的那一列, 假设第0列最小
    NSInteger indexCol = 0;
    CGFloat minColH = [self.km_ColumnsHeightArray[indexCol] doubleValue];
    
    for (NSInteger i = 1; i < self.km_ColumnsHeightArray.count; i++)
    {
        CGFloat colH = [self.km_ColumnsHeightArray[i] doubleValue];
        if(minColH > colH)
        {
            minColH = colH;
            indexCol = i;
        }
    }
    
    
    CGFloat x = self.edgeInsets.left + (self.xMargin + w) * indexCol;
    
    CGFloat y = minColH + [self yMarginAtIndexPath:indexPath];
    
    // 是第一行
    if (minColH == self.edgeInsets.top) {
        
        y = self.edgeInsets.top;
    }
    
    // 赋值frame
    atrbs.frame = CGRectMake(x, y, w, h);
    
    // 覆盖添加完后那一列;的最新高度
    self.km_ColumnsHeightArray[indexCol] = @(CGRectGetMaxY(atrbs.frame));
    
    return atrbs;
}


- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.km_AtrbsArray;
}

-(CGSize)collectionViewContentSize{
    
    CGFloat maxColH = [self.km_ColumnsHeightArray.firstObject doubleValue];
    
    for (NSInteger i = 1; i<self.km_ColumnsHeightArray.count; i++) {
        CGFloat colH = [self.km_ColumnsHeightArray[i] doubleValue];
        if (maxColH<colH) {
            maxColH = colH;
        }
    }
    return CGSizeMake(self.collectionView.frame.size.width, maxColH + self.edgeInsets.bottom);
}


-(NSInteger)columns{
    if ([self.delegate respondsToSelector:@selector(km_waterflowLayoutkm_waterflowLayout:columnsInCollectionView:)]) {
        return [self.delegate km_waterflowLayout:self columnsInCollectionView:self.collectionView];
    }else{
        return KM_Columns_;
    }
}

-(CGFloat)xMargin{
    if ([self.delegate respondsToSelector:@selector(km_waterflowLayoutkm_waterflowLayout:columnsMarginInCollectionView:)]) {
        return [self.delegate km_waterflowLayout:self columnsMarginInCollectionView:self.collectionView];
    }else{
        return KM_XMargin_;
    }
}

-(CGFloat)yMarginAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(km_waterflowLayoutkm_waterflowLayout:collectionView:linesMarginForItemAtIndexPath:)]) {
        return [self.delegate km_waterflowLayout:self collectionView:self.collectionView linesMarginForItemAtIndexPath:indexPath];
    }else{
        return KM_YMargin_;
    }
}

-(id<KMVerticalFlowLayoutDelegate>)delegate{
    
    return (id<KMVerticalFlowLayoutDelegate>)self.collectionView.dataSource;

}

- (UIEdgeInsets)edgeInsets
{
    if([self.delegate respondsToSelector:@selector(km_waterflowLayout:edgeInsetsInCollectionView:)])
    {
        return [self.delegate km_waterflowLayout:self edgeInsetsInCollectionView:self.collectionView];
    }
    else
    {
        return KM_EdgeInsets_;
    }
}


-(instancetype)initWithDelegate:(id<KMVerticalFlowLayoutDelegate>)delegate{
    if (self = [super init]) {
        
    }
    return self;
}

+(instancetype)flowLayoutWithDelegate:(id<KMVerticalFlowLayoutDelegate>)delegate{
    return [[self alloc]initWithDelegate:delegate];
}


-(NSMutableArray *)km_ColumnsHeightArray{
    if (!_km_ColumnsHeightArray) {
        _km_ColumnsHeightArray = [NSMutableArray array];
    }
    return _km_ColumnsHeightArray;
}

-(NSMutableArray *)km_AtrbsArray{
    if (!_km_AtrbsArray) {
        _km_AtrbsArray = [NSMutableArray array];
    }
    return _km_AtrbsArray;
}



@end
