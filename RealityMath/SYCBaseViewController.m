//
//  SYCBaseViewController.m
//  RealityMath
//
//  Created by 施昱丞 on 2018/11/27.
//  Copyright © 2018 Shi Yucheng. All rights reserved.
//

#import "SYCBaseViewController.h"
#import "SYCPlane.h"
#import "SYCPlaneModel.h"
#import "MultipeerSession.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface SYCBaseViewController () <ARSCNViewDelegate, ARSessionDelegate, UIGestureRecognizerDelegate, MultipeerSessionDelegate>

//信息显示窗口
@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong) UILabel *infoLabel;

//Scene场景
@property (nonatomic, strong) ARSCNView *sceneView;

//Session和Configutation
@property (nonatomic, strong) ARSession *session;
@property (nonatomic, strong) ARWorldTrackingConfiguration *configuration;

//联机相关
@property (retain, nonatomic) MultipeerSession *multipeerSession;
@property (strong, nonatomic) MCPeerID *mapProvider;
@property (strong, nonatomic) UIButton *sendMapButton;//分享按钮

@property (nonatomic, strong) UIButton *backButton;

@end




@implementation SYCBaseViewController{
    NSString *modelName;
    bool isDisplayed;
}

//重载init方法，使得调用模型的名字作为参数
- (instancetype)initWithModelName:(NSString *)name
{
    self = [super init];
    if (self) {
        modelName = name;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化
    NSData *data = [[NSData alloc] init];
    self.multipeerSession = [MultipeerSession MultipeerSessionWithReceivedData:data fromPeer:self.mapProvider];
    self.multipeerSession.delegate = self;
}

//初始化UI
- (void)setupUI{
    [self.view addSubview:self.sendMapButton];
    [self.view addSubview:self.infoView];
    [self.view addSubview:self.infoLabel];
    [self.view addSubview:self.backButton];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.configuration = [ARWorldTrackingConfiguration new];
    self.configuration.planeDetection = ARPlaneDetectionHorizontal;
    self.configuration.lightEstimationEnabled = YES;
    
    self.sceneView = [[ARSCNView alloc] initWithFrame:self.view.frame];
    self.sceneView.delegate = self;
    self.sceneView.showsStatistics = NO;
    self.sceneView.autoenablesDefaultLighting = YES;
    [self.view addSubview:self.sceneView];

    UIApplication.sharedApplication.idleTimerDisabled = YES;
    
    self.session = [ARSession new];
    self.session.delegate = self;
    [self.session runWithConfiguration:self.configuration];
    self.sceneView.session = self.session;
    
    [self setupUI];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.sceneView pause:nil];
}


