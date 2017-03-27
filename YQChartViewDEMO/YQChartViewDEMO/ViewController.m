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
    
    YQChartBarView *view = [YQChartBarView new];
    
    [self.view addSubview:view];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
