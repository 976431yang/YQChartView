//
//  YQChartBar_YView.h
//  YQChartViewDEMO
//
//  Created by problemchild on 2017/3/25.
//  Copyright © 2017年 ProblenChild. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YQChartBar_YView : UIView

//noNegMode
-(void)setWithFrame:(CGRect)frame
           Labcount:(int)count
              texts:(NSArray<NSString *> *)texts
              showY:(BOOL)showYAxis
               font:(UIFont *)font;
//negMode
-(void)setnegModeWithFrame:(CGRect)frame
                  Labcount:(int)count
                   Uptexts:(NSArray<NSString *> *)uptexts
                 downtexts:(NSArray<NSString *> *)downtexts
                  zeroRait:(CGFloat)rait
                     showY:(BOOL)showYAxis
                      font:(UIFont *)font;

@end
