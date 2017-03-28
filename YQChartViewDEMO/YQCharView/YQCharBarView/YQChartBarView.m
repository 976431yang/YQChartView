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


#define kWidthUnderData    30
#define kWidthForTopNumber 20
#define kxAlixWidth        1
#define kyAlixWidth        1

@interface YQChartBarView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

//y轴
@property(nonatomic,strong)YQChartBar_YView *YView;
//x轴
@property(nonatomic,strong)UIView *XView;
//数据区域
@property(nonatomic,strong)UICollectionView *MainCollectionView;
//所有数据
@property (nonatomic,strong)NSMutableArray<NSDictionary *> *MainDataArr;
//最大值
@property(nonatomic,strong)NSNumber *AllDataMaxValuve;
//最小值
@property(nonatomic,strong)NSNumber *AllDataMinValuve;
//最后一次缩放后view的缩放比例
@property CGFloat lastscale;
//最后一次缩放后的手势比例
@property CGFloat lastPinch;
//最终计算出来的cell的width
@property CGFloat finalCellWidth;
//正负数模式
@property BOOL negMode;
//x轴所在比例
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
    self.YLabelsCount = 4;
    self.showXAxis = YES;
    self.showYAxis = YES;
    self.YLabelWidth =40;
    self.animation = YES;
    self.XLableFont = [UIFont systemFontOfSize:15];
    self.YLableFont = [UIFont systemFontOfSize:18];
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

//添加一组数据
-(void)addDataGroup:(NSArray<NSNumber *> *)data forColor:(UIColor *)color{
    NSNumber *max = @0;
    NSNumber *min = @0;
    for (NSNumber *number in data) {
        if(max.floatValue < number.floatValue)  max = number;
        if(number.floatValue<0)                 self.negMode = YES;
        if(number.floatValue < min.floatValue)  min = number;
    }
    
    NSDictionary *aGroup = @{
                             @"data":data,
                             @"color":color,
                             @"max":max,
                             @"min":min
                             };
    if(!self.MainDataArr) self.MainDataArr = [NSMutableArray array];
    [self.MainDataArr addObject:aGroup];
}

-(void)clearData{
    self.MainDataArr = [NSMutableArray array];
    self.negMode     = NO;
    self.lastscale = 1;
    [self loadAndShow];
}

