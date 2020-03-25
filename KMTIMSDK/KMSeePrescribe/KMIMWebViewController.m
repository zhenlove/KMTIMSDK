//
//  KMIMWebViewController.m
//  KMTIMSDK
//
//  Created by Ed on 2020/3/24.
//

#import "KMIMWebViewController.h"
#import <WebKit/WebKit.h>
#import <Masonry/Masonry.h>
@import KMNetwork;
#import "KMHeader.h"
@interface KMIMWebViewController ()
@property (nonatomic,strong) WKWebView * webView;
@property (nonatomic,strong) NSURLRequest * request;
@property (nonatomic,strong) CALayer *progressLayer;
@property (nonatomic,strong) UIView *progress;
@end

@implementation KMIMWebViewController
-(WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc]init];
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _webView;
}
-(NSURLRequest *)request {
    if (!_request) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.prescribeUrl]];
        NSMutableURLRequest *mutableRequest = [request mutableCopy];
        [mutableRequest addValue:[KMServiceModel sharedInstance].apptoken forHTTPHeaderField:@"apptoken"];
        [mutableRequest addValue:[KMServiceModel sharedInstance].noncestr forHTTPHeaderField:@"noncestr"];
        [mutableRequest addValue:[KMServiceModel sharedInstance].usertoken forHTTPHeaderField:@"usertoken"];
        [mutableRequest addValue:[KMServiceModel sharedInstance].sign forHTTPHeaderField:@"sign"];
        _request = [mutableRequest copy];
    }
    return _request;
}
-(UIView *)progress {
    if (!_progress) {
        _progress = [[UIView alloc]init];
        _progress.backgroundColor = [UIColor  clearColor];
    }
    return _progress;
}
-(CALayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [CALayer layer];
        _progressLayer.frame = CGRectMake(0, 0, 0, 3);
        _progressLayer.backgroundColor = UIColorFromRGB(0x007AFF).CGColor;
    }
    return _progressLayer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"处方详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progress];
    [self.progress.layer addSublayer:self.progressLayer];
    

    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        #if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.right.bottom.equalTo(self.view);
        #else
            make.edges.equalTo(self.view);
        #endif
        
    }];
    

    [self.progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.webView);
        make.width.equalTo(self.view.mas_width);
        make.height.mas_equalTo(3);
    }];
    
    [self.webView loadRequest:self.request];
}
#pragma mark - KVO回馈
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
        if ([keyPath isEqualToString:@"estimatedProgress"]) {
            self.progressLayer.opacity = 1;
            if ([change[@"new"] floatValue] <[change[@"old"] floatValue]) {
                return;
            }
            
            self.progressLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width*[change[@"new"] floatValue], 3);
            if ([change[@"new"]floatValue] == 1.0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.progressLayer.opacity = 0;
                    self.progressLayer.frame = CGRectMake(0, 0, 0, 3);
                });
            }
        }else if ([keyPath isEqualToString:@"title"]){
            self.title = change[@"new"];
        }
}
@end
