//
//  ICESongVO.h
//  audioPlayer_2
//
//  Created by jinhui005 on 16/9/8.
//  Copyright © 2016年 yhl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICESongVO : NSObject
@property (nonatomic, strong) NSNumber *status;         //状态？
@property (nonatomic, strong) NSString *picture;
@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) NSString *url;            //歌曲地址
@property (nonatomic, strong) NSString *title;          //歌曲名称
@property (nonatomic, strong) NSNumber *length;         //歌曲长度 秒
@property (nonatomic, strong) NSDictionary *singers;    //歌手信息
@property (nonatomic, strong) NSString *file_ext;       //歌曲格式
@property (nonatomic, strong) NSString *kbps;
@property (nonatomic, strong) NSString *albumtitle;     //专辑名称
@property (nonatomic, strong) NSString *sid;

@end




//{“r":0,
//    “is_show_quick_start":0,
//    “song":[
//    {
//        “album":"\/subject\/1467166\/",
//        “status":0,"
//        picture”:"https://img1.doubanio.com\/lpic\/s1486187.jpg",
//        “ssid":"42fa",
//        “artist":"徐若瑄",
//        “url":"http:\/\/mr1.doubanio.com\/09a09bc0e4f6071ba206bfe506869472\/0\/fm\/song\/p34470_128k.mp4",
//        “title":"欧兜迈",
//        “length":221,
//        “release":{"link":"https:\/\/douban.fm\/album\/1467166g57d1","id":"1467166","ssid":"57d1"},
//        “like":0,"
//        update_time”:1470125584,
//        “subtype":"",
//        “public_time":"2005",
//        “sid":"34470","
//        singers”:[{"name":"徐若瑄","name_usual":"徐若瑄","avatar":"https://img1.doubanio.com\/img\/fmadmin\/small\/31418.jpg","related_site_id":0,"is_site_artist":false,"id":"6791"}],
//        “aid":"1467166",
//        “file_ext":"mp4",
//        “sha256":"81f048940b7df17a39d55aafaf0aa4248a010f65d8be077de54170d43454cc06",
//        “kbps":"128",
//        “albumtitle”:"狠狠爱",
//        “alert_msg”:""
//    }
//    ]
//}