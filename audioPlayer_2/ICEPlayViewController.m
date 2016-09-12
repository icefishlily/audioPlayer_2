//
//  ViewController.m
//  audioPlayer_2
//
//  Created by jinhui005 on 16/9/8.
//  Copyright © 2016年 yhl. All rights reserved.
//

#import "ICEPlayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AFNetworking/AFNetworking.h>
#import "ICESongVO.h"
#import "MJExtension.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

#define INITVOLUME 0.6

@interface ICEPlayViewController ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) NSArray *songItemArray;
@property (nonatomic, assign) int index;
@property (nonatomic, strong) ICESongVO *songVO;
@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *backcornerView;

@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *totleTimeLabel;
@property (nonatomic, strong) UILabel *songName;
@property (nonatomic, strong) UILabel *artistName;
@property (nonatomic, strong) UISlider *volumeSlider;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIButton *nextBtn;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSString *totleTimeStr;

@property (nonatomic, strong) NSArray *colorArray;

@end

@implementation ICEPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.colorArray = [NSArray arrayWithObjects:@"0xFAEBD7", @"0xF0FFF0", @"0xF5F5F5", @"0xFAFFF0", @"0xBDFCC9", @"0xFFC0CB", @"0xFFF5EE", @"0x808A87", nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    ICEStyleVO *newstyleVO = [[ICEStyleVO alloc] init];
    newstyleVO.id = [NSNumber numberWithInteger:0];
    newstyleVO.name = @"我的音乐";
    self.styleVO = newstyleVO;
    
    [self.view addSubview:self.titleLable];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.backcornerView];
    [self.view addSubview:self.timeLabel];
    [self.view addSubview:self.totleTimeLabel];
    [self.view addSubview:self.songName];
    [self.view addSubview:self.artistName];
    [self.view addSubview:self.volumeSlider];
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.btn];
    [self.view addSubview:self.nextBtn];
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(18);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.top.equalTo(self.titleLable.mas_bottom).offset(18);
        make.height.equalTo(self.imageView.mas_width);
    }];
    
    [self.backcornerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.imageView);
        make.width.height.equalTo(@70);
    }];
    
    [self.songName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.imageView.mas_bottom).offset(45);
    }];
    
    [self.artistName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.songName.mas_bottom).offset(20);
    }];
    
    [self.volumeSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(18);
        make.right.equalTo(self.view).offset(-18);
        make.top.equalTo(self.imageView.mas_bottom).offset(40);
        make.height.equalTo(@20);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
        make.top.equalTo(self.artistName.mas_bottom).offset(50);
        make.height.equalTo(@2);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.progressView);
        make.right.equalTo(self.progressView.mas_left).offset(-5);
    }];
    
    [self.totleTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.progressView);
        make.left.equalTo(self.progressView.mas_right).offset(5);
    }];
    
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(-60);
        make.top.equalTo(self.progressView.mas_bottom).offset(30);
        make.width.height.equalTo(@40);
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(60);
        make.top.bottom.equalTo(self.btn);
        make.width.height.equalTo(@40);
    }];
    
    self.isPlaying = NO;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.02
                                             target:self
                                           selector:@selector(updateProgress)
                                           userInfo:nil
                                            repeats:YES];
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - 网络请求
-(void)updateProgress{
      //专辑图片旋转
    self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, M_PI / 1440);
    
    CMTime currentTime = [self.player currentTime];
    Float64 currentPlaybackTime = CMTimeGetSeconds(currentTime);
    if ((int)currentPlaybackTime == [self.songVO.length floatValue]) {
        [self nextBtnClick:nil];
    }
    
    int currentTimeMinutes = (unsigned)currentPlaybackTime/60;
    int currentTimeSeconds = (unsigned)currentPlaybackTime%60;
    
    NSMutableString *currentTimeString;
    if (currentTimeSeconds < 10) {
        currentTimeString = [NSMutableString stringWithFormat:@"%d:0%d",currentTimeMinutes,currentTimeSeconds];
    }
    else{
        currentTimeString = [NSMutableString stringWithFormat:@"%d:%d",currentTimeMinutes,currentTimeSeconds];
    }
    
    self.timeLabel.text = currentTimeString;
    self.totleTimeLabel.text = self.totleTimeStr;
    self.progressView.progress = currentPlaybackTime/[self.songVO.length intValue];
}

- (void)loadMusicData:(NSString *)type channel:(NSNumber *)channel{
    NSString *urlStr = [NSString stringWithFormat:@"http://douban.fm/j/mine/playlist?type=%@&sid=%@&pt=0.000000&channel=%@&from=mainsite", type, self.songVO.sid, channel];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        //解析数据
        NSDictionary *dict = responseObject;
        NSArray *songArray = [dict objectForKey:@"song"];
        if (songArray.count == 0) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"坏消息" message:@"接口出错了，或者没有更多歌曲了～" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"点击取消");
                [self.timer setFireDate:[NSDate date]];
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
            return ;
        }
        self.songVO = [ICESongVO objectWithKeyValues:songArray[0]];
        
        [self configSonginfo];
        [self playSong];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

#pragma mark - 交互
- (void)volumeslidervaluechange:(UISlider *)sender {
    _player.volume = sender.value;
}