-(void)loadAndShow{
    
    if(self.YLabelsCount<0){
        self.YLabelsCount = 0;
    }
    
    //--------------------------------------------------Y轴
    if(!self.YView){
        self.YView = [YQChartBar_YView new];
        [self addSubview:self.YView];
    }
    NSMutableArray *YLableTexts = [NSMutableArray array];
    
    NSNumber *maxValue = @0;
    NSNumber *minValue = @0;
    //得到最大、小值
    for (int i=0; i<self.MainDataArr.count; i++) {
        
        NSDictionary * eachGroup = self.MainDataArr[i];
        NSNumber *GroupMax = (NSNumber *)[eachGroup valueForKey:@"max"];
        NSNumber *GroupMin = (NSNumber *)[eachGroup valueForKey:@"min"];
        
        if(GroupMax.floatValue > maxValue.floatValue) maxValue = GroupMax;
        if(GroupMin.floatValue < minValue.floatValue) minValue = GroupMin;
    }
    self.AllDataMaxValuve = maxValue;
    self.AllDataMinValuve = minValue;
    
    if(!self.negMode){
        //--------------------------------------------------无负数模式--Y轴
        
        //得到Y轴坐标
        for (int i=0; i<self.YLabelsCount; i++) {
            //计算
            float eachPart = 0;
            if(self.YLabelsCount>1){
                eachPart = maxValue.floatValue / (self.YLabelsCount-1);
            }
            float outFloat = i*eachPart;
            //转换一下
            NSString *outStr = [self converFloatToCustomStrWithFloat:outFloat];
            //保存
            [YLableTexts addObject:outStr];
        }
        
        CGFloat heightForYView = self.frame.size.height-kWidthUnderData-kWidthForTopNumber;
        
        //显示YView
        [self.YView setWithFrame:CGRectMake(0,
                                            kWidthForTopNumber,
                                            self.YLabelWidth,
                                            heightForYView)
                        Labcount:self.YLabelsCount
                           texts:YLableTexts
                           showY:self.showYAxis
                            font:self.YLableFont];
        //--------------------------------------------------X轴
        if(self.showXAxis){
            //需要显示X轴
            if(!self.XView){
                //尚未初始化
                self.XView = [[UIView alloc]init];
                self.XView.backgroundColor = [UIColor blackColor];
                [self addSubview:self.XView];
            }
            self.XView.frame = CGRectMake(self.YView.frame.size.width,
                                          self.frame.size.height-kWidthUnderData,
                                          self.frame.size.width-self.YLabelWidth,
                                          kxAlixWidth);
            self.XView.alpha = 1;
        }else{
            //不需要显示X轴
            self.XView.alpha = 0;
        }
        
    }else {
        
        //--------------------------------------------------有负数模式
        NSMutableArray *YUpLableTexts   = [NSMutableArray array];
        NSMutableArray *YDownLableTexts = [NSMutableArray array];
        //正数部分
        for (int i=0; i<self.YLabelsCount; i++) {
            float eachPart = maxValue.floatValue / (self.YLabelsCount-1);
            float outFloat = i*eachPart;
            NSString *outStr = [self converFloatToCustomStrWithFloat:outFloat];
            [YUpLableTexts addObject:outStr];
        }
        //负数部分
        for (int i=0; i<self.YLabelsCount; i++) {
            float eachPart = minValue.floatValue / (self.YLabelsCount-1);
            float outFloat = i*eachPart;
            NSString *outStr = [self converFloatToCustomStrWithFloat:outFloat];
            [YDownLableTexts addObject:outStr];
        }
        //x轴所在位置比例
        float rait = maxValue.floatValue / (-minValue.floatValue + maxValue.floatValue);
        self.zeroRait = rait;
        
        CGFloat heightForYView = self.frame.size.height-kWidthUnderData-kWidthForTopNumber;
        
        //显示Y轴
        [self.YView setnegModeWithFrame:CGRectMake(0,
                                                   kWidthForTopNumber,
                                                   self.YLabelWidth,
                                                   heightForYView)
                               Labcount:self.YLabelsCount
                                Uptexts:YUpLableTexts
                              downtexts:YDownLableTexts
                               zeroRait:rait
                                  showY:self.showYAxis
                                   font:self.YLableFont];
        
        //--------------------------------------------------X轴
        if(self.showXAxis){
            if(!self.XView){
                self.XView = [[UIView alloc]init];
                self.XView.backgroundColor = [UIColor blackColor];
                [self addSubview:self.XView];
            }
            self.XView.frame = CGRectMake(self.YView.frame.size.width,
                                          self.frame.size.height-kWidthUnderData,
                                          self.frame.size.width-self.YLabelWidth,
                                          kxAlixWidth);
            self.XView.alpha = 1;
        }else{
            self.XView.alpha = 0;
        }
        
        
    }
    

    
    //--------------------------------------------------CollectionView
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    self.finalCellWidth = self.MainDataArr.count*self.barWidth + (self.MainDataArr.count-1)*self.GroupInterval;
    
    //大小
    layout.itemSize = CGSizeMake(self.finalCellWidth,
                                 self.frame.size.height);
    //最小行间距
    layout.minimumLineSpacing = self.DataInterval;
    //滚动方向为横向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //内容距离屏幕边缘的距离:上左下右
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, self.DataInterval);
    
    if(!self.MainCollectionView){
        self.MainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero
                                                    collectionViewLayout:layout];
        self.MainCollectionView.delegate = self;
        self.MainCollectionView.dataSource = self;
        self.MainCollectionView.backgroundColor = [UIColor clearColor];
        self.MainCollectionView.alwaysBounceHorizontal = YES;
        [self.MainCollectionView registerClass:[YQCharBarCell class] forCellWithReuseIdentifier:@"YQChartBarCell"];
        [self addSubview:self.MainCollectionView];
    }
    
    self.MainCollectionView.frame = CGRectMake(self.YView.frame.size.width,
                                               0,
                                               self.frame.size.width-self.YView.frame.size.width,
                                               self.frame.size.height);
    self.MainCollectionView.collectionViewLayout = layout;
    [self.MainCollectionView layoutSubviews];
    [self.MainCollectionView reloadData];
    
    if(self.allowPinch){
        UIPinchGestureRecognizer *Pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(gestureFunction:)];
        //把手势添加到视图上
        [self.MainCollectionView addGestureRecognizer:Pinch];
        self.lastscale = 1;
    }else{
        for (UIGestureRecognizer *gu in self.MainCollectionView.gestureRecognizers) {
            if([gu isKindOfClass:[UIPinchGestureRecognizer class]]){
                [self.MainCollectionView removeGestureRecognizer:gu];
            }
        }
    }
    
}

