//
//  HHLinkageView.h
//  https://github.com/yuwind/HHLinkageViewController
//
//  Created by 豫风 on 16/10/23.
//  Copyright © 2016年 豫风. All rights reserved.
//

#import <UIKit/UIKit.h>

// --> MARK: 统一配置
#define KNORMALCOLOR    [UIColor lightGrayColor]  // 默认灰色
#define KSELECTEDCOLOR  [UIColor redColor]       // 选中默认红色
#define KTITLEOFFSET    0  //中心偏移量 默认居中
#define KTITLEMARGIN    10 //标题内间距 默认10
#define KTITLEFONT      14 //字体大小 默认14
#define KLINEHEIGHT     2  //指示器高度 默认2

@class HHLinkageView;
@protocol HHLinkageViewDelegate <NSObject>

- (void)linkageViewClick:(HHLinkageView *)view index:(NSInteger)index;

@end

@interface HHLinkageView : UIView

@property (nonatomic, weak)   id<HHLinkageViewDelegate>delegate;
@property (nonatomic, strong) NSArray <NSString *>*titleArray;//标题数组
@property (nonatomic, assign) CGFloat fontSize;//默认 14
@property (nonatomic, strong) UIColor *normalColor;//默认灰色
@property (nonatomic, strong) UIColor *selectedColor;//默认红色
@property (nonatomic, assign) NSInteger currentIndex;//当前索引
@property (nonatomic, assign) BOOL isShowIndicator;//默认 YES
@property (nonatomic, assign) BOOL isShowGradient;//默认 YES
@property (nonatomic, assign) BOOL isShowSplit;//分割线 默认 NO

/**
 KVO监听scrollView的滚动

 @param scrollView 被监听的对象
 */
- (void)observedScrollView:(UIScrollView *)scrollView;

@end
