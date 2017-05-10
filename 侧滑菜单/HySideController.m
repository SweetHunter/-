//
//  HySideController.m
//  侧滑菜单
//
//  Created by tongfang on 2017/5/9.
//  Copyright © 2017年 Hyman. All rights reserved.
//

#import "HySideController.h"

@interface HySideController ()<UIGestureRecognizerDelegate>

/**
 子控制器的容器视图
 */
@property (nonatomic,strong) UIView *childControllerContainerView;

/**
 Center控制器的容器视图
 */
@property (nonatomic,strong) UIView *centerContainerView;

/**
 滑动区域的Frame
 */
@property (nonatomic, assign) CGRect startingPanRect;

/**
 当前显示的Controller
 */
@property (nonatomic,assign) HySide openSide;
@end

@implementation HySideController

#pragma mark *** ControllerLifeCycle ***
- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.centerViewController beginAppearanceTransition:YES animated:NO];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.centerViewController endAppearanceTransition];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.centerViewController beginAppearanceTransition:NO animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.centerViewController endAppearanceTransition];
}

#pragma mark *** init Method ***
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCenterController:(UIViewController *)centerController leftController:(UIViewController *)leftController{
    NSParameterAssert(centerController);
    self = [super init];
    if (self) {
        [self setCenterViewController:centerController];
        [self setLeftController:leftController];
    }
    return self;
}

- (void)setup{
    self.view.backgroundColor = [UIColor redColor];
    [self setupGestureRecognizers];
}
#pragma mark *** setters ***
- (void)setCenterViewController:(UIViewController *)centerViewController{
    //若新的控制器和旧的控制器相同,则返回
    if ([self.centerViewController isEqual:centerViewController]) {
        return;
    }
    
    //创建CenterContainerView
    if (_centerContainerView == nil) {
        CGRect centerContainerViewframe = self.childControllerContainerView.bounds;
        _centerContainerView = [[UIView alloc] initWithFrame:centerContainerViewframe];
        _centerContainerView.backgroundColor = [UIColor clearColor];
        _centerContainerView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self.childControllerContainerView addSubview:_centerContainerView];
    }
    
    _centerViewController = centerViewController;
    [self addChildViewController:self.centerViewController];//建立逻辑上的父子关系,自动调用[self.centerViewController willMoveToParentViewController:self]
    self.centerViewController.view.frame = self.centerContainerView.bounds;
    [self.centerContainerView addSubview:self.centerViewController.view];
    [self.childControllerContainerView bringSubviewToFront:self.centerContainerView];
    self.centerViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        //正式建立父子关系
    [self.centerViewController didMoveToParentViewController:self];
}

- (void)setLeftController:(UIViewController *)leftController{
    _leftController = leftController;
    if (leftController) {
        [self addChildViewController:leftController]; //建立逻辑上的父子关系,自动调用[leftController willMoveToParentViewController:self]
        [self.childControllerContainerView addSubview:leftController.view];
        [self.childControllerContainerView sendSubviewToBack:leftController.view];
        leftController.view.hidden = YES;
        leftController.view.backgroundColor = [UIColor clearColor];
        leftController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [leftController didMoveToParentViewController:self];
        CGRect leftViewFrame = self.view.bounds;
        leftViewFrame.size.width = [UIScreen mainScreen].bounds.size.width/2.f;
        leftViewFrame.size.height -= 20.f;
        leftController.view.frame =leftViewFrame;
    }
}

- (UIView *)childControllerContainerView{
    if (!_childControllerContainerView) {
        CGRect childContainerViewFrame = self.view.bounds;
        _childControllerContainerView = [[UIView alloc] initWithFrame:childContainerViewFrame];
        _childControllerContainerView.backgroundColor = [UIColor clearColor];
        [_childControllerContainerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [self.view addSubview:_childControllerContainerView];
    }
    return _childControllerContainerView;
}

#pragma mark *** Gesture Handlers ***
- (void)setupGestureRecognizers{
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureCallback:)];
    [pan setDelegate:self];
    [self.view addGestureRecognizer:pan];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureCallback:)];
    [tap setDelegate:self];
    [self.view addGestureRecognizer:tap];

}

