//
//  HHLinkageView.h
//  https://github.com/yuwind/HHLinkageViewController
//
//  Created by 豫风 on 16/10/23.
//  Copyright © 2016年 豫风. All rights reserved.
//

#import "HHLinkageView.h"
#import "UIView+HHLayout.h"

@interface TitleModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) CGFloat titleWidth;

@end
@implementation TitleModel
@end

typedef NS_ENUM(NSUInteger, HHLinkageDirection) {
    HHLinkageDirectionNone = 0,
    HHLinkageDirectionLeft,
    HHLinkageDirectionRight,
};

#define KSCROLLBUTTONTAG 19491
@interface HHLinkageView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray <TitleModel *>*modelsArray;
@property (nonatomic, strong) UIScrollView *observerScrollView;
@property (nonatomic, strong) NSMutableArray <UIButton *>*buttonsArray;
@property (nonatomic, assign) HHLinkageDirection linkageDirection;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) BOOL clickTopButton;
@property (nonatomic, assign) NSInteger nextIndex;
@property (nonatomic, copy) NSArray *normalColors;
@property (nonatomic, copy) NSArray *selectColors;

@end

@implementation HHLinkageView

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = _selectedColor;
    }
    return _lineView;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self configInitialInfo];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self configInitialInfo];
    }
    return self;
}
- (instancetype)init
{
    if (self = [super init]) {
        [self configInitialInfo];
    }
    return self;
}
- (void)configInitialInfo
{
    self.isShowGradient = YES;
    self.isShowIndicator = YES;
    self.selectedColor = KSELECTEDCOLOR;
    self.normalColor = KNORMALCOLOR;
    self.fontSize = KTITLEFONT;
    self.buttonsArray = [NSMutableArray array];
    self.modelsArray = [NSMutableArray array];
    self.backgroundColor = [UIColor whiteColor];
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.scrollsToTop = NO;
    [self addSubview:_scrollView];
}

- (void)layoutSubviews
{
    _scrollView.frame = self.bounds;
    CGFloat totleWidth = 0;
    CGFloat buttonMargin = 0;
    CGFloat xPosion = 0;
    for (TitleModel *model in self.modelsArray) {
        totleWidth += model.titleWidth;
    }
    if (totleWidth<self.width) {
        buttonMargin = (self.width - totleWidth)/(self.modelsArray.count+1);
    }
    CGFloat splitHeight = [@"占位" sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:self.fontSize]}].height;
    xPosion += buttonMargin;
    for (int i = 0; i<self.modelsArray.count; i++) {
        TitleModel *model = self.modelsArray[i];
        UIButton *button = self.buttonsArray[i];
        button.frame = CGRectMake(xPosion, 0, model.titleWidth, self.height);
        button.centerY = self.height/2+KTITLEOFFSET;
        if (self.isShowSplit && i != (self.modelsArray.count-1)) {
            UIView *split = [UIView new];
            [self.scrollView addSubview:split];
            split.backgroundColor = [UIColor lightGrayColor];
            split.size = CGSizeMake(0.5, splitHeight);
            split.centerY = self.height/2+KTITLEOFFSET;
            split.x = button.maxX + buttonMargin/2;
        }
        xPosion += model.titleWidth + buttonMargin;
        if (i == self.currentIndex) {
            self.lineView.size = CGSizeMake(model.titleWidth-2*KTITLEMARGIN, KLINEHEIGHT);
            self.lineView.center = CGPointMake(button.centerX, self.height-KLINEHEIGHT/2);
        }
    }
    if (totleWidth<self.width) {
        self.scrollView.contentSize = self.bounds.size;
    }else{
        self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(self.buttonsArray.lastObject.frame), self.height);
    }
    [self.scrollView bringSubviewToFront:self.lineView];
    self.scrollView.contentOffset = CGPointZero;
}
- (void)setNormalColor:(UIColor *)normalColor
{
    _normalColor = normalColor;
    self.normalColors = nil;
    if (self.buttonsArray.count) {
        for (UIButton *button in self.buttonsArray) {
            if (button != self.selectedButton) {
                [button setTitleColor:normalColor forState:UIControlStateNormal];
            }
        }
    }
}
- (void)setFontSize:(CGFloat)fontSize
{
    _fontSize = fontSize;
    if (self.buttonsArray.count) {
        for (UIButton *button in self.buttonsArray) {
            button.titleLabel.font = [UIFont systemFontOfSize:self.fontSize];
        }
    }
}
- (void)setSelectedColor:(UIColor *)selectedColor
{
    _selectedColor = selectedColor;
    self.selectColors = nil;
    self.lineView.backgroundColor = selectedColor;
    if (self.selectedButton) {
        [self.selectedButton setTitleColor:selectedColor forState:UIControlStateNormal];
    }
}
- (void)setIsShowIndicator:(BOOL)isShowIndicator
{
    _isShowIndicator = isShowIndicator;
    self.lineView.hidden = !isShowIndicator;
}
- (void)setTitleArray:(NSArray *)titleArray
{
    _titleArray = titleArray;
    [self configTitleModelInfo];
    [self configScrollViewTitles];
}
- (void)configTitleModelInfo
{
    NSDictionary *fontDict = @{NSFontAttributeName : [UIFont systemFontOfSize:self.fontSize]};
    [self.modelsArray removeAllObjects];
    for (NSString *title in self.titleArray) {
        TitleModel *model = [TitleModel new];
        model.title = title;
        model.titleWidth = [title sizeWithAttributes:fontDict].width+2*KTITLEMARGIN;
        [self.modelsArray addObject:model];
    }
}
- (void)configScrollViewTitles
{
    if (_buttonsArray.count){
        [_buttonsArray removeAllObjects];
        [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    for (int i = 0; i < _titleArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:self.fontSize];
        button.tag = KSCROLLBUTTONTAG + i;
        [button setTitle:_titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:_normalColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(topButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            [button setTitleColor:_selectedColor forState:UIControlStateNormal];
            self.selectedButton = button;
            [self.scrollView addSubview:self.lineView];
        }
        [self.scrollView addSubview:button];
        [self.buttonsArray addObject:button];
    }
}
- (void)topButtonClickAction:(UIButton *)button
{
    if ([self.selectedButton isEqual:button]) return;
    [button setTitleColor:_selectedColor forState:UIControlStateNormal];
    [self.selectedButton setTitleColor:_normalColor forState:UIControlStateNormal];;
    self.clickTopButton = YES;
    self.selectedButton = button;
    self.scrollView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.lineView.size = CGSizeMake(button.width-2*KTITLEMARGIN, KLINEHEIGHT);
        self.lineView.center = CGPointMake(button.centerX, self.height-KLINEHEIGHT/2);
    }completion:^(BOOL finished) {
        self.clickTopButton = NO;
        self.scrollView.userInteractionEnabled = YES;
    }];
    [self scrollToCenter:button];
    [self invokeEventWithIndex:button.tag - KSCROLLBUTTONTAG];
    _currentIndex = _nextIndex = button.tag - KSCROLLBUTTONTAG;
}
- (void)invokeEventWithIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(linkageViewClick:index:)]) {
        [self.delegate linkageViewClick:self index:index];
    }
}
- (void)scrollToCenter:(UIButton *)button
{
    if (self.scrollView.contentSize.width > self.scrollView.frame.size.width){
        CGFloat leftOffset  = CGRectGetMidX(button.frame) - CGRectGetWidth(self.bounds) / 2;
        CGFloat rightOffset = CGRectGetWidth(self.bounds) / 2 + CGRectGetMidX(button.frame) - self.scrollView.contentSize.width;
        if (leftOffset >= 0 && rightOffset <= 0){
            [self.scrollView setContentOffset:CGPointMake(leftOffset, 0) animated:YES];
        }else{
            [self.scrollView setContentOffset:CGPointMake((leftOffset >= 0 ?: 0), 0) animated:YES];
            [self.scrollView setContentOffset:CGPointMake((rightOffset <= 0 ?: self.scrollView.contentSize.width - CGRectGetWidth(self.bounds)), 0) animated:YES];
        }
    }
}

