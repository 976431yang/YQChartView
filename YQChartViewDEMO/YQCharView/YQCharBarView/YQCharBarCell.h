//
//  YQCharBarCell.h
//  YQChartViewDEMO
//
//  Created by problemchild on 2017/3/27.
//  Copyright © 2017年 ProblenChild. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YQCharBarCell : UICollectionViewCell

@property BOOL showTopNumberUp;
@property BOOL showTopNumberDown;

-(void)setupWithDataComment:(NSArray<NSNumber *> *)Data
                     Colors:(NSArray <UIColor *> *)colors
                    WithKey:(NSString *)key
                       font:(UIFont *)font
                        max:(NSNumber *)max
              GroupInterval:(CGFloat)GroupInterval
             topNumberColor:(UIColor *)TopNumberColor
                cornerWidth:(CGFloat)cornerWidth
                    negMode:(BOOL)negMode
                       rait:(CGFloat)rait
                        min:(NSNumber *)min;

//-----------------------------------------------read--for animation
@property(nonatomic,strong)UIView *dataView;
@property BOOL negMode;
@property(nonatomic,strong)UIView *UpDataView;
@property(nonatomic,strong)UIView *DownDataView;

@end
