//
//  KMChatController.m
//  Pods-KMTIMSDK_Example
//
//  Created by Ed on 2019/10/21.
//

#import "KMChatController.h"
#import <MobileCoreServices/MobileCoreServices.h>

#import <ImSDK/ImSDK.h>
#import <TXIMSDK_TUIKit_iOS/TUIKit.h>
#import <TXIMSDK_TUIKit_iOS/THelper.h>
#import <TXIMSDK_TUIKit_iOS/TUIImageMessageCellData.h>

#import <ReactiveObjC/ReactiveObjC.h>




@interface KMChatController ()<TMessageControllerDelegate, TInputControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) TIMConversation *conversation;
/**
 *  TUIKit 聊天消息控制器
 *  负责消息气泡的展示，同时负责响应用户对于消息气泡的交互，比如：点击消息发送者头像、轻点消息、长按消息等操作。
 *  聊天消息控制器的详细信息请参考 Section\Chat\TUIMessageController.h
 */
@property TUIMessageController *messageController;

/**
 *  TUIKit 信息输入控制器。
 *  负责接收用户输入，同时显示“+”按钮与语音输入按钮、表情按钮等。
 *  同时 TUIInputController 整合了消息的发送功能，您可以直接使用 TUIInputController 进行消息的输入采集与发送。
 *  信息输入控制器的详细信息请参考 Section\Chat\Input\TUIInputController.h
 */
@property TUIInputController *inputController;




/**
 *  更多菜单视图数据的数据组
 *  更多菜单视图包括：拍摄、图片、视频、文件。详细信息请参考 Section\Chat\TUIMoreView.h
 */
@property NSArray<TUIInputMoreCellData *> *moreMenus;
@end

@implementation KMChatController

- (instancetype)initWithConversation:(TIMConversation *)conversation;
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _conversation = conversation;

        NSMutableArray *moreMenus = [NSMutableArray array];
        [moreMenus addObject:[TUIInputMoreCellData photoData]];
        [moreMenus addObject:[TUIInputMoreCellData pictureData]];
        _moreMenus = moreMenus;


    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    // Do any additional setup after loading the view.
}

- (void)willMoveToParentViewController:(UIViewController *)parent
{
    if (parent == nil) {
        [self saveDraft];
    }
}
- (void)setupViews
{
    self.view.backgroundColor = [UIColor whiteColor];

    @weakify(self)
    //message
    _messageController = [[TUIMessageController alloc] init];
    _messageController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - TTextView_Height - Bottom_SafeHeight);
    _messageController.delegate = self;
    [self addChildViewController:_messageController];
    [self.view addSubview:_messageController.view];
    [_messageController setConversation:_conversation];

    //input
    _inputController = [[TUIInputController alloc] init];
    _inputController.view.frame = CGRectMake(0, self.view.frame.size.height - TTextView_Height - Bottom_SafeHeight, self.view.frame.size.width, TTextView_Height + Bottom_SafeHeight);
    _inputController.view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _inputController.delegate = self;
    [RACObserve(self, moreMenus) subscribeNext:^(NSArray *x) {
        @strongify(self)
        [self.inputController.moreView setData:x];
    }];
    [self addChildViewController:_inputController];
    [self.view addSubview:_inputController.view];

    TIMMessageDraft *draft = [self.conversation getDraft];
    if(draft){
        for (int i = 0; i < draft.elemCount; ++i) {
            TIMElem *elem = [draft getElem:i];
            if([elem isKindOfClass:[TIMTextElem class]]){
                TIMTextElem *text = (TIMTextElem *)elem;
                _inputController.inputBar.inputTextView.text = text.text;
                [self.conversation setDraft:nil];
                break;
            }
        }
    }
}

- (void)inputController:(TUIInputController *)inputController didChangeHeight:(CGFloat)height
{
    __weak typeof(self) ws = self;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect msgFrame = ws.messageController.view.frame;
        msgFrame.size.height = ws.view.frame.size.height - height;
        ws.messageController.view.frame = msgFrame;

        CGRect inputFrame = ws.inputController.view.frame;
        inputFrame.origin.y = msgFrame.origin.y + msgFrame.size.height;
        inputFrame.size.height = height;
        ws.inputController.view.frame = inputFrame;

        [ws.messageController scrollToBottom:NO];
    } completion:nil];
}
/// 发送新消息时的回调
- (void)inputController:(TUIInputController *)inputController didSendMessage:(TUIMessageCellData *)msg
{
    [_messageController sendMessage:msg];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(chatController:didSendMessage:)]) {
//        [self.delegate chatController:self didSendMessage:msg];
//    }
}

- (void)sendMessage:(TUIMessageCellData *)message
{
    [_messageController sendMessage:message];
}

