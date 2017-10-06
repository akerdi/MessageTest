//
//  SHIMManager.m
//  MessageTest
//
//  Created by shaohung on 2017/10/3.
//  Copyright © 2017年 shaohung. All rights reserved.
//

#import "SHIMManager.h"

#import <AVOSCloudIM.h>
#import <ReactiveObjC.h>
#import "LxDBAnything.h"


@interface SHIMManager ()<AVIMClientDelegate>

@property (nonatomic, strong) AVIMClient *client;
@property (nonatomic, strong) AVIMConversation *currentConversation;
@property (nonatomic, strong) NSArray *conversationList;

@end

@implementation SHIMManager

+(instancetype)sharedInstanced{
    static SHIMManager *immanger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        immanger = [SHIMManager new];
    });
    return immanger;
}


-(instancetype)init{
    if (self=[super init]) {
        self.client = [[AVIMClient alloc]initWithClientId:@"111"];
        self.client.delegate = self;
        [self.client openWithCallback:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                [self fetchConversationList];
            }
            
//            [self.client createConversationWithName:@"hahaha" clientIds:@[@"littleShuai"] callback:^(AVIMConversation * _Nullable conversation, NSError * _Nullable error) {
//                NSLog(@"%@",conversation);
//                if (!error) {
//                    AVIMMessage *message = [AVIMMessage messageWithContent:@"今晚可以回家吗"];
//                    
//                    [conversation sendMessage:message callback:^(BOOL succeeded, NSError * _Nullable error) {
//                        NSLog(@"%@",succeeded?@"message send YES":@"message send NO");
//                    }];
//                }
//            }];
        }];
    }
    return self;
}

#pragma mark

- (void)conversation:(AVIMConversation *)conversation didReceiveCommonMessage:(AVIMMessage *)message{
    [self translateConversation:conversation];
    
    SHMessage *localMessage = [self translateMessage:message];
    localMessage.delived = YES;
    localMessage.clientId = message.clientId;
    localMessage.readTimestamp = message.readTimestamp;
    localMessage.updatedAt = message.updatedAt;
    localMessage.sendTimestamp = message.sendTimestamp;
    [localMessage saveToDB];
    
    if (self.currentConversation) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNewMessageSendToConversation object:localMessage];
    }
    
    NSLog(@"%@",message);
}
- (void)conversation:(AVIMConversation *)conversation messageDelivered:(AVIMMessage *)message{
    NSString *queryStr = [NSString stringWithFormat:@"messageId = '%@'",message.messageId];
    SHMessage *localMessage = [SHMessage searchSingleWithWhere:queryStr orderBy:nil];
    if (!localMessage) {
        return;
    }
    localMessage.delived = YES;
    [localMessage updateToDB];
#pragma mark TODO
    //reload UI
}
#pragma mark - Conversation func

-(void)createConversationWithConversationName:(NSString *)conversationName withMembers:(NSArray *)members callback:(void(^)(id,id))block{
//    self.client conversationForId:
    @weakify(self);
    [self.client createConversationWithName:conversationName clientIds:members attributes:nil options:AVIMConversationOptionUnique callback:^(AVIMConversation * _Nullable conversation, NSError * _Nullable error) {
        @strongify(self);
        self.currentConversation = conversation;
        if (!error) {
            [self translateConversation:conversation];
        }
        block(conversation,error);
    }];
}

-(void)translateConversation:(AVIMConversation *)conversation{
    SHConversation *localConversation = [SHConversation new];
    localConversation.clientId = conversation.clientId;
    localConversation.conversationId = conversation.conversationId;
    localConversation.creator = conversation.creator;
    localConversation.createAt = conversation.createAt;
    localConversation.updateAt = conversation.updateAt;
    localConversation.lastMessageAt = conversation.lastMessageAt;
    localConversation.lastReadAt = conversation.lastReadAt;
    localConversation.lastDeliveredAt = conversation.lastDeliveredAt;
    localConversation.name = conversation.name;
    localConversation.members = conversation.members;
    if (![localConversation saveToDB]) {
        [localConversation updateToDB];
    }else{
        [self fetchConversationList];
    }
}

-(void)fetchConversationList{
    self.conversationList = [SHConversation searchWithWhere:nil orderBy:@"createAt" offset:0 count:0];
}

-(void)chatControllerCurrentConversationWithConversationId:(NSString *)conversationId callBack:(void(^)(id,id))block{
    [self.client createConversationWithName:@"我爱你宝贝" clientIds:@[@"littleShuai"] attributes:nil options:AVIMConversationOptionUnique callback:^(AVIMConversation * _Nullable conversation, NSError * _Nullable error) {
        if (!error) {
            self.currentConversation = conversation;
        }
        block(conversation,error);
    }];
}

-(void)removeChatControllerCurrentConversation{
    self.currentConversation = nil;
}

#pragma mark - messages

-(void)sendMessage:(NSString *)content callback:(void(^)(id))block{
    AVIMMessage *sendMessage = [AVIMMessage messageWithContent:content];
    [self.currentConversation sendMessage:sendMessage callback:^(BOOL succeeded, NSError * _Nullable error) {
        if (!error) {
            SHMessage *localMessage = [self translateMessage:sendMessage];
            localMessage.clientId = sendMessage.clientId;
            localMessage.delived = NO;
            localMessage.readTimestamp = sendMessage.readTimestamp;
            localMessage.updatedAt = sendMessage.updatedAt;
            localMessage.sendTimestamp = sendMessage.sendTimestamp;
            [localMessage saveToDB];
            block(localMessage);
        }else{
            block(error);
        }
    }];
}

-(SHMessage *)translateMessage:(AVIMMessage *)sendMessage{
    SHMessage *localMessage = [SHMessage new];
    localMessage.conversationId = self.currentConversation.conversationId;
    localMessage.messageId = sendMessage.messageId;
    localMessage.content = sendMessage.content;
    [localMessage saveToDB];
    return localMessage;
}

@end
