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
}

- (IBAction)slideAction:(id)sender {
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
    
    //加载并显示
    [self.BarView loadAndShow];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.BarView = [[YQChartBarView alloc]initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   self.view.frame.size.width-32,
                                                                   (self.view.frame.size.width-32)/5*3)];
    
    self.BarView.backgroundColor = [UIColor clearColor];
    
    [self.showView addSubview:self.BarView];
    
    [self segmentChang:nil];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
