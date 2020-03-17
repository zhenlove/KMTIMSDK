//
//  KMRoomStateListener.h
//  KMTIMSDK
//
//  Created by Ed on 2020/3/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, KMRoomState) {
    KMRoomState_Invalid = -1,//状态无效
    KMRoomState_NoVisit = 0,//未就诊
    KMRoomState_Waiting = 1,//候诊中
    KMRoomState_Consulting = 2,//就诊中
    KMRoomState_Consulted = 3,//已就诊
    KMRoomState_Calling = 4,//呼叫中
    KMRoomState_Leaving = 5,//离开中
    KMRoomState_PatientsLeaving = 6//患者离开
};

@protocol KMRoomStateListenerDelegate <NSObject>

- (void)listenerToChannelID:(NSString *)channelID withRoomState:(KMRoomState)state;

@end

@interface KMRoomStateListener : NSObject

@property (nonatomic, weak) id <KMRoomStateListenerDelegate> delegate;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
