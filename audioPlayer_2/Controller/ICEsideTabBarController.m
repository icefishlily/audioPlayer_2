//
//  ICEsideTabBarController.m
//  audioPlayer_2
//
//  Created by jinhui005 on 16/9/9.
//  Copyright © 2016年 yhl. All rights reserved.
//

#import "ICEsideTabBarController.h"
#import "CDSideBarController.h"
#import "ICEPlayViewController.h"
#import "ICEChannelListController.h"

@interface ICEsideTabBarController () <CDSideBarControllerDelegate>

@property (nonatomic, strong) CDSideBarController *sideBar;

@end

@implementation ICEsideTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *imageArray = @[[UIImage imageNamed:@"menuPlayer"], [UIImage imageNamed:@"menuChannel"], [UIImage imageNamed:@"menuClose"]];
    self.sideBar = [[CDSideBarController alloc] initWithImages:imageArray];
    self.sideBar.delegate = self;
    
    ICEPlayViewController *playVC = [[ICEPlayViewController alloc] init];
    ICEChannelListController *channelVC = [[ICEChannelListController alloc] init];
    
    self.viewControllers = @[playVC, channelVC];
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.tabBar.hidden = YES;
    
    for (UIView *child in self.tabBar.subviews)
    {
        if ([child isKindOfClass:[UIControl class]])
        {
            [child removeFromSuperview];
        }
    }
    
    [self.sideBar insertMenuButtonOnView:[UIApplication sharedApplication].delegate.window atPosition:CGPointMake(self.view.frame.size.width - 70, 50)];
}

#pragma mark - SDSideBarContollerDelegate
- (void)menuButtonClicked:(int)index {
    switch (index) {
        case 0:
        case 1:
            self.selectedIndex = index;
            break;
        default:
            break;
    }
}

@end
