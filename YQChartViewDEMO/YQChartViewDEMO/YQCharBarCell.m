//
//  YQCharBarCell.m
//  YQChartViewDEMO
//
//  Created by problemchild on 2017/3/27.
//  Copyright © 2017年 ProblenChild. All rights reserved.
//

#import "YQCharBarCell.h"

@implementation YQCharBarCell

-(void)setupWithDataComment:(NSArray<NSNumber *> *)Data
                     Colors:(NSArray<UIColor *> *)colors
                    WithKey:(NSString *)key
                       font:(UIFont *)font
                        max:(NSNumber *)max
              GroupInterval:(CGFloat)GroupInterval
             topNumberColor:(UIColor *)TopNumberColor
                        
{
    for (UIView *subview in self.contentView.subviews) {
        [subview removeFromSuperview];
    }
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    //--------------------------------------------------key
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(5,
                                                            self.contentView.frame.size.height-25,
                                                            self.contentView.frame.size.width-10,
                                                            20)];
    lab.font = font;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.numberOfLines = 1;
    lab.adjustsFontSizeToFitWidth = YES;
    lab.text = key;
    
    [self.contentView addSubview:lab];
    
    //--------------------------------------------------柱子
    
    self.dataView = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                            0,
                                                            self.contentView.frame.size.width,
                                                            self.contentView.frame.size.height-30)];
    self.dataView.backgroundColor = [UIColor clearColor];
    
    self.contentView.layer.masksToBounds = YES;
    
    UIView *subview2= [[UIView alloc]initWithFrame:CGRectMake(0,
                                                              0,
                                                              self.contentView.frame.size.width,
                                                              self.contentView.frame.size.height-30)];
    subview2.backgroundColor = [UIColor clearColor];
    subview2.layer.masksToBounds = YES;
    [self.contentView addSubview:subview2];
    
    [subview2 addSubview:self.dataView];
    
    for(int i=0;i<Data.count;i++){
        
        NSNumber *value = Data[i];
        UIColor *color = colors[i];
        
        CGFloat height = (value.floatValue / max.floatValue)*(self.dataView.frame.size.height -20 -30);
        CGFloat Y = self.dataView.frame.size.height - height;
        
        CGFloat width = (self.contentView.frame.size.width - ((Data.count-1) * GroupInterval))/ Data.count;
        if(width<=0)width=1;
        
        UIView *dataview = [[UIView alloc]initWithFrame:CGRectMake(i * (width+GroupInterval),
                                                                   Y,
                                                                   width,
                                                                   height)];
        dataview.backgroundColor = color;
        dataview.layer.cornerRadius = 3;
        dataview.layer.masksToBounds = YES;
        [self.dataView addSubview:dataview];
        
        UILabel *topNumber = [[UILabel alloc] initWithFrame:CGRectZero];
        topNumber.textAlignment = NSTextAlignmentCenter;
        topNumber.textColor = TopNumberColor;
        topNumber.numberOfLines = 1;
        topNumber.font = [UIFont systemFontOfSize:13];
        topNumber.text = [NSString stringWithFormat:@"%@",value];
        topNumber.adjustsFontSizeToFitWidth = YES;
        
        if(self.showTopNumberUp){
            topNumber.frame = CGRectMake(dataview.frame.origin.x,
                                         dataview.frame.origin.y-20,
                                         dataview.frame.size.width,
                                         20);
            [self.dataView addSubview:topNumber];
        }
        if(self.showTopNumberDown){
            topNumber.frame = CGRectMake(dataview.frame.origin.x,
                                         dataview.frame.origin.y,
                                         dataview.frame.size.width,
                                         20);
            [self.dataView addSubview:topNumber];
        }
    }
    
}

@end