- (void)myBtnAction:(UIButton *)sender {
    if (self.isPlaying) {
        [self pauseSong];
        [sender setTitle:@"开始" forState:UIControlStateNormal];
    } else {
        [self playSong];
        [sender setTitle:@"暂停" forState:UIControlStateNormal];
    }
}

- (void)nextBtnClick:(UIButton *)sender {
    [self.timer setFireDate:[NSDate distantFuture]];
    [self loadMusicData:@"s" channel:self.styleVO.id];
}

- (void)configSonginfo {
    //通过一个网络链接播放音乐
    self.imageView.transform = CGAffineTransformMakeRotation(0.0);
    NSURL *url = [NSURL URLWithString:self.songVO.url];
    AVPlayerItem *songItem = [[AVPlayerItem alloc] initWithURL:url];
    self.player = [[AVPlayer alloc] initWithPlayerItem:songItem];
    self.player.volume = INITVOLUME;

    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.songVO.picture]];
    self.songName.text = self.songVO.title;
    self.artistName.text = self.songVO.artist;;
    
    int totleTimeMinutes = (unsigned)[self.songVO.length intValue]/60;
    int totleTimeSeconds = (unsigned)[self.songVO.length intValue]%60;
    
    self.totleTimeStr = [NSString stringWithFormat:@"%2d:%02d", totleTimeMinutes, totleTimeSeconds];
    
    int index = arc4random() % 8;
    self.view.backgroundColor = [self colorWithHexString:(self.colorArray[index])];
}

- (void)playSong{
    [self.btn setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    [self.timer setFireDate:[NSDate date]];
    self.isPlaying = YES;
    [self.player play];
}

- (void)pauseSong {
    [self.btn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [self.timer setFireDate:[NSDate distantFuture]];
    self.isPlaying = NO;
    [self.player pause];
}

- (void)playNext {
    [self.timer setFireDate:[NSDate distantFuture]];
    [self.player replaceCurrentItemWithPlayerItem:self.songItemArray[self.index+1]];
}

#pragma mark - getter
- (UILabel *)titleLable {
    if (nil == _titleLable) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.textColor = [UIColor blackColor];
        _titleLable.font = [UIFont systemFontOfSize:25.0f];
        _titleLable.text = @"我的音乐";
    }
    return _titleLable;
}

- (UIImageView *)imageView {
    if (nil == _imageView) {
        _imageView = [[UIImageView alloc] init];
        CGRect rect = [UIScreen mainScreen].bounds;
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.borderWidth = 8;
        _imageView.layer.borderColor = [UIColor grayColor].CGColor;
        _imageView.layer.cornerRadius = (rect.size.width-60)/2.0;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (UIView *)backcornerView {
    if (nil == _backcornerView) {
        _backcornerView = [[UIView alloc] init];
        _backcornerView.backgroundColor = [UIColor whiteColor];
        _backcornerView.layer.borderWidth = 8;
        _backcornerView.layer.borderColor = [UIColor grayColor].CGColor;
        _backcornerView.layer.masksToBounds = YES;
        _backcornerView.layer.cornerRadius = 35;
    }
    return _backcornerView;
}

- (UILabel *)timeLabel {
    if (nil == _timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor blackColor];
        _timeLabel.font = [UIFont systemFontOfSize:10.0f];
    }
    return _timeLabel;
}

- (UILabel *)totleTimeLabel {
    if (nil == _totleTimeLabel) {
        _totleTimeLabel = [[UILabel alloc] init];
        _totleTimeLabel.textColor = [UIColor blackColor];
        _totleTimeLabel.font = [UIFont systemFontOfSize:10.0f];
    }
    return _totleTimeLabel;
}

- (UILabel *)songName {
    if (nil == _songName) {
        _songName = [[UILabel alloc] init];
        _songName.textColor = [UIColor blackColor];
        _songName.font = [UIFont systemFontOfSize:20.0f];
        _songName.numberOfLines = 0;
    }
    return _songName;
}

- (UILabel *)artistName {
    if (nil == _artistName) {
        _artistName = [[UILabel alloc] init];
        _artistName.textColor = [UIColor blackColor];
        _artistName.font = [UIFont systemFontOfSize:15.0f];
    }
    return _artistName;
}

- (UISlider *)volumeSlider {
    if (nil == _volumeSlider) {
        _volumeSlider = [[UISlider alloc] init];
        _volumeSlider.hidden = YES;
        _volumeSlider.value = INITVOLUME;
        [_volumeSlider addTarget:self action:@selector(volumeslidervaluechange:) forControlEvents:UIControlEventValueChanged];
    }
    return _volumeSlider;
}

- (UIProgressView *)progressView {
    if (nil == _progressView) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.tintColor = [UIColor purpleColor];
    }
    return _progressView;
}


-(UIButton *)btn {
    if (nil == _btn) {
        _btn = [[UIButton alloc] init];
        [_btn setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(myBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}

- (UIButton *)nextBtn {
    if (nil == _nextBtn) {
        _nextBtn = [[UIButton alloc] init];
        [_nextBtn setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

- (void)setStyleVO:(ICEStyleVO *)styleVO {
    _styleVO = styleVO;
    [self loadMusicData:@"n" channel:styleVO.id];
    self.titleLable.text = styleVO.name;
}


- (UIColor *)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

-(UIColor *)colorWithHexString:(NSString *)stringToConvert {
    NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return nil;
    return [self colorWithRGBHex:hexNum];
}

@end