- (void)saveDraft
{
    NSString *draft = self.inputController.inputBar.inputTextView.text;
    draft = [draft stringByTrimmingCharactersInSet: NSCharacterSet.whitespaceAndNewlineCharacterSet];
    if (draft.length) {
        TIMMessageDraft *msg = [TIMMessageDraft new];
        TIMTextElem *text = [TIMTextElem new];
        [text setText:draft];
        [msg addElem:text];
        [self.conversation setDraft:msg];
    } else {
        [self.conversation setDraft:nil];
    }
}

/// 点击某一“更多”单元的回调委托。
- (void)inputController:(TUIInputController *)inputController didSelectMoreCell:(TUIInputMoreCell *)cell
{
    if (cell.data == [TUIInputMoreCellData photoData]) {
        [self selectPhotoForSend];
    }
    if (cell.data == [TUIInputMoreCellData pictureData]) {
        [self takePictureForSend];
    }
//    if(_delegate && [_delegate respondsToSelector:@selector(chatController:onSelectMoreCell:)]){
//        [_delegate chatController:self onSelectMoreCell:cell];
//    }
}

- (void)didTapInMessageController:(TUIMessageController *)controller
{
    [_inputController reset];
}

- (BOOL)messageController:(TUIMessageController *)controller willShowMenuInCell:(TUIMessageCell *)cell
{
    if([_inputController.inputBar.inputTextView isFirstResponder]){
        _inputController.inputBar.inputTextView.overrideNextResponder = cell;
        return YES;
    }
    return NO;
}
/// 接收新消息时的回调，用于甄别自定义消息
- (TUIMessageCellData *)messageController:(TUIMessageController *)controller onNewMessage:(TIMMessage *)data
{
//    if ([self.delegate respondsToSelector:@selector(chatController:onNewMessage:)]) {
//        return [self.delegate chatController:self onNewMessage:data];
//    }
    return nil;
}
/// 展示自定义个性化消息
- (TUIMessageCell *)messageController:(TUIMessageController *)controller onShowMessageData:(TUIMessageCellData *)data
{
//    if ([self.delegate respondsToSelector:@selector(chatController:onShowMessageData:)]) {
//        return [self.delegate chatController:self onShowMessageData:data];
//    }
    return nil;
}
/// 点击消息头像回调
- (void)messageController:(TUIMessageController *)controller onSelectMessageAvatar:(TUIMessageCell *)cell
{
    if (cell.messageData.identifier == nil)
        return;

//    if ([self.delegate respondsToSelector:@selector(chatController:onSelectMessageAvatar:)]) {
//        [self.delegate chatController:self onSelectMessageAvatar:cell];
//        return;
//    }
}
/// 点击消息内容回调
- (void)messageController:(TUIMessageController *)controller onSelectMessageContent:(TUIMessageCell *)cell
{
//    if ([self.delegate respondsToSelector:@selector(chatController:onSelectMessageContent:)]) {
//        [self.delegate chatController:self onSelectMessageContent:cell];
//        return;
//    }
}


- (void)didHideMenuInMessageController:(TUIMessageController *)controller
{
    _inputController.inputBar.inputTextView.overrideNextResponder = nil;
}

// ----------------------------------
- (void)selectPhotoForSend
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)takePictureForSend
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.cameraCaptureMode =UIImagePickerControllerCameraCaptureModePhoto;
    picker.delegate = self;

    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 快速点的时候会回调多次
    @weakify(self)
    picker.delegate = nil;
    [picker dismissViewControllerAnimated:YES completion:^{
        @strongify(self)
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        if([mediaType isEqualToString:(NSString *)kUTTypeImage]){
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            UIImageOrientation imageOrientation = image.imageOrientation;
            if(imageOrientation != UIImageOrientationUp)
            {
                CGFloat aspectRatio = MIN ( 1920 / image.size.width, 1920 / image.size.height );
                CGFloat aspectWidth = image.size.width * aspectRatio;
                CGFloat aspectHeight = image.size.height * aspectRatio;

                UIGraphicsBeginImageContext(CGSizeMake(aspectWidth, aspectHeight));
                [image drawInRect:CGRectMake(0, 0, aspectWidth, aspectHeight)];
                image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }

            NSData *data = UIImageJPEGRepresentation(image, 0.75);
            NSString *path = [TUIKit_Image_Path stringByAppendingString:[THelper genImageName:nil]];
            [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
            
            TUIImageMessageCellData *uiImage = [[TUIImageMessageCellData alloc] initWithDirection:MsgDirectionOutgoing];
            uiImage.path = path;
            uiImage.length = data.length;
            [self sendMessage:uiImage];
            }
        }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}



@end
