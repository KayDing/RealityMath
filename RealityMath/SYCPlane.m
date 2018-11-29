//
//  SYCPlane.m
//  RealityMath
//
//  Created by 施昱丞 on 2018/11/27.
//  Copyright © 2018 Shi Yucheng. All rights reserved.
//

#import "SYCPlane.h"
#import <SceneKit/SceneKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SYCPlane()

@end

@implementation SYCPlane


- (instancetype)initWithAnchor:(ARPlaneAnchor *)anchor sceneView:(ARSCNView *)scene
{
    self = [super init];
    if (self) {
        ARSCNPlaneGeometry *meshGeometry = [ARSCNPlaneGeometry planeGeometryWithDevice:scene.device];
        [meshGeometry updateFromPlaneGeometry:anchor.geometry];
        self.meshNode = [SCNNode nodeWithGeometry:meshGeometry];
        
        SCNPlane *extentPlane = [SCNPlane planeWithWidth:anchor.extent.x height:anchor.extent.z];
        self.extentNode = [SCNNode nodeWithGeometry:extentPlane];
        [self.extentNode setSimdPosition:anchor.center];
        
        [self.extentNode setEulerAngles:SCNVector3Make(-3.1415926 / 2, 0, 0)];;
    }
    
    [self setUpMeshVisualStyle];
    [self setUpExtentVisualStyle];
    
    [self addChildNode:self.meshNode];
    [self addChildNode:self.extentNode];
    return self;
}

- (void)setUpMeshVisualStyle{
    self.meshNode.opacity = 0.25;
    SCNMaterial *material = self.meshNode.geometry.firstMaterial;
    material.diffuse.contents = [UIColor blueColor];
}

- (void)setUpExtentVisualStyle{
    self.extentNode.opacity = 0.6;
    SCNMaterial *material = self.extentNode.geometry.firstMaterial;
    material.diffuse.contents = [UIColor blueColor];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"wireframe_shader" ofType:@"metal" inDirectory:@"Assets.scnassets"];
    NSString *shader = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    material.shaderModifiers = @{SCNShaderModifierEntryPointSurface:shader};
}
@end
