



##collectionView嵌套tableView实现悬停交互

###效果图
![linkageVIew1.gif](https://upload-images.jianshu.io/upload_images/1801563-3740cfc0ed1d2f37.gif?imageMogr2/auto-orient/strip)

###使用方法
>1、子类需要继承`HHLinkageViewController`
>2、设置常用属性，中间titles高度为宏定义`LINKAGEVIEWH`

```objc
@property (nonatomic, copy) NSArray <UIViewController *>*viewControllers;//子控制器
@property (nonatomic, strong, readonly) HHLinkageView *linkageView;//只读中间标题视图
@property (nonatomic, strong) UIView *headerView;//自定义头部试图,可以只设置高度
@property (nonatomic, copy) NSArray *titlesArray;//中间标题
@property (nonatomic, assign) BOOL isNeedLessMove;//数据少于屏幕是否需要滑动，默认YES
```
>3子控制器`scrollViewDidScroll`中分别调用父控制器如下方法

```objc
/**
 @param scrollView 子控制器tableView
 @param index 子控制器所在的索引值
 */
- (void)childScrollViewDidScroll:(UIScrollView *)scrollView index:(NSInteger)index;

```

###基本讲解
   > 我们知道`frame`是相对于父控件的位置，`bounds`是相对于自己的位置，可以用来改变子视图的位置，我的出发点就是通过改变tableView的bounds实现的，核心代码也就50行左右。
   
我们的目的是tableView上下滑动的时候，改变collectionView的y值，同时tableView的contentOffset不变。

**1、** 我们需要先判断滑动方向，调用如下方法

```objc
    CGPoint velocity = [scrollView.panGestureRecognizer velocityInView:nil];
```
同时引入中间变量`_direction`，因为当手指离开屏幕时`velocity`会变为0，我们需要保留离开屏幕时的方向。

**2、** 我们先考虑向上滑动的情况，箭头为滑动方向

>情景一不包含偏移量，如下图

![情景一.png](https://upload-images.jianshu.io/upload_images/1801563-bad701df5368a8cd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

我们只需要把`collectionView`的`y`减去滑动的`offset`，同时把`scrollView`的`bounds`的`y`设置为0，这样`collectionView`就可以滑动了，而`scrollView`却不变

```objc
 _collectionView.y -= offsetY;
 CGRect tempFrame = scrollView.bounds;
 tempFrame.origin.y = 0;
 scrollView.bounds = tempFrame;
```

>情景二包含偏移量，如下图

![情景二.png](https://upload-images.jianshu.io/upload_images/1801563-1d9f9cfdcacb529f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

我们需要引入一个变量`offsetArray`，用来保存上一次滑动之后的偏移量，在赋值的时候减去详细的偏移量。需要注意的是改变`scrollView.bounds`的`y`的时候，不能直接赋值为上次的保留值`conserverOffset`，需要向上偏移一点，这样在快速滑动松手的时候，才会有惯性。
    
```objc
CGFloat conserverOffset = _offsetArray[index].floatValue;
if (conserverOffset) {
    _collectionView.y -= (offsetY-conserverOffset);
    CGRect tempFrame = scrollView.bounds;
    tempFrame.origin.y = conserverOffset+0.3;//0.3是为了保留惯性
    scrollView.bounds = tempFrame;
}
```
**3、** 方向向下和向上的差不多，具体看下代码吧

最后统一处理边界值就可以了，是不是特别简单。

```objc
    if (_collectionView.y>=_headerView.height+LINKAGEVIEWH) {
        _collectionView.y = _headerView.height+LINKAGEVIEWH;
        _linkageView.y = _headerView.height;
    }else if (_collectionView.y<=LINKAGEVIEWH){
        _collectionView.y = LINKAGEVIEWH;
        _linkageView.y = 0;
    }else{
        _linkageView.y = _collectionView.y-LINKAGEVIEWH;
    }
```

**4、** cocoapod下载

```objc
target 'MyApp' do
  pod 'HHLinkageViewController', '~> 1.0.0'
end
```

#####[简书地址](https://github.com/yuwind/HHLinkageViewController)


