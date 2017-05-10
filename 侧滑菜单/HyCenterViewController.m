//
//  HyCenterViewController.m
//  侧滑菜单
//
//  Created by tongfang on 2017/5/9.
//  Copyright © 2017年 Hyman. All rights reserved.
//

#import "HyCenterViewController.h"

@interface HyCenterViewController ()

@end

@implementation HyCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"CenterView Will Appear");
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"CenterView Did Appear");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
