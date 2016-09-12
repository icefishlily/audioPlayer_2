//
//  ViewController.h
//  audioPlayer_2
//
//  Created by jinhui005 on 16/9/8.
//  Copyright © 2016年 yhl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICEStyleVO.h"

@interface ICEPlayViewController : UIViewController
@property (nonatomic, strong) ICEStyleVO *styleVO;
- (void)loadMusicData:(NSString *)type channel:(NSNumber *)channel;
@end

