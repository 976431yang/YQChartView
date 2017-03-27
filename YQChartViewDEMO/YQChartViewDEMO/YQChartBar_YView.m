//
//  YQChartBar_YView.m
//  YQChartViewDEMO
//
//  Created by problemchild on 2017/3/25.
//  Copyright © 2017年 ProblenChild. All rights reserved.
//

#import "YQChartBar_YView.h"

@implementation YQChartBar_YView

-(void)setWithFrame:(CGRect)frame
           Labcount:(NSInteger *)count
              texts:(NSArray<NSString *> *)texts
{
    self.backgroundColor = [UIColor clearColor];
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    
    self.frame = frame;
    
    //+1是因为上下各超出一半
    CGFloat LableHeight = frame.size.height / ((int)count+1);
    
    for (int i=0; i<=(int)count; i++) {
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0,
                                                                i*LableHeight-(LableHeight*0.5),
                                                                LableHeight,
                                                                self.frame.size.width)];
        
        lab.numberOfLines = 1;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:40];
        lab.adjustsFontSizeToFitWidth = YES;
        
        if(i == (int)count){
            lab.text = @"0";
        }else if(i<(int)count){
            lab.text = (NSString *)(texts[i]);
        }
        
        [self addSubview:lab];
    }
}

@end
