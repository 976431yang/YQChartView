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
           Labcount:(int)count
              texts:(NSArray<NSString *> *)texts
              showY:(BOOL)showYAxis
{
    self.backgroundColor = [UIColor clearColor];
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    
    self.frame = frame;
    
    //+1是因为上下各超出一半
    CGFloat LableHeight = frame.size.height / (count-1);
    
    for (int i=0; i<count; i++) {
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(5,
                                                                i*LableHeight-(LableHeight*0.5),
                                                                self.frame.size.width-10,
                                                                LableHeight)];
        
        lab.numberOfLines = 1;
        lab.textAlignment = NSTextAlignmentRight;
        lab.font = [UIFont systemFontOfSize:20];
        lab.adjustsFontSizeToFitWidth = YES;
        lab.backgroundColor = [UIColor clearColor];
        
        lab.text = (NSString *)(texts[texts.count-i-1]);
        
        [self addSubview:lab];
        
        //NSLog(@"%@",lab.font);
    }
    
    //显示Y轴
    if(showYAxis){
        UIView *YAxis = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width-1,
                                                                0,
                                                                1,
                                                                frame.size.height)];
        YAxis.backgroundColor = [UIColor blackColor];
        [self addSubview:YAxis];
    }
}

@end
