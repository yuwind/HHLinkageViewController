//
//  HHLinkageViewController.h
//  https://github.com/yuwind/HHLinkageViewController
//
//  Created by 豫风 on 2018/10/30.
//  Copyright © 2018年 豫风. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHLinkageView.h"

#define LINKAGEVIEWH 44      //default linkageView height

@interface HHLinkageViewController : UIViewController

@property (nonatomic, copy) NSArray <UIViewController *>*viewControllers;//子控制器
@property (nonatomic, strong, readonly) HHLinkageView *linkageView;//只读中间标题视图
@property (nonatomic, strong) UIView *headerView;//自定义头部试图,可以只设置高度
@property (nonatomic, copy) NSArray *titlesArray;//中间标题
@property (nonatomic, assign) BOOL isNeedLessMove;//数据少于屏幕是否需要滑动，默认YES

/**
 需要在子控制器中分别调用

 @param scrollView 子控制器tableView
 @param index 子控制器所在的索引值
 */
- (void)childScrollViewDidScroll:(UIScrollView *)scrollView index:(NSInteger)index;

@end

