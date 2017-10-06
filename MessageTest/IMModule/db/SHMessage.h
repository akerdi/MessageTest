//
//  SHMessage.h
//  MessageTest
//
//  Created by shaohung on 2017/10/3.
//  Copyright © 2017年 shaohung. All rights reserved.
//

#import "XXBaseDB.h"

@interface SHMessage : XXBaseDB

/*!
 * 消息发送/接收方 id
 */
@property (nonatomic, copy, nullable) NSString *clientId;

/*!
 * 消息 id
 */
@property (nonatomic, copy, nullable) NSString *messageId;
/*!
 * 消息所属对话的 id
 */
@property (nonatomic, copy, nullable) NSString *conversationId;
/*!
 * 消息文本
 */
@property (nonatomic, copy, nullable) NSString *content;

/**
 * 消息是否发送成功
 */
@property (nonatomic, assign) BOOL delived;
/*!
 * 发送时间（精确到毫秒）
 */
@property (nonatomic, assign) int64_t sendTimestamp;
/*!
 * 接收时间（精确到毫秒）
 */
@property (nonatomic, assign) int64_t deliveredTimestamp;
/*!
 * 被标记为已读的时间（精确到毫秒）
 */
@property (nonatomic, assign) int64_t readTimestamp;
/*!
 The message update time.
 */
@property (nonatomic, strong) NSDate *updatedAt;

@end
