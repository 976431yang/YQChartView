//
//  YQChartBar_YView.h
//  YQChartViewDEMO
//
//  Created by problemchild on 2017/3/25.
//  Copyright © 2017年 ProblenChild. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YQChartBar_YView : UIView

-(void)setWithFrame:(CGRect)frame
           Labcount:(int)count
              texts:(NSArray<NSString *> *)texts
              showY:(BOOL)showYAxis;

@end
