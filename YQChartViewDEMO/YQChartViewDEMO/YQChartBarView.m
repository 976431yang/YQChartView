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
@property(nonatomic,strong)NSNumber *AllDataMinValuve;

@property CGFloat lastscale;

@property CGFloat lastPinch;

@property CGFloat finalCellWidth;

@property BOOL doAnimation;

@property BOOL negMode;

@property CGFloat zeroRait;

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
    self.YLableFont = [UIFont systemFontOfSize:18];
    self.showDatumLine = NO;
    self.GroupInterval = 0;
    self.DataInterval = 15;
    self.barWidth = 30;
    self.allowPinch = YES;
    self.minBarWidth = 5;
    self.maxBarWidth = 150;
    self.barCornerWidth = 2;
    self.showTopNumberUpTheBar = YES;
    self.showTopNumberDownTheBar = NO;
    self.negMode = NO;
    self.TopNumberColor = [UIColor blackColor];
}

-(void)addDataGroup:(NSArray<NSNumber *> *)data forColor:(UIColor *)color{
    NSNumber *max = @0;
    NSNumber *min = @0;
    for (NSNumber *number in data) {
        if(max.floatValue < number.floatValue){
            max = number;
        }
        if(number.floatValue<0){
            self.negMode = YES;
        }
        if(number.floatValue < min.floatValue){
            min = number;
        }
    }
    
    NSDictionary *aGroup = @{
                             @"data":data,
                             @"color":color,
                             @"max":max,
                             @"min":min
                             };
    if(!self.MainDataArr){
        self.MainDataArr = [NSMutableArray array];
    }
    [self.MainDataArr addObject:aGroup];
    [self loadAndShow];
}

-(void)clearData{
    
    self.MainDataArr = [NSMutableArray array];
    self.negMode = NO;
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
    NSNumber *minValue = @0;
    //得到Y轴最大值
    for (int i=0; i<self.MainDataArr.count; i++) {
        NSDictionary * eachGroup = self.MainDataArr[i];
        NSNumber *GroupMax = (NSNumber *)[eachGroup valueForKey:@"max"];
        NSNumber *GroupMin = (NSNumber *)[eachGroup valueForKey:@"min"];
        if(GroupMax.floatValue > maxValue.floatValue){
            maxValue = GroupMax;
        }
        if(GroupMin.floatValue < minValue.floatValue){
            minValue = GroupMin;
        }
    }
    self.AllDataMaxValuve = maxValue;
    self.AllDataMinValuve = minValue;
    
    if(!self.negMode){
        //--------------------------------------------------无负数模式
        //得到Y轴坐标
        for (int i=0; i<self.YLabelsCount; i++) {
            float eachPart = maxValue.floatValue / (self.YLabelsCount-1);
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
                           showY:self.showYAxis
                            font:self.YLableFont];
        //--------------------------------------------------X轴
        if(self.showXAxis && self.negMode == NO){
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
    }else {
        //--------------------------------------------------负数模式
        NSMutableArray *YUpLableTexts = [NSMutableArray array];
        NSMutableArray *YDownLableTexts = [NSMutableArray array];
        //正数部分
        for (int i=0; i<self.YLabelsCount; i++) {
            float eachPart = maxValue.floatValue / (self.YLabelsCount-1);
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
            [YUpLableTexts addObject:outStr];
        }
        //负数部分
        for (int i=0; i<self.YLabelsCount; i++) {
            float eachPart = minValue.floatValue / (self.YLabelsCount-1);
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
            [YDownLableTexts addObject:outStr];
        }
        
        float rait = maxValue.floatValue / (-minValue.floatValue + maxValue.floatValue);
        
        self.zeroRait = rait;
        
        [self.YView setnegModeWithFrame:CGRectMake(0,
                                                   20,
                                                   self.YLabelWidth,
                                                   self.frame.size.height-30-20)
                               Labcount:self.YLabelsCount
                                Uptexts:YUpLableTexts
                              downtexts:YDownLableTexts
                               zeroRait:rait
                                  showY:self.showYAxis
                                   font:self.YLableFont];
        
    }
    
    
    //--------------------------------------------------X轴
    
    if(self.negMode){
        if(!self.XView){
            self.XView = [[UIView alloc]initWithFrame:CGRectMake(self.YView.frame.size.width,
                                                                 0,
                                                                 self.frame.size.width-self.YLabelWidth,
                                                                 1)];
            self.XView.backgroundColor = [UIColor blackColor];
            [self addSubview:self.XView];
        }
        self.XView.frame = CGRectMake(self.YView.frame.size.width,
                                      self.frame.size.height-30,
                                      self.frame.size.width-self.YLabelWidth,
                                      1);
    }
    
    //--------------------------------------------------CollectionView
    //Layout负责定义视图中cell的大小、行、列、最小间距、滚动方向、内容与四个边缘的位置关系………………
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    
    self.finalCellWidth = self.MainDataArr.count*self.barWidth+(self.MainDataArr.count-1)*self.GroupInterval;
    //大小
    layout.itemSize = CGSizeMake(self.finalCellWidth,
                                 self.frame.size.height);
    //最小列间距
    //layout.minimumInteritemSpacing = self.DataInterval;
    //最小行间距
    layout.minimumLineSpacing = self.DataInterval;
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
        
        if(self.animation){
            UIPinchGestureRecognizer *Pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(gestureFunction:)];
            //设置出发操作需要的点按次数
            //    doubeltap.numberOfTapsRequired = 2;
            //设置需要几根手指触发操作
            //    doubeltap.numberOfTouchesRequired = 2;
            //把手势添加到视图上
            [self.MainCollectionView addGestureRecognizer:Pinch];
            self.doAnimation = self.animation;
        }
        
        self.lastscale = 1;
    }
    if(!self.animation){
        for (UIGestureRecognizer *gu in self.MainCollectionView.gestureRecognizers) {
            [self.MainCollectionView removeGestureRecognizer:gu];
        }
    }
    
    self.MainCollectionView.frame = CGRectMake(self.YView.frame.size.width,
                                               0,
                                               self.frame.size.width-self.YView.frame.size.width,
                                               self.frame.size.height);
    self.MainCollectionView.collectionViewLayout = layout;
    [self.MainCollectionView reloadData];
    
}

