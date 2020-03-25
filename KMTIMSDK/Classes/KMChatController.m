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
#import <TXIMSDK_TUIKit_iOS/TUISystemMessageCellData.h>

#import "KMPrescribeMessageCellData.h"
#import "KMPrescribeMessageCell.h"

#import "KMPatientInfoMessageCellData.h"
#import "KMPatientInfoMessageCell.h"

#import "KMHeader.h"
#import "UIViewController+BackHandler.h"

@interface KMChatController ()<TMessageControllerDelegate, TInputControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UINavigationBarDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) TIMConversation *conversation;
@property (nonatomic, strong) TUIMessageController *messageController;
@property (nonatomic, strong) TUIInputController *inputController;
@property (nonatomic, strong) NSArray<TUIInputMoreCellData *> *moreMenus;
@end

@implementation KMChatController


-(NSArray<TUIInputMoreCellData *> *)moreMenus {
    if (!_moreMenus) {
        _moreMenus = @[[TUIInputMoreCellData photoData],[TUIInputMoreCellData pictureData]];
    }
    return _moreMenus;
}


-(TIMConversation *)conversation {
    if (!_conversation) {
        _conversation = [[TIMManager sharedInstance] getConversation:TIM_GROUP receiver:self.convId];
    }
    return _conversation;
}
-(TUIMessageController *)messageController {
    if (!_messageController) {
        _messageController = [[TUIMessageController alloc] init];
        _messageController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - TTextView_Height - Bottom_SafeHeight);
        _messageController.delegate = self;
        [self addChildViewController:_messageController];
        [_messageController setConversation:self.conversation];
    }
    return _messageController;
}
-(TUIInputController *)inputController {
    if (!_inputController) {
        _inputController = [[TUIInputController alloc] init];
        _inputController.view.frame = CGRectMake(0, self.view.frame.size.height - TTextView_Height - Bottom_SafeHeight, self.view.frame.size.width, TTextView_Height + Bottom_SafeHeight);
        _inputController.view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        _inputController.delegate = self;
        [_inputController.moreView setData:self.moreMenus];
        [self addChildViewController:_inputController];
    }
    return _inputController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}
-(BOOL)navigationShouldPopOnBackButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickeBackBtnController)]) {
        return [self.delegate clickeBackBtnController];
    }
    return YES;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = [self.navigationController topViewController];
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.navigationController.interactivePopGestureRecognizer) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickeBackBtnController)]) {
            return [self.delegate clickeBackBtnController];
        }
        return YES;
    }
    return YES;
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

    [self.view addSubview:self.messageController.view];
    [self.view addSubview:self.inputController.view];


    TIMMessageDraft *draft = [self.conversation getDraft];
    if(draft){
        for (int i = 0; i < draft.elemCount; ++i) {
            TIMElem *elem = [draft getElem:i];
            if([elem isKindOfClass:[TIMTextElem class]]){
                TIMTextElem *text = (TIMTextElem *)elem;
                self.inputController.inputBar.inputTextView.text = text.text;
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

    TIMElem *elem = [data getElem:0];
    if([elem isKindOfClass:[TIMCustomElem class]]){
        TIMCustomElem * customElem = (TIMCustomElem *)elem;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:customElem.data  options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"自定义消息类型：%@",customElem.ext);
        if ([customElem.ext isEqualToString:@"User.DiseaseDesc"]) { //病情描述
            KMPatientInfoMessageCellData * cellData = [[KMPatientInfoMessageCellData alloc]initWithDirection:data.isSelf ? MsgDirectionOutgoing : MsgDirectionIncoming];
            NSMutableDictionary *muDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
            [muDic setValue:[[TIMFriendshipManager sharedInstance] queryUserProfile:data.sender].faceURL forKey:@"UserImage"];
            cellData.userInfoDic = muDic;
            cellData.avatarUrl = [NSURL URLWithString:[[TIMFriendshipManager sharedInstance] queryUserProfile:data.sender].faceURL];
            return cellData;

        }
        if ([customElem.ext isEqualToString:@"Room.DurationChanged"]) { //房间持续时间变更
            TUISystemMessageCellData * cellData = [[TUISystemMessageCellData alloc]initWithDirection:data.isSelf ? MsgDirectionOutgoing : MsgDirectionIncoming];
            cellData.content = customElem.desc;
            return cellData;
        }
        if ([customElem.ext isEqualToString:@"Room.StateChanged"]) { //房间状态
            
        }
        if ([customElem.ext isEqualToString:@"AIMed.Recommend"]) { //推荐
            
        }
        if ([customElem.ext isEqualToString:@"Notice"]) { //通知
            TUISystemMessageCellData * cellData = [[TUISystemMessageCellData alloc]initWithDirection:data.isSelf ? MsgDirectionOutgoing : MsgDirectionIncoming];
            cellData.content = customElem.desc;
            return cellData;
        }
        if ([customElem.ext isEqualToString:@"Diagnose.Summary.Submit"] || [customElem.ext isEqualToString:@"Order.Buy.Recipe"]) { //购买处方
            NSArray * customArr = (NSArray *)dic;
            KMPrescribeMessageCellData *cellData = [[KMPrescribeMessageCellData alloc] initWithDirection:data.isSelf ? MsgDirectionOutgoing : MsgDirectionIncoming];
            cellData.recipeImgUrl = customArr[0][@"RecipeImgUrl"];
            cellData.OPDRegisterID = customArr[0][@"OPDRegisterID"];
            return cellData;
            
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
    if ([data isKindOfClass:[KMPatientInfoMessageCellData class]]) {
        KMPatientInfoMessageCell * cell = [[KMPatientInfoMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KMPatientInfoMessageCell"];
        [cell fillWithData:data];
        return cell;
    }
    
    if ([data isKindOfClass:[KMPrescribeMessageCellData class]]) {
        KMPrescribeMessageCell * cell = [[KMPrescribeMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KMPrescribeMessageCell"];
        [cell fillWithData:(KMPrescribeMessageCellData *)data];
        return cell;
    }
    return nil;
}
/// 点击消息内容回调
- (void)messageController:(TUIMessageController *)controller onSelectMessageContent:(TUIMessageCell *)cell
{

    if ([cell isKindOfClass:[KMPatientInfoMessageCell class]]) {
        KMPatientInfoMessageCellData * cellData = (KMPatientInfoMessageCellData *)cell.messageData;
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickePatientInfo:)]) {
            [self.delegate clickePatientInfo:cellData.userInfoDic];
        }

    }
    if ([cell isKindOfClass:[KMPrescribeMessageCell class]]) {
        KMPrescribeMessageCellData * cellData = (KMPrescribeMessageCellData *)cell.messageData;
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickePrescribe:oPDRegisterID:)]) {
            [self.delegate clickePrescribe:cellData.recipeImgUrl oPDRegisterID:cellData.OPDRegisterID];
        }
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
//    @weakify(self)
    __weak typeof(self)weakSelf = self;
    picker.delegate = nil;
    [picker dismissViewControllerAnimated:YES completion:^{
//        @strongify(self)
        __strong typeof(weakSelf)strongSelf = weakSelf;
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
            [strongSelf sendMessage:uiImage];
            }
        }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}



@end
