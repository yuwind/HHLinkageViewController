//
//  CommonTableViewController.m
//  HHLinkageViewController
//
//  Created by 豫风 on 2018/10/30.
//  Copyright © 2018年 豫风. All rights reserved.
//

#import "HHTableViewController.h"
#import "HHLinkageViewController.h"

@interface HHTableViewController ()

@property (nonatomic, assign) NSInteger index;

@end

@implementation HHTableViewController

+ (instancetype)instanceWithIndex:(NSInteger)index
{
    HHTableViewController *testVC = [self new];
    testVC.index = index;
    return testVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"UITableViewCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld个cell",(long)indexPath.row];
    return cell;
}

/**
 子控制器需要调用父控制器的`childScrollViewDidScroll`方法
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [(HHLinkageViewController *)self.parentViewController childScrollViewDidScroll:self.tableView index:self.index];
}

@end
