//
//  KMRoomStateListener.m
//  KMTIMSDK
//
//  Created by Ed on 2020/3/16.
//

#import "KMRoomStateListener.h"
#import <TXIMSDK_TUIKit_iOS/THeader.h>
#import <ImSDK/ImSDK.h>
@implementation KMRoomStateListener
+ (instancetype)sharedInstance
{
    static KMRoomStateListener *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[KMRoomStateListener alloc] init];
    });
    return instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNewMessage:) name:TUIKitNotification_TIMMessageListener object:nil];
    }
    return self;
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TUIKitNotification_TIMMessageListener object:nil];
}

- (void)onNewMessage:(NSNotification *)notification
{
    NSArray *msgs = notification.object;
    for (TIMMessage *msg in msgs) {
        for (int i = 0; i < msg.elemCount; ++i) {
            TIMElem *elem = [msg getElem:i];
            if ([elem isKindOfClass:[TIMCustomElem class]]) {
                TIMCustomElem * customElem = (TIMCustomElem *)elem;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:customElem.data  options:NSJSONReadingMutableContainers error:nil];
                if ([customElem.ext isEqualToString:@"Room.StateChanged"]) {
                    NSLog(@"房间状态  %@",dic);
                    if (self.delegate && [self.delegate respondsToSelector:@selector(listenerToChannelID:withRoomState:)]) {
                        [self.delegate listenerToChannelID:[dic[@"ChannelID"] stringValue] withRoomState:[dic[@"State"] integerValue]];
                    }
                }
            }
        }
    }
}

@end
