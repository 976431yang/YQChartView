//
//  YQChartBar_YView.m
//  YQChartViewDEMO
//
//  Created by problemchild on 2017/3/25.
//  Copyright © 2017年 ProblenChild. All rights reserved.
//

#import "YQChartBar_YView.h"

#define kyAlixWidth 1
#define kyLabAround 5

@implementation YQChartBar_YView

-(void)setWithFrame:(CGRect)frame
           Labcount:(int)count
              texts:(NSArray<NSString *> *)texts
              showY:(BOOL)showYAxis
               font:(UIFont *)font
{
    //clear
    self.backgroundColor = [UIColor clearColor];
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }

    self.frame = frame;
    
    //-1是因为上下各超出一半，然后lable显示的就在中间了
    CGFloat LableHeight = frame.size.height / (count-1);
    
    for (int i=0; i<count; i++) {
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(kyLabAround,
                                                                i*LableHeight-(LableHeight*0.5),
                                                                self.frame.size.width-kyLabAround*2,
                                                                LableHeight)];
        
        lab.numberOfLines   = 1;
        lab.textAlignment   = NSTextAlignmentRight;
        lab.font            = font;
        lab.adjustsFontSizeToFitWidth = YES;
        lab.backgroundColor = [UIColor clearColor];
        lab.text = (NSString *)(texts[texts.count-i-1]);
        
        [self addSubview:lab];
    }
    
    //显示Y轴
    if(showYAxis){
        UIView *YAxis = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width-kyAlixWidth,
                                                                0,
                                                                kyAlixWidth,
                                                                frame.size.height)];
        YAxis.backgroundColor = [UIColor blackColor];
        [self addSubview:YAxis];
    }
}

//有正负数模式
-(void)setnegModeWithFrame:(CGRect)frame
                  Labcount:(int)count
                   Uptexts:(NSArray<NSString *> *)uptexts
                 downtexts:(NSArray<NSString *> *)downtexts
                  zeroRait:(CGFloat)rait
                     showY:(BOOL)showYAxis
                      font:(UIFont *)font
{
    self.backgroundColor = [UIColor clearColor];
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    self.frame = frame;
    
    //--------------------------------------------------0
    UILabel *zeroLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,
                                                                frame.size.width,
                                                                20)];
    zeroLab.textAlignment             = NSTextAlignmentRight;
    zeroLab.numberOfLines             = 1;
    zeroLab.adjustsFontSizeToFitWidth = YES;
    zeroLab.text                      = @"0";
    zeroLab.center = CGPointMake(zeroLab.center.x, frame.size.height*rait);
    
    [self addSubview:zeroLab];
    
    //--------------------------------------------------Upview
    UIView *upview = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                             0,
                                                             frame.size.width,
                                                             frame.size.height *rait)];
    upview.backgroundColor = [UIColor clearColor];
    [self addSubview:upview];

    for (int i=0; i<count-1; i++) {
        CGFloat LableHeight = upview.frame.size.height / (count-1);
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(kyLabAround,
                                                                i*LableHeight-(LableHeight*0.5),
                                                                upview.frame.size.width-kyLabAround*2,
                                                                LableHeight)];
        
        lab.numberOfLines             = 1;
        lab.textAlignment             = NSTextAlignmentRight;
        lab.font                      = font;
        lab.adjustsFontSizeToFitWidth = YES;
        lab.backgroundColor           = [UIColor clearColor];
        
        lab.text = (NSString *)(uptexts[uptexts.count-i-1]);
        
        [upview addSubview:lab];
    }
    
    //--------------------------------------------------DownView
    UIView *downview = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                               frame.size.height*rait,
                                                               frame.size.width,
                                                               frame.size.height *(1-rait))];
    downview.backgroundColor = [UIColor clearColor];
    [self addSubview:downview];
    
    for (int i=1; i<count; i++) {
        CGFloat LableHeight = downview.frame.size.height / (count-1);
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(kyLabAround,
                                                                i*LableHeight-(LableHeight*0.5),
                                                                downview.frame.size.width-kyLabAround*2,
                                                                LableHeight)];
        
        lab.numberOfLines             = 1;
        lab.textAlignment             = NSTextAlignmentRight;
        lab.font                      = font;
        lab.adjustsFontSizeToFitWidth = YES;
        lab.backgroundColor           = [UIColor clearColor];
        lab.text                      = (NSString *)(downtexts[i]);
        
        [downview addSubview:lab];
    }
    
    //显示Y轴
    if(showYAxis){
        UIView *YAxis = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width-kyAlixWidth,
                                                                0,
                                                                kyAlixWidth,
                                                                frame.size.height)];
        YAxis.backgroundColor = [UIColor blackColor];
        [self addSubview:YAxis];
    }
}

@end
