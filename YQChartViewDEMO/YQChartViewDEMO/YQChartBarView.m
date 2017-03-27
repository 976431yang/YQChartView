//
//  YQChartBarView.m
//  YQChartViewDEMO
//
//  Created by problemchild on 2017/3/23.
//  Copyright © 2017年 ProblenChild. All rights reserved.
//

#import "YQChartBarView.h"

#import "YQChartBar_YView.h"
#import "YQCharBarCell.h"

@interface YQChartBarView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong)NSMutableArray<NSDictionary *> *MainDataArr;

@property(nonatomic,strong)YQChartBar_YView *YView;

@property(nonatomic,strong)UIView *XView;

@property(nonatomic,strong)UICollectionView *MainCollectionView;

@property(nonatomic,strong)NSNumber *AllDataMaxValuve;

@end

@implementation YQChartBarView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self defaultSetup];
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
    self.YLabelWidth =50;
    self.animation = YES;
    self.XLableFont = [UIFont systemFontOfSize:15];
    self.showDatumLine = NO;
    self.GroupInterval = 0;
    self.DataInterval = 25;
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
    
    //--------------------------------------------------Y轴
    if(!self.YView){
        self.YView = [YQChartBar_YView new];
        [self addSubview:self.YView];
    }
    NSMutableArray *YLableTexts = [NSMutableArray array];
    
    NSNumber *maxValue = @0;
    //得到Y轴最大值
    for (int i=0; i<self.MainDataArr.count; i++) {
        NSDictionary * eachGroup = self.MainDataArr[i];
        NSNumber *GroupMax = (NSNumber *)[eachGroup valueForKey:@"max"];
        if(GroupMax.floatValue > maxValue.floatValue){
            maxValue = GroupMax;
        }
    }
    self.AllDataMaxValuve = maxValue;
    //得到Y轴坐标
    for (int i=0; i<self.YLabelsCount; i++) {
        float eachPart = maxValue.floatValue / self.YLabelsCount;
        float outFloat = i*eachPart;
        NSString *outStr = @"0";
        //判断有几位小数
        int floatCount = 0;
        int zearoNumber = [NSString stringWithFormat:@"%.0f",outFloat].intValue;
        float oneNumber = [NSString stringWithFormat:@"%.1f",outFloat].floatValue;
        float twoNumber = [NSString stringWithFormat:@"%.2f",outFloat].floatValue;
        float thrNumber = [NSString stringWithFormat:@"%.3f",outFloat].floatValue;
        if(outFloat == zearoNumber){
            floatCount = 0;
            outStr = [NSString stringWithFormat:@"%d",(int)outFloat];
        }else if(outFloat == oneNumber){
            floatCount = 1;
            outStr = [NSString stringWithFormat:@"%.1f",outFloat];
        }else if(outFloat == twoNumber){
            floatCount = 2;
            outStr = [NSString stringWithFormat:@"%.2f",outFloat];
        }else if(outFloat >= thrNumber){
            floatCount = 3;
            outStr = [NSString stringWithFormat:@"%.3f",outFloat];
        }
        
        [YLableTexts addObject:outStr];
    }
    
    //显示YView
    [self.YView setWithFrame:CGRectMake(0,
                                        20,
                                        self.YLabelWidth,
                                        self.frame.size.height-30-20)
                    Labcount:self.YLabelsCount
                       texts:YLableTexts
                       showY:self.showYAxis];
    
    //--------------------------------------------------X轴
    if(self.showXAxis){
        if(!self.XView){
            self.XView = [[UIView alloc]initWithFrame:CGRectMake(self.YView.frame.size.width,
                                                                 self.frame.size.height-30,
                                                                 self.frame.size.width-self.YLabelWidth,
                                                                 1)];
            self.XView.backgroundColor = [UIColor blackColor];
            [self addSubview:self.XView];
        }
        self.XView.frame = CGRectMake(self.YView.frame.size.width,
                                      self.frame.size.height-30,
                                      self.frame.size.width-self.YLabelWidth,
                                      1);
        
    }else{
        [self.XView removeFromSuperview];
    }
    
    //--------------------------------------------------CollectionView
    //Layout负责定义视图中cell的大小、行、列、最小间距、滚动方向、内容与四个边缘的位置关系………………
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    
    //大小
    layout.itemSize = CGSizeMake(self.MainDataArr.count*self.barWidth+(self.MainDataArr.count-1)*self.GroupInterval,
                                 self.frame.size.height);
    //最小列间距
    layout.minimumInteritemSpacing = self.DataInterval;
    //最小行间距
    layout.minimumLineSpacing = 10;
    //滚动方向为横向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    //内容距离屏幕边缘的距离:上左下右
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, self.DataInterval);
    
    if(!self.MainCollectionView){
        self.MainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(self.YView.frame.size.width,
                                                                                    0,
                                                                                    self.frame.size.width-self.YView.frame.size.width,
                                                                                    self.frame.size.height)
                                                    collectionViewLayout:layout];
        self.MainCollectionView.delegate = self;
        self.MainCollectionView.dataSource = self;
        
        [self addSubview:self.MainCollectionView];
        self.MainCollectionView.backgroundColor = [UIColor clearColor];
        self.MainCollectionView.alwaysBounceHorizontal = YES;
        
        [self.MainCollectionView registerClass:[YQCharBarCell class] forCellWithReuseIdentifier:@"YQChartBarCell"];
    }
    
    self.MainCollectionView.frame = CGRectMake(self.YView.frame.size.width,
                                               0,
                                               self.frame.size.width-self.YView.frame.size.width,
                                               self.frame.size.height);
    self.MainCollectionView.collectionViewLayout = layout;
    [self.MainCollectionView reloadData];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.XLables.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YQCharBarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YQChartBarCell" forIndexPath:indexPath];
    
    cell.showTopNumberUp   = self.showTopNumberUpTheBar;
    cell.showTopNumberDown = self.showTopNumberDownTheBar;
    
    if(self.XLables.count>=indexPath.row+1){
        
        NSString *key = self.XLables[indexPath.row];
        
        NSMutableArray *dataComment = [NSMutableArray array];
        NSMutableArray *colors = [NSMutableArray array];
        
        for(int i=0;i<self.MainDataArr.count;i++){
            
            NSDictionary *group = self.MainDataArr[i];
            
            UIColor *color = [group valueForKey:@"color"];
            NSArray *groupDataArr = [group valueForKey:@"data"];
            NSNumber *value = @0;
            if (groupDataArr.count>=indexPath.row+1) {
                value = groupDataArr[indexPath.row];
            }
            
            [dataComment addObject:value];
            [colors addObject:color];
        }
        
        [cell setupWithDataComment:dataComment
                            Colors:colors
                           WithKey:key
                              font:self.XLableFont
                               max:self.AllDataMaxValuve
                     GroupInterval:self.GroupInterval
                    topNumberColor:self.TopNumberColor];
        
    }else{
        for (UIView *subview in cell.contentView.subviews) {
            [subview removeFromSuperview];
        }
    }
    
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView
      willDisplayCell:(YQCharBarCell *)cell
   forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.animation){
        CGFloat heightBack = cell.dataView.frame.size.height;
        
        cell.dataView.frame = CGRectMake(cell.dataView.frame.origin.x,
                                         cell.dataView.frame.origin.y+heightBack,
                                         cell.dataView.frame.size.width,
                                         0);
        
        [UIView animateWithDuration:0.5 animations:^{
            
            cell.dataView.frame = CGRectMake(cell.dataView.frame.origin.x,
                                             cell.dataView.frame.origin.y-heightBack,
                                             cell.dataView.frame.size.width,
                                             heightBack);
            
        }];
    }
    
}


@end
