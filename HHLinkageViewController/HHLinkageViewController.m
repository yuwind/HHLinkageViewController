//
//  HHLinkageViewController.m
//  https://github.com/yuwind/HHLinkageViewController
//
//  Created by 豫风 on 2018/10/30.
//  Copyright © 2018年 豫风. All rights reserved.
//

#import "HHLinkageViewController.h"
#import "UIView+HHLayout.h"

typedef NS_ENUM(NSUInteger, HHScrollDirection) {
    HHScrollDirectionNone = 0,
    HHScrollDirectionUp,
    HHScrollDirectionDown,
};

#define KSCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define KSCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define KISiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define KNAVBARHEIGHT (KISiPhoneX ? 88.f : 64.f)
#define KINDICATORHEIGHT (KISiPhoneX ? 34.f : 0.f)

@interface HHLinkageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,HHLinkageViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionLayout;
@property (nonatomic, strong) NSMutableArray <NSNumber *>*offsetArray;
@property (nonatomic, assign) HHScrollDirection direction;

@end

@implementation HHLinkageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configInitialInfo];
}

- (void)setHeaderView:(UIView *)headerView
{
    !_headerView?:[_headerView removeFromSuperview];
    _headerView = headerView;
    [self.view addSubview:_headerView];
    [self.view sendSubviewToBack:_headerView];
    !_titlesArray.count?:[self needToLayoutSubviews];
}
- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers
{
    _viewControllers = viewControllers;
    _offsetArray  = [NSMutableArray array];
    for (int i = 0; i<self.viewControllers.count; i++) {
        self.offsetArray[i] = [NSNumber numberWithFloat:0.0f];
        [self addChildViewController:self.viewControllers[i]];
    }
    !_titlesArray.count?:[self needToLayoutSubviews];
}
- (void)setTitlesArray:(NSArray *)titlesArray
{
    _titlesArray = titlesArray;
    _linkageView?_linkageView.titleArray = self.titlesArray:nil;
    [self needToLayoutSubviews];
}

- (void)needToLayoutSubviews
{
    if (_headerView) {
        _headerView.frame = CGRectMake(0, 0, KSCREENWIDTH, _headerView.height);
        _linkageView.frame = CGRectMake(0, _headerView.maxY, KSCREENWIDTH, LINKAGEVIEWH);
    }else{
        _linkageView.frame = CGRectMake(0, 0, KSCREENWIDTH, LINKAGEVIEWH);
    }
    _collectionLayout.itemSize = CGSizeMake(KSCREENWIDTH, KSCREENHEIGHT-LINKAGEVIEWH-KNAVBARHEIGHT-KINDICATORHEIGHT);
    _collectionView.frame = CGRectMake(0, _linkageView.maxY, self.view.width, KSCREENHEIGHT-LINKAGEVIEWH-KNAVBARHEIGHT-KINDICATORHEIGHT);
}

- (void)configInitialInfo
{
    self.view.backgroundColor = [UIColor whiteColor];
    _isNeedLessMove = YES;
    _linkageView = [[HHLinkageView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_linkageView];
    _linkageView.selectedColor = [UIColor redColor];
    _linkageView.normalColor = [UIColor lightGrayColor];
    _linkageView.delegate = self;
    _linkageView.isShowSplit = YES;
    _linkageView.backgroundColor = [UIColor colorWithRed:204/255.0 green:225/255.0 blue:152/255.0 alpha:1.0f];
    
    _collectionLayout = [[UICollectionViewFlowLayout alloc]init];
    _collectionLayout.itemSize = CGSizeMake(100, 100);
    _collectionLayout.minimumInteritemSpacing = 0;
    _collectionLayout.minimumLineSpacing = 0;
    _collectionLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:_collectionLayout];
    [self.view addSubview:_collectionView];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.collectionViewLayout = _collectionLayout;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    _collectionView.pagingEnabled = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.bounces = NO;
    
    self.titlesArray.count?_linkageView.titleArray = self.titlesArray:nil;
    [_linkageView observedScrollView:_collectionView];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewControllers.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    [collectionCell.contentView addSubview:self.viewControllers[indexPath.row].view];
    self.viewControllers[indexPath.row].view.frame = collectionCell.contentView.bounds;
    return collectionCell;
}
- (void)linkageViewClick:(HHLinkageView *)view index:(NSInteger)index
{
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (void)childScrollViewDidScroll:(UIScrollView *)scrollView index:(NSInteger)index
{
    if (!_headerView)return;
    if (@available(iOS 11,*)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    CGPoint velocity = [scrollView.panGestureRecognizer velocityInView:nil];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (velocity.y > 0){
        _direction = HHScrollDirectionDown;
    }else if (velocity.y < 0){
        _direction = HHScrollDirectionUp;
    }
    if (offsetY>0){
        if (_collectionView.y>LINKAGEVIEWH) {//向上
            if (_direction == HHScrollDirectionUp) {
                if (!self.isNeedLessMove&&scrollView.contentSize.height<=KSCREENHEIGHT-self.linkageView.maxY-KINDICATORHEIGHT-KNAVBARHEIGHT) {
                    return;
                }
                CGFloat conserverOffset = _offsetArray[index].floatValue;
                if (conserverOffset) {
                    _collectionView.y -= (offsetY-conserverOffset);
                    CGRect tempFrame = scrollView.bounds;
                    tempFrame.origin.y = conserverOffset+0.3;
                    scrollView.bounds = tempFrame;
                }else{
                    _collectionView.y -= offsetY;
                    CGRect tempFrame = scrollView.bounds;
                    tempFrame.origin.y = 0;
                    scrollView.bounds = tempFrame;
                }
            }else if (_direction == HHScrollDirectionDown){
                _offsetArray[index] = [NSNumber numberWithFloat:offsetY<0?0:offsetY];
            }
        }else{
            _collectionView.y = LINKAGEVIEWH;
            _offsetArray[index] = [NSNumber numberWithFloat:offsetY<0?0:offsetY];
        }
    }else{
        if (_collectionView.y<_headerView.height+LINKAGEVIEWH) {
            _collectionView.y += -offsetY;
            CGRect tempFrame = scrollView.bounds;
            tempFrame.origin.y = -0.3;
            scrollView.bounds = tempFrame;
            _offsetArray[index] = [NSNumber numberWithFloat:0];
        }else{
            _collectionView.y = _headerView.height+LINKAGEVIEWH;
        }
    }
    if (_collectionView.y>=_headerView.height+LINKAGEVIEWH) {
        _collectionView.y = _headerView.height+LINKAGEVIEWH;
        _linkageView.y = _headerView.height;
    }else if (_collectionView.y<=LINKAGEVIEWH){
        _collectionView.y = LINKAGEVIEWH;
        _linkageView.y = 0;
    }else{
        _linkageView.y = _collectionView.y-LINKAGEVIEWH;
    }
    if (self.isNeedHeaderScroll) {
        _headerView.maxY = _linkageView.y;
    }
}

@end
