//
//  SHConversation.h
//  MessageTest
//
//  Created by shaohung on 2017/10/3.
//  Copyright © 2017年 shaohung. All rights reserved.
//

#import "XXBaseDB.h"

@interface SHConversation : XXBaseDB

@property (nonatomic, copy, nullable) NSString       *clientId;
@property (nonatomic, copy, nullable) NSString       *conversationId;
@property (nonatomic, copy, nullable) NSString       *creator;
@property (nonatomic, strong, nullable) NSDate       *createAt;
@property (nonatomic, strong, nullable) NSDate       *updateAt;
//@property (nonatomic, strong, readonly, nullable) AVIMMessage  *lastMessage;
@property (nonatomic, strong, nullable) NSDate       *lastMessageAt;
@property (nonatomic, strong, nullable) NSDate       *lastReadAt;
@property (nonatomic, strong, nullable) NSDate       *lastDeliveredAt;
@property (nonatomic, copy, nullable) NSString     *name;
@property (nonatomic, strong, nullable) NSArray      *members;

@end
