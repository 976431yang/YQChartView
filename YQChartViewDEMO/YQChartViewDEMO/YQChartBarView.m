//
//  YQChartBarView.m
//  YQChartViewDEMO
//
//  Created by problemchild on 2017/3/23.
//  Copyright © 2017年 ProblenChild. All rights reserved.
//

#import "YQChartBarView.h"

#import "YQChartBar_YView.h"

@interface YQChartBarView ()

@property (nonatomic,strong)NSMutableArray<NSDictionary *> *MainDataArr;

@property(nonatomic,strong)YQChartBar_YView *YView;

@property(nonatomic,strong)UIView *XView;

@property(nonatomic,strong)UICollectionView *MainCollectionView;

@property(nonatomic,strong)NSNumber *AllDataMaxValuve;

@end

@implementation YQChartBarView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    return self;
}

-(instancetype)init{
    self = [super init];
    [self defaultSetup];
    
    return self;
}

//基本设置
-(void)defaultSetup{
    self.backgroundColor = [UIColor whiteColor];
    self.YLabelsCount = 4;
    self.showXAxis = YES;
    self.showYAxis = YES;
    self.showDatumLine = NO;
    self.GroupInterval = 3;
    self.DataInterval = 10;
    self.barWidth = 30;
    self.allowPinch = YES;
    self.minBarWidth = 5;
    self.maxBarWidth = 150;
    self.showTopNumberUpTheBar = YES;
    self.showTopNumberDownTheBar = NO;
    self.TopNumberColor = [UIColor blackColor];
}

-(void)addDataGroup:(NSArray<NSNumber *> *)data forColor:(UIColor *)color{
    NSNumber *max = @0;
    for (NSNumber *number in data) {
        if(max.floatValue < number.floatValue){
            max = number;
        }
    }
    
    NSDictionary *aGroup = @{
                             @"data":data,
                             @"color":color,
                             @"max":max
                             };
    if(!self.MainDataArr){
        self.MainDataArr = [NSMutableArray array];
    }
    [self.MainDataArr addObject:aGroup];
    [self loadAndShow];
}

-(void)clearData{
    
    self.MainDataArr = [NSMutableArray array];
    [self loadAndShow];
    
}

-(void)loadAndShow{
    
    if(!self.YView){
        self.YView = [YQChartBar_YView new];
    }
    NSMutableArray *YLableTexts = [NSMutableArray array];
    
    for (int i=0; i<self.MainDataArr; i++) {
        NSDictionary * eachGroup = self.MainDataArr[i];
        
    }
    [self.YView setWithFrame:CGRectMake(0, 0, 0, 0)
                    Labcount:self.YLabelsCount
                       texts:nil];
    
    
}




@end
