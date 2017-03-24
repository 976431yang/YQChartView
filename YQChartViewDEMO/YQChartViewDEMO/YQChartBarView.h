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
 *  加载数据并显示,更改数据和设置以后，请调用此方法生效
 */
-(void)loadAndShow;


/**
 *  X轴上要显示的内容。请在数组中包含NSString格式。此数组会决定显示的数据数量。
 */
@property(nonatomic,strong)NSArray *XLables;


/**
 *  传入一组数据，并设置颜色。请在数组中包含NSNumber类型。
 *
 *  @param data  数据数组，请在数组中包含NSNumber类型
 *  @param color 此组数据要显示出来的颜色。
 */
-(void)addDataGroup:(NSArray *)data forColor:(UIColor *)color;


/**
 *  X轴显示Lable的字体(字体会在空间不够的时候自动减小字体大小)
 */
@property(nonatomic,strong)UIFont *XLableFont;

/**
 *  Y轴需要显示多少个基准值，初始值为4
 */
@property int yLabelsCount;


//每段数据中 来自不同小组 的内部间隔
@property CGFloat GroupInterval;

//每段数据的间隔
@property CGFloat DataInterval;



//初始bar宽度（每条数据的宽度）
@property CGFloat barWidth;

//允许缩放
//默认打开
@property BOOL allowPinch;

//最小bar宽度
@property CGFloat mixBarWidth;
//最大bar宽度
@property CGFloat maxBarWidth;


//根据可见区域，调整纵向显示比例
//默认关闭
//@property BOOL AutoAdjustHeightRaid;

//在条形图上方显示具体数字
@property BOOL showNumberUpTheBar;
//在条形图顶部下方显示具体数字
@property BOOL showNumberDownTheBar;

//显示X轴
@property BOOL showXAxis;
//显示Y轴
@property BOOL showYAxis;
//显示参照线
@property BOOL showDatumLine;

@end