- (void)panGestureCallback:(UIPanGestureRecognizer *)panGesture{
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:{
         self.startingPanRect = self.centerContainerView.frame;
        }
            break;
            
        case UIGestureRecognizerStateChanged:{
            CGPoint panPoint = [panGesture translationInView:self.centerContainerView];
            CGFloat xOffset;
            if (panPoint.x <= [UIScreen mainScreen].bounds.size.width/2.f) {
                xOffset = panPoint.x;
            }else{
                xOffset = [UIScreen mainScreen].bounds.size.width/2.f;
            }
            HySide visibleSide = HySideCenter;
            if (xOffset > 0) {
            visibleSide = HySideLeft;
            }
            if (self.openSide != visibleSide) {
                [self.leftController.view setHidden:NO];
                [self.leftController beginAppearanceTransition:YES animated:NO];
                [self.leftController endAppearanceTransition];
            }
            self.leftController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width/2.f, self.view.bounds.size.height - 20);
            CGRect newFrame = self.startingPanRect;
            newFrame.origin.x = xOffset;
            self.centerContainerView.frame = newFrame;
            self.openSide = visibleSide;
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:{
        
        }
            break;
        default:
            break;
    }
//    switch (panGesture.state) {
//        case UIGestureRecognizerStateBegan:{
//            self.startingPanRect = self.centerContainerView.frame;
//            break;
//        }
//        case UIGestureRecognizerStateChanged:{
//            self.view.userInteractionEnabled = NO;
//            CGRect newFrame = self.startingPanRect;
//            CGPoint translatedPoint = [panGesture translationInView:self.centerContainerView];
////            newFrame.origin.x = [self roundedOriginXForDrawerConstriants:CGRectGetMinX(self.startingPanRect)+translatedPoint.x];
//            newFrame.origin.x = CGRectGetMinX(self.startingPanRect)+translatedPoint.x> [UIScreen mainScreen].bounds.size.width/2.f ? [UIScreen mainScreen].bounds.size.width/2.f :CGRectGetMinX(self.startingPanRect)+translatedPoint.x;
//            newFrame = CGRectIntegral(newFrame);
//            CGFloat xOffset = newFrame.origin.x;
//            
//            HySide visibleSide = HySideLeft;
//            CGFloat percentVisible = 0.0;
//            percentVisible = xOffset/[UIScreen mainScreen].bounds.size.width;
//            
//            if(self.openSide != visibleSide){
//                //Handle disappearing the visible drawer
//                UIViewController * sideDrawerViewController = [self sideDrawerViewControllerForSide:self.openSide];
//                [sideDrawerViewController beginAppearanceTransition:NO animated:NO];
//                [sideDrawerViewController endAppearanceTransition];
//                
//                //Drawer is about to become visible
//                [self prepareToPresentDrawer:visibleSide animated:NO];
//                [visibleSideDrawerViewController endAppearanceTransition];
//                [self setOpenSide:visibleSide];
//            }
//            else if(visibleSide == MMDrawerSideNone){
//                [self setOpenSide:MMDrawerSideNone];
//            }
//            
//            [self updateDrawerVisualStateForDrawerSide:visibleSide percentVisible:percentVisible];
//            
//            [self.centerContainerView setCenter:CGPointMake(CGRectGetMidX(newFrame), CGRectGetMidY(newFrame))];
//            
//            newFrame = self.centerContainerView.frame;
//            newFrame.origin.x = floor(newFrame.origin.x);
//            newFrame.origin.y = floor(newFrame.origin.y);
//            self.centerContainerView.frame = newFrame;
//            
//            break;
//        }
//        case UIGestureRecognizerStateEnded:
//        case UIGestureRecognizerStateCancelled: {
//            self.startingPanRect = CGRectNull;
//            CGPoint velocity = [panGesture velocityInView:self.childControllerContainerView];
//            [self finishAnimationForPanGestureWithXVelocity:velocity.x completion:^(BOOL finished) {
//                if(self.gestureCompletion){
//                    self.gestureCompletion(self, panGesture);
//                }
//            }];
//            self.view.userInteractionEnabled = YES;
//            break;
//        }
//        default:
//            break;
//    }
//
}

- (void)tapGestureCallback:(UITapGestureRecognizer *)tapGesture{

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
