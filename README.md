# YQChartView
#### 微博：畸形滴小男孩

###iOS数据条形图，支持：动画、缩放、正负数等，并可高度自定义化。

##### （目前已完成数据条形图（YQChartBarView）,折线图敬请期待）

## 效果预览：

#### 单组数据+开启动画
![image](https://github.com/976431yang/YQChartView/blob/master/YQChartViewDEMO/截图视频gif/单组数据有动画.gif) 

#### 多组数据+正负数+动画
![image](https://github.com/976431yang/YQChartView/blob/master/YQChartViewDEMO/截图视频gif/多组数据%26有正负数.gif) 

#### 缩放（直接双指缩放）
![image](https://github.com/976431yang/YQChartView/blob/master/YQChartViewDEMO/截图视频gif/缩放.gif) 

#### 关闭动画
![image](https://github.com/976431yang/YQChartView/blob/master/YQChartViewDEMO/截图视频gif/关闭动画.gif) 

#### 设置Y轴显示数量
![image](https://github.com/976431yang/YQChartView/blob/master/YQChartViewDEMO/截图视频gif/Y轴显示数量.gif) 

#### Y轴左侧距离，X轴初始字体大小，Y轴初始字体大小
##### （注：字体大小会在空间不够的时候，自动调整）
![image](https://github.com/976431yang/YQChartView/blob/master/YQChartViewDEMO/截图视频gif/其他设置.gif) 

#### 可下载DEMO查看更多效果
![image](https://github.com/976431yang/YQChartView/blob/master/YQChartViewDEMO/截图视频gif/DEMO截图.jpg)


## 如何使用：

#### 导入、引入文件
```objective-c
#import "YQChartBarView.h"
```

#### 生成一个视图，并添加，会自动使用默认设置
```objective-c
	YQChartBarView *BarView = [[YQChartBarView alloc]initWithFrame:CGRectMake(0,0,300,200)];
	[self.view addSubview:BarView];

```

#### 传入X轴坐标组，（NSString，此数组的个数会决定最终显示的数据的数量）
```objective-c
    NSArray<NSString *> *XLableTexts = [self demoXLableTexts];
    BarView.XLables = XLableTexts;
```

#### 传入一组要显示的数据（纵向显示的值），并为此组数据指定一个颜色
##### 这里可以传入多组数据，建议不要超过4组
```objective-c
    NSArray<NSNumber *> *firstValues = [self demoValues];
    [BarView addDataGroup:firstValues forColor:[UIColor redColor]];
```

#### 加载并显示,更改设置、加载数据后，请调用此方法生效显示
```objective-c
    [BarView loadAndShow];
```

#### 自定义参数、设置
```objective-c
    #pragma -mark ---------------------------------X、Y轴相关

	//X轴显示Lable的字体(字体会在空间不够的时候自动减小字体大小)
	BarView.XLableFont = (UIFont*)....;

	//Y轴需要显示多少个基准值
	BarView.YLabelsCount = (int)....;

	//Y轴左侧显示基准值的宽度
	BarView.YLabelWidth = (CGFloat)....;

	//Y轴显示Lable的字体(字体会在空间不够的时候自动减小字体大小)
	BarView.YLableFont = (UIFont*)....;

	//显示X轴
	BarView.showXAxis = YES/NO;
	//显示Y轴
	BarView.showYAxis = YES/NO;

	//显示动画
	BarView.animation = YES/NO;


	#pragma -mark ---------------------------------间隔与宽度

	//每段数据中 来自不同小组 的内部间隔,（不同颜色之间）
	BarView.GroupInterval = (CGFloat)....;

	//每段数据的间隔
	BarView.DataInterval = (CGFloat)....;

	//初始bar宽度（每条数据的宽度）
	BarView.barWidth = (CGFloat)....;

	//bar的圆角
	BarView.barCornerWidth = (CGFloat)....;

	#pragma -mark ---------------------------------缩放参数
	//允许缩放
	//默认打开
	BarView.allowPinch = YES/NO;

	//最小bar宽度
	BarView.minBarWidth = (CGFloat)....;
	//最大bar宽度
	BarView.maxBarWidth = (CGFloat)....;

	#pragma -mark ---------------------------------柱子顶部的数字
	//在条形图每个柱子上方显示具体数字
	BarView.showTopNumberUpTheBar = YES/NO;
	//在条形图每个柱子顶部下方显示具体数字
	BarView.showTopNumberDownTheBar = YES/NO;
	//顶部数字的颜色
	BarView.TopNumberColor = (UIColor*)....;

```

#### 清除所有数据
```objective-c
    [BarView clearData];
```
