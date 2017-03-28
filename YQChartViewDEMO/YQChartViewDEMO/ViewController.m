//
//  ViewController.m
//  YQChartViewDEMO
//
//  Created by problemchild on 2017/3/21.
//  Copyright © 2017年 ProblenChild. All rights reserved.
//

#import "ViewController.h"
#import "YQChartBarView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *showView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment_GroupCount;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment_HaveNeg;

@property (weak, nonatomic) IBOutlet UISwitch *switch_showYAxis;
@property (weak, nonatomic) IBOutlet UISwitch *switch_showXAxis;
@property (weak, nonatomic) IBOutlet UISwitch *switch_animation;
@property (weak, nonatomic) IBOutlet UISwitch *switch_allowPinch;

@property (weak, nonatomic) IBOutlet UISlider *slide_YLableCount;
@property (weak, nonatomic) IBOutlet UILabel *Lable_YLabelCount;
@property (weak, nonatomic) IBOutlet UISlider *slide_YLeftWidth;
@property (weak, nonatomic) IBOutlet UILabel *Lable_YLeftWidth;
@property (weak, nonatomic) IBOutlet UISlider *slide_XFontSize;
@property (weak, nonatomic) IBOutlet UILabel *Lable_XFontSize;
@property (weak, nonatomic) IBOutlet UISlider *slide_YFontSIze;
@property (weak, nonatomic) IBOutlet UILabel *Lable_YFontSize;
@property (weak, nonatomic) IBOutlet UISlider *slide_BarWidth;
@property (weak, nonatomic) IBOutlet UILabel *Lable_BarWidth;
@property (weak, nonatomic) IBOutlet UISlider *slide_GroupInterval;
@property (weak, nonatomic) IBOutlet UISlider *slide_DataInterval;
@property (weak, nonatomic) IBOutlet UILabel *Lable_GroupInterval;
@property (weak, nonatomic) IBOutlet UILabel *Lable_DataInterval;
@property (weak, nonatomic) IBOutlet UISlider *slide_MinBarWidth;
@property (weak, nonatomic) IBOutlet UILabel *Lable_MinBarWidth;
@property (weak, nonatomic) IBOutlet UISlider *slide_MaxBarWidth;
@property (weak, nonatomic) IBOutlet UILabel *Lable_MaxBarWidth;

@property (weak, nonatomic) IBOutlet UISlider *slide_DataCount;
@property (weak, nonatomic) IBOutlet UILabel *Lable_DataCount;

@property(nonatomic,strong) YQChartBarView *BarView;

@end

@implementation ViewController


- (IBAction)switchAction:(id)sender {
    //只更新设置，重新加载旧数据
    [self UpdateSetting];
    [self.BarView loadAndShow];
}

- (IBAction)slideAction:(id)sender {
    
    if(sender == self.slide_DataCount){
        //更新设置并重新生成数据，显示
        [self segmentChang:nil];
    }else{
        //只更新设置，重新加载旧数据
        [self UpdateSetting];
        [self.BarView loadAndShow];
    }
}

- (IBAction)clearData:(id)sender {
    [self.BarView clearData];
}

- (IBAction)segmentChang:(id)sender {
    [self.BarView clearData];
    
    BOOL NegMode = (self.segment_HaveNeg.selectedSegmentIndex==0)?NO:YES;
    int  dataCount = self.slide_DataCount.value;
    
    //制作并传入X坐标
    NSArray<NSString *> *XLableTexts = [self creatXLableTestxWithCount:dataCount];
    self.BarView.XLables = XLableTexts;
    
    //制作并传入第一组数据
    NSArray<NSNumber *> *firstValues = [self creatDataWithCount:dataCount Neg:NegMode];
    [self.BarView addDataGroup:firstValues forColor:[UIColor colorWithRed:0.988 green:0.365 blue:0.481 alpha:1.000]];
    
    if(self.segment_GroupCount.selectedSegmentIndex>0){
        NSArray<NSNumber *> *Values = [self creatDataWithCount:dataCount Neg:NegMode];
        [self.BarView addDataGroup:Values forColor:[UIColor colorWithRed:0.560 green:1.000 blue:0.526 alpha:1.000]];
    }
    if(self.segment_GroupCount.selectedSegmentIndex>1){
        NSArray<NSNumber *> *Values = [self creatDataWithCount:dataCount Neg:NegMode];
        [self.BarView addDataGroup:Values forColor:[UIColor colorWithRed:0.484 green:0.567 blue:0.979 alpha:1.000]];
    }
    
    //加载设置
    [self UpdateSetting];
    
    //加载并显示
    [self.BarView loadAndShow];
}

