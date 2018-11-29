//
//  SYCPlane.h
//  RealityMath
//
//  Created by 施昱丞 on 2018/11/27.
//  Copyright © 2018 Shi Yucheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ARKit/ARKit.h>

#define PLANECOLOR [UIColor grayColor]

NS_ASSUME_NONNULL_BEGIN

@interface SYCPlane : SCNNode


@property (nonatomic, strong) SCNNode *meshNode;
@property (nonatomic, strong) SCNNode *extentNode;
@property (nonatomic, strong) SCNNode *classficationNode;

- (instancetype)initWithAnchor:(ARPlaneAnchor *)anchor sceneView:(ARSCNView *)scene;

@end

NS_ASSUME_NONNULL_END