- (void)observedScrollView:(UIScrollView *)scrollView
{
    if (!scrollView)return;
    self.observerScrollView = scrollView;
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(scrollView)];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (_clickTopButton) return;
    UIScrollView *scrollView = (__bridge UIScrollView *)(context);
    CGPoint translation = [scrollView.panGestureRecognizer translationInView:nil];
    CGFloat offSetX = scrollView.contentOffset.x;
    CGFloat temp = offSetX / self.bounds.size.width;
    if (translation.x<0) {//向左滑动
        self.linkageDirection = HHLinkageDirectionLeft;
    }else if (translation.x>0){//向右滑动
        self.linkageDirection = HHLinkageDirectionRight;
    }
    if (self.linkageDirection == HHLinkageDirectionLeft) {//向左滑
        _currentIndex = floor(temp);
        _nextIndex = _currentIndex + 1;
        if (_nextIndex >= self.buttonsArray.count) {
            _nextIndex = _currentIndex;
            UIButton *preButton = self.buttonsArray[_currentIndex-1];
            [preButton setTitleColor:self.normalColor forState:UIControlStateNormal];
            UIButton *currentButton = self.buttonsArray[_currentIndex];
            [currentButton setTitleColor:self.selectedColor forState:UIControlStateNormal];
            self.lineView.centerX = currentButton.centerX;
            return;
        }
        if (_currentIndex >0) {
            UIButton *preButton = self.buttonsArray[_currentIndex-1];
            [preButton setTitleColor:self.normalColor forState:UIControlStateNormal];
        }
    }else{//向右滑
        _currentIndex = ceil(temp);
        if (_currentIndex <= 0) {
            UIButton *preButton = self.buttonsArray[_currentIndex+1];
            [preButton setTitleColor:self.normalColor forState:UIControlStateNormal];
            UIButton *currentButton = self.buttonsArray[_currentIndex];
            [currentButton setTitleColor:self.selectedColor forState:UIControlStateNormal];
            self.lineView.centerX = currentButton.centerX;
            return;
        }
        if (_currentIndex+2 <= self.buttonsArray.count) {
            UIButton *preButton = self.buttonsArray[_currentIndex+1];
            [preButton setTitleColor:self.normalColor forState:UIControlStateNormal];
        }
        _nextIndex = _currentIndex - 1;
    }
    [self adjustTitleProgress:fabs(temp - _currentIndex) nextIndex:_nextIndex currentIndex:_currentIndex];
}