#pragma mark - ARSCNViewDelegate
//添加节点时调用
- (void)renderer:(id<SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor{
    NSLog(@"%i", isDisplayed);
    if (isDisplayed) {
        return;
    }
    
    if ([anchor isMemberOfClass:[ARPlaneAnchor class]]) {
        [SYCPlaneModel shardInstance].anchor = (ARPlaneAnchor *)anchor;
        SYCPlane *plane = [[SYCPlane alloc] initWithAnchor:(ARPlaneAnchor *)anchor sceneView:self.sceneView];
        [node addChildNode:plane];
        SCNScene *modelScene = [SCNScene sceneNamed:[NSString stringWithFormat:@"Assets.scnassets/%@.scn", modelName]];
        SCNNode *modelNode = modelScene.rootNode.childNodes[0];
        modelNode.position = SCNVector3Make([SYCPlaneModel shardInstance].anchor.center.x, 0, [SYCPlaneModel shardInstance].anchor.center.z);
        
        modelNode.light.type = SCNLightTypeOmni;
        [node addChildNode:modelNode];
        isDisplayed = YES;
    }
}

//更新节点时调用
- (void)renderer:(id<SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor{

    if ([anchor isKindOfClass:[ARPlaneAnchor class]]) {
        if (![node.childNodes.firstObject isKindOfClass:[SYCPlane class]]) {
            return;
        }
    }
    SYCPlane *plane = (SYCPlane *)node.childNodes.firstObject;
    ARPlaneAnchor *planeAnchor = (ARPlaneAnchor *)anchor;
    ARSCNPlaneGeometry *planeGeometry = (ARSCNPlaneGeometry *)plane.meshNode.geometry;
    [planeGeometry updateFromPlaneGeometry:planeAnchor.geometry];
    
    SCNPlane *extentGeometry = (SCNPlane *)plane.extentNode.geometry;
    [extentGeometry setWidth:planeAnchor.extent.x];
    [extentGeometry setHeight:planeAnchor.extent.z];
    [plane.extentNode setSimdPosition:planeAnchor.center];
    
    SCNNode *lightNode = [[SCNNode alloc] init];
    lightNode.light.attenuationStartDistance = 20.0;
    lightNode.light.attenuationEndDistance = 1.0;
}

//更新信息Label
- (void)updateInfoLabel:(ARFrame *)frame andState: (ARTrackingState)trackingstate{
    NSString *stateMessage = @"";
    if (trackingstate == ARTrackingStateNormal && frame.anchors == NULL) {
        stateMessage = @"请移动设备以查找水平平面";
    }else if (trackingstate == ARTrackingStateNotAvailable){
        stateMessage = @"不支持当前设备";
    }else if (trackingstate == ARTrackingStateReasonExcessiveMotion){
        stateMessage = @"请缓慢移动设备";
    }else if (trackingstate == ARTrackingStateReasonInitializing){
        stateMessage = @"初始化AR会话中";
    }else if (trackingstate == ARTrackingStateReasonInsufficientFeatures){
        stateMessage = @"请在有明显特征的平面上移动设备";
    }
    
    self.infoLabel.text = stateMessage;
}

- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame{
    [self updateInfoLabel:frame andState:frame.camera.trackingState];
}

//MultipeerSessionDelegate -- 接收到附近设备的数据后调用
- (void)receivedData:(NSData *)data fromPeers:(MCPeerID *)peer{
    ARWorldMap *worldMap = [NSKeyedUnarchiver unarchivedObjectOfClass: [ARWorldMap class] fromData:data error:nil];
    if (worldMap) {
        self.configuration.planeDetection = ARPlaneDetectionHorizontal;
        self.configuration.initialWorldMap = worldMap;
        [self.sceneView.session runWithConfiguration:self.configuration options:ARSessionRunOptionResetTracking | ARSessionRunOptionRemoveExistingAnchors];
        self.mapProvider = peer;
    }
    ARAnchor *anchor = [NSKeyedUnarchiver unarchivedObjectOfClass:[ARAnchor class] fromData:data error:nil];
    if (anchor) {
        [self.sceneView.session addAnchor: anchor];
    }
    else
        NSLog(@"unknown data recieved from %@",peer);
    
}


- (void)session:(ARSession *)session didFailWithError:(NSError *)error {
        // Present an error message to the user
    self.infoLabel.text = [NSString stringWithFormat:@"Session failed: %@",error.localizedDescription];
    [self resetTracking:nil];
}

    //置于后台了调用
- (void)sessionWasInterrupted:(ARSession *)session {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
    self.infoLabel.text = @"Session was interrupted";
}

- (void)sessionInterruptionEnded:(ARSession *)session {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
    self.infoLabel.text = @"Session interruption ended";
}

- (BOOL)sessionShouldAttemptRelocalization:(ARSession *)session{
    return YES;
}
    //分享按钮调用方法
- (void)shareSession:(UIButton *)btn{
    [self.sceneView.session getCurrentWorldMapWithCompletionHandler:^(ARWorldMap * _Nullable worldMap, NSError * _Nullable error) {
        ARWorldMap *map = worldMap;
        if (!map) {
            NSLog(@"error:%@",error.description);
            return ;
        }
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:map requiringSecureCoding:YES error:nil];
        if (!data) {
            return ;
        }
        [self.multipeerSession sendToAllPeers:data];
    }];
}

    //重置按钮调用
- (void)resetTracking:(UIButton *)btn{
    ARWorldTrackingConfiguration *configuration = [[ARWorldTrackingConfiguration alloc] init];
    configuration.planeDetection = ARPlaneDetectionHorizontal;
    [self.sceneView.session runWithConfiguration:configuration options: ARSessionRunOptionRemoveExistingAnchors|ARSessionRunOptionResetTracking];
}

#pragma mark - 懒加载

- (UIButton *)sendMapButton{
    if (!_sendMapButton) {
        _sendMapButton = [[UIButton alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT - 80, 50, 50)];
        [_sendMapButton setTitle:@"send world map" forState: UIControlStateNormal];
        [_sendMapButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        [_sendMapButton setImage:[UIImage imageNamed:@"shareDefault"] forState:UIControlStateHighlighted];
        [_sendMapButton addTarget:self action:@selector(shareSession:) forControlEvents:UIControlEventTouchDown];
    }
    return _sendMapButton;
}

- (UIView *)infoView{
    if (!_infoView) {
        CGFloat infoWidth = SCREEN_WIDTH * 0.8;
        CGFloat infoHeight = SCREEN_HEIGHT * 0.1;
        _infoView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - infoWidth) / 2, SCREEN_HEIGHT * 0.8, infoWidth, infoHeight)];
        [_infoView setBackgroundColor:[UIColor whiteColor]];
        [_infoView setAlpha:0.5];
        _infoView.layer.cornerRadius = 8.0;
        _infoView.layer.masksToBounds = YES;
    }
    
    return _infoView;
}

- (UILabel *)infoLabel{
    if (!_infoLabel) {
        self.infoLabel = [[UILabel alloc] initWithFrame:self.infoView.frame];
        self.infoLabel.textColor = [UIColor blackColor];
        self.infoLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _infoLabel;
}

- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 50, 50)];
        [_backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _backButton;
}

- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
