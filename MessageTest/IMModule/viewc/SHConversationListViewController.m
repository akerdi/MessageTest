//
//  SHConversationListViewController.m
//  MessageTest
//
//  Created by shaohung on 2017/10/3.
//  Copyright © 2017年 shaohung. All rights reserved.
//

#import "SHConversationListViewController.h"
#import "SHChatViewController.h"

#import "SHIMManager.h"

#import <ReactiveObjC.h>
#import "LxDBAnything.h"

@interface SHConversationListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SHConversationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor greenColor];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    @weakify(self);
    [RACObserve([SHIMManager sharedInstanced], conversationList) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addConversation:)];
}

-(void)addConversation:(id)sender{
    LxDBAnyVar(sender);
    [[SHIMManager sharedInstanced] createConversationWithConversationName:@"我爱你宝贝" withMembers:@[@"littleShuai"] callback:^(id a, NSError *error) {
        if (!error) {
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[SHIMManager sharedInstanced].conversationList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    SHConversation *conversation = [SHIMManager sharedInstanced].conversationList[indexPath.row];
    cell.textLabel.text = conversation.name;
    cell.detailTextLabel.text = [conversation.members componentsJoinedByString:@"、"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SHConversation *conversation = [SHIMManager sharedInstanced].conversationList[indexPath.row];
    @weakify(self);
    [[SHIMManager sharedInstanced] chatControllerCurrentConversationWithConversationId:@"" callBack:^(id conversation, NSError *error) {
        @strongify(self);
        SHChatViewController *chatControlelr = [[SHChatViewController alloc]init];
        [self.navigationController pushViewController:chatControlelr animated:YES];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
