//
//  SHChatViewController.m
//  MessageTest
//
//  Created by shaohung on 2017/10/3.
//  Copyright © 2017年 shaohung. All rights reserved.
//

#import "SHChatViewController.h"

#import "SHIMManager.h"

#import <ReactiveObjC.h>

@interface SHChatViewController ()

@property (nonatomic, strong) UITextView *messageTextView;

@property (nonatomic, strong) UITextField *textField;

@end

@implementation SHChatViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[SHIMManager sharedInstanced] removeChatControllerCurrentConversation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.view.backgroundColor = [UIColor cyanColor];
    
    CGRect selfRect = self.view.frame;
    
    self.messageTextView = [UITextView new];
    self.messageTextView.frame = CGRectMake(0, 0, selfRect.size.width, 300);
    [self.view addSubview:self.messageTextView];
    
    UITextField *textField = [[UITextField alloc]init];
    textField.frame = CGRectMake(0, 300, selfRect.size.width-55, 64);
    [self.view addSubview:textField];
    self.textField = textField;
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
    sendButton.frame = CGRectMake(selfRect.size.width-55, 300, 55, 64);
    sendButton.backgroundColor = [UIColor yellowColor];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kNewMessageSendToConversation object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        SHMessage *localMessage = x.object;
        if (localMessage&&[localMessage isKindOfClass:[SHMessage class]]) {
            [self.messageTextView insertText:@"\n"];
            [self.messageTextView insertText:[localMessage.clientId stringByAppendingString:@":"]];
            [self.messageTextView insertText:@"\n"];
            [self.messageTextView insertText:localMessage.content];
        }
    }];
}

-(void)sendMessage:(UIButton *)sender{
    if (_textField.text.length) {
        [[SHIMManager sharedInstanced] sendMessage:self.textField.text callback:^(id result) {
            if ([result isKindOfClass:[NSError class]]) {
                NSLog(@"错误啦，消息");
            }else{
                SHMessage *localMessage = (SHMessage *)result;
                [self.messageTextView insertText:@"\n"];
                [self.messageTextView insertText:[localMessage.clientId stringByAppendingString:@":"]];
                [self.messageTextView insertText:@"\n"];
                [self.messageTextView insertText:localMessage.content];
                self.textField.text = @"";
            }
        }];
        
        
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
