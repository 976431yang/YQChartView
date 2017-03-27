//
//  YQChartBarView.h
//  YQChartViewDEMO
//
//  Created by problemchild on 2017/3/23.
//  Copyright © 2017年 ProblenChild. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YQChartBarView : UIView


/**
 *  刷新显示,更改设置以后，请调用此方法刷新显示
 */
-(void)loadAndShow;

//X轴上要显示的内容。请在数组中包含NSString格式。此数组会决定显示的数据数量。
@property(nonatomic,strong)NSArray<NSString *> *XLables;

/**
 *  传入一组数据，并设置颜色。请在数组中包含NSNumber类型。
 *
 *  @param data  数据数组，请在数组中包含NSNumber类型
 *  @param color 此组数据要显示出来的颜色。
 */
-(void)addDataGroup:(NSArray<NSNumber *> *)data forColor:(UIColor *)color;

/**
 *  清除数据
 */
-(void)clearData;


#pragma -mark ---------------------------------X、Y轴相关

//X轴显示Lable的字体(字体会在空间不够的时候自动减小字体大小)
@property(nonatomic,strong)UIFont *XLableFont;

//Y轴需要显示多少个基准值
@property int YLabelsCount;

//Y轴左侧显示基准值的宽度
@property float YLabelWidth;

//Y轴显示Lable的字体(字体会在空间不够的时候自动减小字体大小)
@property(nonatomic,strong)UIFont *YLableFont;

//显示X轴
@property BOOL showXAxis;
//显示Y轴
@property BOOL showYAxis;

//显示动画
@property BOOL animation;


#pragma -mark ---------------------------------间隔与宽度

//每段数据中 来自不同小组 的内部间隔
@property CGFloat GroupInterval;

//每段数据的间隔
@property CGFloat DataInterval;

//初始bar宽度（每条数据的宽度）
@property CGFloat barWidth;

//bar的圆角
@property CGFloat barCornerWidth;

#pragma -mark ---------------------------------缩放参数
//允许缩放
//默认打开
@property BOOL allowPinch;

//最小bar宽度
@property CGFloat minBarWidth;
//最大bar宽度
@property CGFloat maxBarWidth;

#pragma -mark ---------------------------------柱子顶部的数字
//在条形图每个柱子上方显示具体数字
@property BOOL showTopNumberUpTheBar;
//在条形图每个柱子顶部下方显示具体数字
@property BOOL showTopNumberDownTheBar;
//顶部数字的颜色
@property(nonatomic,strong)UIColor *TopNumberColor;


@end
