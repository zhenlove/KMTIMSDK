//
//  KMChatController.h
//  Pods-KMTIMSDK_Example
//
//  Created by Ed on 2019/10/21.
//

#import <UIKit/UIKit.h>

//#import "TIMConversation.h"

NS_ASSUME_NONNULL_BEGIN
@class TIMConversation;
@interface KMChatController : UIViewController


/**
 *  初始化函数。
 *  根据所选会话初始化当前界面。
 *  初始化内容包括对资源图标的加载、历史消息的恢复，以及 MessageController、InputController 和“更多”视图的相关初始化操作。
 *
 *  @param conversation 会话，提供初始化所需的会话信息
 */
- (instancetype)initWithConversation:(TIMConversation *)conversation;



@end

NS_ASSUME_NONNULL_END
