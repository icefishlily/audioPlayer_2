//
//  ICEChannelListController.m
//  audioPlayer_2
//
//  Created by jinhui005 on 16/9/9.
//  Copyright © 2016年 yhl. All rights reserved.
//

#import "ICEChannelListController.h"
#import "Masonry.h"
#import <AFNetworking/AFNetworking.h>
#import "ICEStyleVO.h"
#import <MJRefresh/MJRefresh.h>
#import "MJExtension.h"
#import "ICEPlayViewController.h"

@interface ICEChannelListController ()

@property (nonatomic, strong) NSMutableArray *upChannelArray;
@property (nonatomic, strong) NSMutableArray *hotChannelArray;
@property (nonatomic, strong) NSMutableArray *channelListArray;

@end

@implementation ICEChannelListController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.channelListArray = [NSMutableArray array];
    self.upChannelArray = [NSMutableArray array];
    self.hotChannelArray = [NSMutableArray array];
    self.channelListArray = [NSMutableArray arrayWithObjects:self.upChannelArray, self.hotChannelArray, nil];
    
    self.tableView.sectionHeaderHeight = 80;
    self.tableView.rowHeight = 60;
    self.tableView.userInteractionEnabled = YES;
    [self.tableView becomeFirstResponder];
    
    //用MJRefresh做下来刷新
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [self.tableView.header setTitle:@"往下拉可刷新哦" forState:MJRefreshHeaderStateIdle];
    [self.tableView.header setTitle:@"松开来就刷新啦" forState:MJRefreshHeaderStatePulling];
    [self.tableView.header setTitle:@"~~刷~~新~~中~~" forState:MJRefreshHeaderStateRefreshing];
    
    [self loadData];
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)loadData {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //up
    [manager GET:@"http://douban.fm/j/explore/up_trending_channels"
                                      parameters:nil
                                         success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                                             NSArray *channels = [ICEStyleVO objectArrayWithKeyValuesArray:[responseObject valueForKeyPath:@"data.channels"]];
                                             if (channels.count) {
                                                 [self.upChannelArray removeAllObjects];
                                                 [self.upChannelArray addObjectsFromArray:channels];
                                             }
                                             [self.tableView reloadData];
                                             [self.tableView.header endRefreshing];
                                         } failure:nil];
    
    //hot
    [manager GET:@"http://douban.fm/j/explore/hot_channels"
                                      parameters:nil
                                         success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                                             NSArray *channels = [ICEStyleVO objectArrayWithKeyValuesArray:[responseObject valueForKeyPath:@"data.channels"]];
                                             if (channels.count) {
                                                 [self.hotChannelArray removeAllObjects];
                                                 [self.hotChannelArray addObjectsFromArray:channels];
                                             }
                                             [self.tableView reloadData];
                                             [self.tableView.header endRefreshing];
                                         } failure:nil];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.channelListArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *list = self.channelListArray[section];
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"channelCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSArray *list = self.channelListArray[indexPath.section];
    NSDictionary *dict = list[indexPath.row];
    NSString *name = [dict valueForKey:@"name"];
    cell.textLabel.text = name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ICEStyleVO *vo = [[self.channelListArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [(self.tabBarController.viewControllers)[0] setStyleVO:vo];

    self.tabBarController.selectedIndex = 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [@[@"上升最快兆赫",@"热门兆赫"] objectAtIndex:section];
}

@end

