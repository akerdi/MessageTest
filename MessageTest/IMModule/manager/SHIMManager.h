//
//  SHIMManager.h
//  MessageTest
//
//  Created by shaohung on 2017/10/3.
//  Copyright © 2017年 shaohung. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SHConversation.h"
#import "SHMessage.h"

static NSString  * const kNewMessageSendToConversation = @"kNewMessageSendToConversation";

@interface SHIMManager : NSObject

@property (nonatomic, strong, readonly) NSArray *conversationList;

+(instancetype)sharedInstanced;

-(void)createConversationWithConversationName:(NSString *)conversationName withMembers:(NSArray *)members callback:(void(^)(id,id))block;

-(void)chatControllerCurrentConversationWithConversationId:(NSString *)conversationId callBack:(void(^)(id,id))block;
-(void)removeChatControllerCurrentConversation;

-(void)sendMessage:(NSString *)content callback:(void(^)(id))block;
@end