-(void)gestureFunction:(id)sender{
    //    NSLog(@"pin-father");
    UIPinchGestureRecognizer *gesture=(UIPinchGestureRecognizer *)sender;
    double scale=gesture.scale;
    
    if (gesture.state ==UIGestureRecognizerStateBegan) {
        self.animation = NO;
        //        [self changeMid:scale*lastsca®le];
    }
    
    if (gesture.state ==UIGestureRecognizerStateChanged) {
        
        if([self canPinch:scale*self.lastscale]){
            [self changeMid:scale*self.lastscale];
            self.lastPinch = scale;
        }
    }
    
    if ((gesture.state ==UIGestureRecognizerStateEnded) || (gesture.state ==UIGestureRecognizerStateCancelled)) {
        self.animation = YES;
        self.lastscale = self.lastscale*self.lastPinch;
        NSLog(@"scale%f",scale);
        NSLog(@"lastscale%f",self.lastscale);
    }
}

-(BOOL)canPinch:(float)scale{
    if(self.finalCellWidth*scale>=self.minBarWidth && self.finalCellWidth*scale<=self.maxBarWidth){
        return YES;
    }else{
        return NO;
    }
}

-(void)changeMid:(double)scale{
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    //大小
    layout.itemSize = CGSizeMake(self.finalCellWidth*scale, self.frame.size.height);
    //最小列间距
    layout.minimumInteritemSpacing = 10;
    //最小行间距
    layout.minimumLineSpacing = self.barWidth *scale;
    //滚动方向为横向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, self.DataInterval *scale);
    
    self.MainCollectionView.collectionViewLayout = layout;
    [self.MainCollectionView layoutSubviews];
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
                    topNumberColor:self.TopNumberColor
                       cornerWidth:self.barCornerWidth
                           negMode:self.negMode
                              rait:self.zeroRait
                               min:self.AllDataMinValuve];
        
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
        if(self.negMode){
            CGFloat heightBackUp = cell.UpDataView.frame.size.height;
            CGFloat heightBackDown = cell.DownDataView.frame.size.height;
            
            cell.UpDataView.frame = CGRectMake(cell.UpDataView.frame.origin.x,
                                               cell.UpDataView.frame.origin.y+heightBackUp,
                                               cell.UpDataView.frame.size.width,
                                               0);
            cell.DownDataView.frame = CGRectMake(cell.DownDataView.frame.origin.x,
                                                 cell.DownDataView.frame.origin.y,
                                                 cell.DownDataView.frame.size.width,
                                                 0);
            
            [UIView animateWithDuration:0.5 animations:^{
                
                cell.UpDataView.frame = CGRectMake(cell.UpDataView.frame.origin.x,
                                                 cell.UpDataView.frame.origin.y-heightBackUp,
                                                 cell.UpDataView.frame.size.width,
                                                 heightBackUp);
                cell.DownDataView.frame = CGRectMake(cell.DownDataView.frame.origin.x,
                                                     cell.DownDataView.frame.origin.y,
                                                     cell.DownDataView.frame.size.width,
                                                     heightBackDown);
                
            }];
        }else{
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
    
}


@end
