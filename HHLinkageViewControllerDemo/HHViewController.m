//
//  ViewController.m
//  HHLinkageViewController
//
//  Created by 豫风 on 2018/10/30.
//  Copyright © 2018年 豫风. All rights reserved.
//

#import "HHViewController.h"
#import "HHLinkageViewController.h"
#import "HHTableViewController.h"
#import "UIView+HHLayout.h"

@interface HHViewController ()

@end

@implementation HHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"首页";
    
    self.viewControllers = @[[HHTableViewController instanceWithIndex:0],[HHTableViewController instanceWithIndex:1],[HHTableViewController instanceWithIndex:2],[HHTableViewController instanceWithIndex:3],[HHTableViewController instanceWithIndex:4],[HHTableViewController instanceWithIndex:5],[HHTableViewController instanceWithIndex:6],[HHTableViewController instanceWithIndex:7],];
    self.titlesArray = @[@"我是第0个",@"1个",@"我是第2个",@"我是第3个",@"我是第4个",@"5个",@"我是第6个",@"我是第7个"];

    self.headerView = [self configHeaderView];
}

- (UIView *)configHeaderView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 150)];
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:@"pic.jpg"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [button addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:button];
    button.cent_.constList(@0,@(-10),nil).on_();
    return imageView;
}

- (void)buttonDidClicked:(UIButton *)sender
{
    UILabel *label = [UILabel new];
    label.text = @"最怕你一生碌碌无为，还安慰自己平凡可贵！";
    label.textColor = [UIColor whiteColor];
    [self.headerView addSubview:label];
    label.cent_.constList(@0,@15,nil).on_();
    label.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        label.alpha = 1;
    }completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                label.alpha = 0;
            }completion:^(BOOL finished) {
                [label removeFromSuperview];
            }];
        });
    }];
}

@end
