//
//  HySideController.h
//  侧滑菜单
//
//  Created by tongfang on 2017/5/9.
//  Copyright © 2017年 Hyman. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,HySide){
    HySideCenter = 0,
    HySideLeft,
    HySideRight,
};

@interface HySideController : UIViewController

@property (nonatomic, strong) UIViewController * centerViewController;

@property (nonatomic, strong) UIViewController * leftController;

- (instancetype)initWithCenterController:(UIViewController *)centerController leftController:(UIViewController *)leftController;

@end