//更新设置
-(void)UpdateSetting{
    
    self.BarView.showXAxis = self.switch_showXAxis.isOn;
    self.BarView.showYAxis = self.switch_showYAxis.isOn;
    self.BarView.animation = self.switch_animation.isOn;
    self.BarView.allowPinch = self.switch_allowPinch.isOn;
    
    self.BarView.YLabelsCount = (int)self.slide_YLableCount.value;
    self.Lable_YLabelCount.text = [NSString stringWithFormat:@"%d",(int)self.slide_YLableCount.value];
    
    self.BarView.YLabelWidth = (int)self.slide_YLeftWidth.value;
    self.Lable_YLeftWidth.text = [NSString stringWithFormat:@"%d",(int)self.slide_YLeftWidth.value];
    
    self.BarView.XLableFont = [UIFont systemFontOfSize:(int)self.slide_XFontSize.value];
    self.Lable_XFontSize.text = [NSString stringWithFormat:@"%d",(int)self.slide_XFontSize.value];
    
    self.BarView.YLableFont = [UIFont systemFontOfSize:(int)self.slide_YFontSIze.value];
    self.Lable_YFontSize.text = [NSString stringWithFormat:@"%d",(int)self.slide_YFontSIze.value];
    
    self.BarView.barWidth = (int)self.slide_BarWidth.value;
    self.Lable_BarWidth.text = [NSString stringWithFormat:@"%d",(int)self.slide_BarWidth.value];
    
    self.BarView.GroupInterval = (int)self.slide_GroupInterval.value;
    self.Lable_GroupInterval.text = [NSString stringWithFormat:@"%d",(int)self.slide_GroupInterval.value];
    
    self.BarView.DataInterval = (int)self.slide_DataInterval.value;
    self.Lable_DataInterval.text = [NSString stringWithFormat:@"%d",(int)self.slide_DataInterval.value];
    
    self.BarView.YLabelsCount = (int)self.slide_YLableCount.value;
    self.Lable_YLabelCount.text = [NSString stringWithFormat:@"%d",(int)self.slide_YLableCount.value];
    
    self.BarView.minBarWidth = (int)self.slide_MinBarWidth.value;
    self.Lable_MinBarWidth.text = [NSString stringWithFormat:@"%d",(int)self.slide_MinBarWidth.value];
    
    self.BarView.maxBarWidth = (int)self.slide_MaxBarWidth.value;
    self.Lable_MaxBarWidth.text = [NSString stringWithFormat:@"%d",(int)self.slide_MaxBarWidth.value];
    
    self.Lable_DataCount.text = [NSString stringWithFormat:@"%d",(int)self.slide_DataCount.value];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.BarView = [[YQChartBarView alloc]initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   self.view.frame.size.width-32,
                                                                   (self.view.frame.size.width-32)/5*3)];
    
    self.BarView.backgroundColor = [UIColor colorWithRed:0.917 green:0.928 blue:0.928 alpha:1.000];
    
    [self.showView addSubview:self.BarView];
    
    [self segmentChang:nil];
    
    self.Lable_DataCount.adjustsFontSizeToFitWidth = YES;
    
    
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"run on simulator");
    [self alert];
#define SIMULATOR_TEST
#else
    //不定义SIMULATOR_TEST这个宏
    NSLog(@"run on device");
#endif
}


-(NSArray *)creatDataWithCount:(int)count Neg:(BOOL)neg{
    
    NSMutableArray *arr = [NSMutableArray array];
    
    
    for (int i=0; i<count; i++) {
        
        int number = (rand()*rand()) % 1000;
        
        if(!neg){
            if(number<0){
                number = -number;
            }
        }
        
        [arr addObject:[NSNumber numberWithInt:number]];
    }
    
    return arr;
}


-(NSArray *)creatXLableTestxWithCount:(int)count{
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for (int i=0; i<count; i++) {
        [arr addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    return arr;
}


-(void)alert{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"建议使用真机运行"
                                                                             message:@"动画效果在模拟器上运行可能会稍有卡顿，真机运行会比较流畅"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"好的"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          //NSLog(@"相关操作");
                                                          self.switch_animation.on = NO;
                                                          [self UpdateSetting];
                                                          [self.BarView loadAndShow];
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