//把浮点数转换成需要的字符串（最多3位小数，小于3位的时候，有多少位显示多少位）
-(NSString *)converFloatToCustomStrWithFloat:(float)outFloat{
    NSString *outStr = @"0";
    int zearoNumber = [NSString stringWithFormat:@"%.0f",outFloat].intValue;
    int oneNumber = (int)(outFloat*10);
    int twoNumber = (int)(outFloat*100);
    if(outFloat == zearoNumber){
        outStr = [NSString stringWithFormat:@"%d",(int)outFloat];
    }else if(outFloat*10 == oneNumber){
        outStr = [NSString stringWithFormat:@"%.1f",outFloat];
    }else if(outFloat*100 == twoNumber){
        outStr = [NSString stringWithFormat:@"%.2f",outFloat];
    }else{
        outStr = [NSString stringWithFormat:@"%.3f",outFloat];
    }
    return outStr;
}

//缩放手势反应
-(void)gestureFunction:(id)sender{
    
    UIPinchGestureRecognizer *gesture=(UIPinchGestureRecognizer *)sender;
    double scale=gesture.scale;
    
    if (gesture.state ==UIGestureRecognizerStateBegan) {
        self.animation = NO;
    }
    
    if (gesture.state ==UIGestureRecognizerStateChanged) {
        if([self canPinch:scale*self.lastscale]){
            self.lastPinch = scale;
            [self changeMid:scale*self.lastscale];
        }
    }
    if ((gesture.state ==UIGestureRecognizerStateEnded) || (gesture.state ==UIGestureRecognizerStateCancelled)) {
        self.animation = YES;
        self.lastscale = self.lastscale*self.lastPinch;
        //NSLog(@"scale%f",scale);
        //NSLog(@"lastscale%f",self.lastscale);
    }
}

//检查是否能继续缩放
-(BOOL)canPinch:(float)scale{
    if(self.finalCellWidth*scale>=self.minBarWidth && self.finalCellWidth*scale<=self.maxBarWidth){
        return YES;
    }else{
        return NO;
    }
}

//缩放CollectionView
-(void)changeMid:(double)scale{
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    //大小
    layout.itemSize = CGSizeMake(self.finalCellWidth*scale, self.frame.size.height);
    //最小行间距
    layout.minimumLineSpacing = self.barWidth *scale;
    //滚动方向为横向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, self.DataInterval *scale);
    
    self.MainCollectionView.collectionViewLayout = layout;
    [self.MainCollectionView layoutSubviews];
    [self.MainCollectionView reloadData];
}


#pragma mark UICollectionViewDataSource$UICollectionViewDelegateFlowLayout

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.XLables.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YQCharBarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YQChartBarCell" forIndexPath:indexPath];
    
    //是否显示TopNumber
    cell.showTopNumberUp   = self.showTopNumberUpTheBar;
    cell.showTopNumberDown = self.showTopNumberDownTheBar;
    
    if(self.XLables.count>=indexPath.row+1){
        
        NSString       *key         = self.XLables[indexPath.row];
        NSMutableArray *dataComment = [NSMutableArray array];
        NSMutableArray *colors      = [NSMutableArray array];
        
        for(int i=0;i<self.MainDataArr.count;i++){
            
            NSDictionary *group        = self.MainDataArr[i];
            UIColor      *color        = [group valueForKey:@"color"];
            NSArray      *groupDataArr = [group valueForKey:@"data"];
            NSNumber     *value        =    @0;
            if (groupDataArr.count >= indexPath.row+1) {
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

//动画效果
-(void)collectionView:(UICollectionView *)collectionView
      willDisplayCell:(YQCharBarCell *)cell
   forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.animation){
        
        if(self.negMode){
            //有正负数的时候，从中间开始往两边展开动画
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
            //只有正数的时候，从下往上动画
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
