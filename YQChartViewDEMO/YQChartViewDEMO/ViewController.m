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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    YQChartBarView *view = [[YQChartBarView alloc]initWithFrame:CGRectMake(0,
                                                                           200,
                                                                           self.view.frame.size.width,
                                                                           300)];
    
    view.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:view];
    
    NSArray *group1 = [self creatDataWithCount:50 maxValue:1000];
    
    NSArray *group2 = [self creatDataWithCount:50 maxValue:800];
    
    NSArray *group3 = [self creatStrWithCount:50 maxValue:1200];
    
    view.XLables = group3;
    
    [view addDataGroup:group1 forColor:[UIColor redColor]];
    [view addDataGroup:group2 forColor:[UIColor greenColor]];
    
    
    
    //[view loadAndShow];
}

-(NSArray *)creatDataWithCount:(int)count maxValue:(int)max{
    
    NSMutableArray *arr = [NSMutableArray array];
    
    
    for (int i=0; i<count; i++) {
        
        int number = (rand()*rand()) % max;
        
//        if(number<0){
//            number = -number;
//        }
        
        [arr addObject:[NSNumber numberWithInt:number]];
    }
    
    return arr;
}


-(NSArray *)creatStrWithCount:(int)count maxValue:(int)max{
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for (int i=0; i<count; i++) {
        
        int number = (rand()*rand()) % max;
        
        [arr addObject:[NSNumber numberWithInt:number].stringValue];
    }
    
    return arr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