- (void)adjustTitleProgress:(CGFloat)progress nextIndex:(NSInteger)nextIndex currentIndex:(NSInteger)currentIndex{
    
    UIButton *currenButton = self.buttonsArray[currentIndex];
    UIButton *nextButton = self.buttonsArray[nextIndex];
    CGFloat xDistance = nextButton.x - currenButton.x;
    CGFloat wDistance = nextButton.width - currenButton.width;
    
    if (self.lineView) {
        self.lineView.x = currenButton.x+KTITLEMARGIN + xDistance * progress;
        self.lineView.width = currenButton.width-2*KTITLEMARGIN + wDistance * progress;
    }
    if (self.isShowGradient) {
        [currenButton setTitleColor:[self normalColorWithProgress:progress] forState:UIControlStateNormal];
        [nextButton setTitleColor:[self selectColorWithProgress:progress] forState:UIControlStateNormal];
        if (self.lineView.centerX<currenButton.x || self.lineView.centerX>currenButton.maxX) {
            self.selectedButton = nextButton;
            [self scrollToCenter:nextButton];
            self.currentIndex = nextIndex;
        }else{
            self.selectedButton = currenButton;
        }
    }else{
        if (self.lineView.centerX<currenButton.x || self.lineView.centerX>currenButton.maxX) {
            [currenButton setTitleColor:_normalColor forState:UIControlStateNormal];
            [nextButton setTitleColor:_selectedColor forState:UIControlStateNormal];
            self.selectedButton = nextButton;
            [self scrollToCenter:nextButton];
            self.currentIndex = nextIndex;
        }else{
            [currenButton setTitleColor:_selectedColor forState:UIControlStateNormal];
            [nextButton setTitleColor:_normalColor forState:UIControlStateNormal];
            self.selectedButton = currenButton;
        }
    }
}

- (UIColor *)normalColorWithProgress:(CGFloat)rate//选中到正常
{
    return [UIColor colorWithRed:[self.selectColors[0] floatValue]+([self.normalColors[0] floatValue]-[self.selectColors[0] floatValue])*rate green:[self.selectColors[1] floatValue]+([self.normalColors[1] floatValue]-[self.selectColors[1] floatValue])*rate blue: [self.selectColors[2] floatValue]+([self.normalColors[2] floatValue]-[self.selectColors[2] floatValue])*rate alpha:[self.selectColors[3] floatValue]+([self.normalColors[3] floatValue]-[self.selectColors[3] floatValue])*rate];
}
- (UIColor *)selectColorWithProgress:(CGFloat)rate//正常到选中
{
    return [UIColor colorWithRed:[self.normalColors[0] floatValue]+([self.selectColors[0] floatValue]-[self.normalColors[0] floatValue])*rate green:[self.normalColors[1] floatValue]+([self.selectColors[1] floatValue]-[self.normalColors[1] floatValue])*rate blue: [self.normalColors[2] floatValue]+([self.selectColors[2] floatValue]-[self.normalColors[2] floatValue])*rate alpha:[self.normalColors[3] floatValue]+([self.selectColors[3] floatValue]-[self.normalColors[3] floatValue])*rate];
}
- (NSArray *)normalColors
{
    if (!_normalColors) {
        NSInteger normalNumber = CGColorGetNumberOfComponents(self.normalColor.CGColor);
        if (normalNumber == 2) {
            const CGFloat *components = CGColorGetComponents(self.normalColor.CGColor);
            _normalColors = [NSArray arrayWithObjects:@(components[0]), @(components[0]), @(components[0]), @(components[1]), nil];
        }else if (normalNumber == 4){
            const CGFloat *components = CGColorGetComponents(self.normalColor.CGColor);
            _normalColors = [NSArray arrayWithObjects:@(components[0]), @(components[1]), @(components[2]), @(components[3]), nil];
        }
    }
    return _normalColors;
}
- (NSArray *)selectColors
{
    if (!_selectColors) {
        NSInteger selectNumber = CGColorGetNumberOfComponents(self.selectedColor.CGColor);
        if (selectNumber == 2) {
            const CGFloat *components = CGColorGetComponents(self.selectedColor.CGColor);
            _selectColors = [NSArray arrayWithObjects:@(components[0]), @(components[0]), @(components[0]), @(components[1]), nil];
        }else if (selectNumber == 4){
            const CGFloat *components = CGColorGetComponents(self.selectedColor.CGColor);
            _selectColors = [NSArray arrayWithObjects:@(components[0]), @(components[1]), @(components[2]), @(components[3]), nil];
        }
    }
    return _selectColors;
}

-(void)dealloc
{
    !self.observerScrollView?:[self.observerScrollView removeObserver:self forKeyPath:@"contentOffset"];
}


@end
