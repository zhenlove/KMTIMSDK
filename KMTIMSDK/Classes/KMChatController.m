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

#import "KMURLMessageCellData.h"
#import "KMURLMessageCell.h"
#import "KMPatientInfoMessageCell.h"
#import "KMPatientInfoMessageCellData.h"

#import "KMPatientInfoVC.h"

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

- (instancetype)init
{
    self = [super init];
    if (self) {
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
    
    self.conversation = [[TIMManager sharedInstance] getConversation:TIM_GROUP receiver:self.convId];
    self.title = self.imTitle;

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
//    return nil;
    TIMElem *elem = [data getElem:0];
    if([elem isKindOfClass:[TIMCustomElem class]]){
        TIMCustomElem * customElem = (TIMCustomElem *)elem;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:customElem.data  options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"自定义消息类型：%@",customElem.ext);
        if ([customElem.ext isEqualToString:@"User.DiseaseDesc"]) { //病情描述
            KMPatientInfoMessageCellData * cellData = [[KMPatientInfoMessageCellData alloc]initWithDirection:data.isSelf ? MsgDirectionOutgoing : MsgDirectionIncoming];
            cellData.memberName = dic[@"MemberName"];
            cellData.age = dic[@"Age"];
            cellData.gender = [dic[@"Gender"] boolValue] ? @"女":@"男";
            cellData.consultContent = dic[@"ConsultContent"];
            cellData.userFile = dic[@"UserFiles"];
            return cellData;
//            KMURLMessageCellData *cellData = [[KMURLMessageCellData alloc] initWithDirection:data.isSelf ? MsgDirectionOutgoing : MsgDirectionIncoming];
//            cellData.text = @"查看详情>>";
//            cellData.link = @"https://cloud.tencent.com/product/im";
//            return cellData;
        }
        if ([customElem.ext isEqualToString:@"Room.DurationChanged"]) { //房间持续时间变更
            
        }
        if ([customElem.ext isEqualToString:@"Room.StateChanged"]) { //房间状态
            
        }
        if ([customElem.ext isEqualToString:@"AIMed.Recommend"]) { //推荐
            
        }
        if ([customElem.ext isEqualToString:@"Notice"]) { //通知
            
        }
        if ([customElem.ext isEqualToString:@"Order.Buy.Recipe"] || [customElem.ext isEqualToString:@"Diagnose.Summary.Submit"]) { //购买处方
            
        }
        if ([customElem.ext isEqualToString:@"Recipe.Preview"]) { //处方预览
            
        }
        if ([customElem.ext isEqualToString:@"User.TransferTreatment"]) { //当前看诊医生已离线请稍候
            
        }
        if ([customElem.ext isEqualToString:@"Room.Hangup"]) { //挂断
            
        }
        
    }
    return nil;
}
/// 展示自定义个性化消息
- (TUIMessageCell *)messageController:(TUIMessageController *)controller onShowMessageData:(TUIMessageCellData *)data
{
//    if ([self.delegate respondsToSelector:@selector(chatController:onShowMessageData:)]) {
//        return [self.delegate chatController:self onShowMessageData:data];
//    }
//    return nil;
    if ([data isKindOfClass:[KMPatientInfoMessageCellData class]]) {
        KMPatientInfoMessageCell * cell = [[KMPatientInfoMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KMPatientInfoMessageCell"];
        [cell fillWithData:data];
        return cell;
    }
    
//    if ([data isKindOfClass:[KMURLMessageCellData class]]) {
//        KMURLMessageCell *myCell = [[KMURLMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCell"];
//        [myCell fillWithData:(KMURLMessageCellData *)data];
//        return myCell;
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
    if ([cell isKindOfClass:[KMPatientInfoMessageCell class]]) {
        KMPatientInfoMessageCellData * cellData = (KMPatientInfoMessageCellData *)cell.messageData;
        KMPatientInfoVC * infoVC  = [[KMPatientInfoVC alloc] init];
        infoVC.patientName = cellData.memberName;
        infoVC.age = cellData.age;
        infoVC.sex = cellData.gender;
        infoVC.desc = cellData.consultContent;
        infoVC.pictureArray = cellData.userFile;
        infoVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:infoVC animated:YES];
    }
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
