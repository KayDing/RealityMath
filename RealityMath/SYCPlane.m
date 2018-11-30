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

@property (nonatomic) CGFloat aspectRatio;
@property (nonatomic) CGSize preferredSize;

@end

@implementation SYCPlane{


}


- (instancetype)initWithAnchor:(ARPlaneAnchor *)anchor sceneView:(ARSCNView *)scene{
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
    material.diffuse.contents = [UIColor whiteColor];
    
//    material.diffuse.contents = [UIImage imageNamed:@"grid.png"];
//
//    vector_float3 vector;
//    vector.x = 40;
//    vector.y = 40 * _aspectRatio;
//    vector.z = 1;
//
//    simd_float4x4 textureScale;
//    textureScale.columns[0] = simd_make_float4(vector.x, 0, 0, 0);
//    textureScale.columns[1] = simd_make_float4(0, vector.y, 0, 0);
//    textureScale.columns[2] = simd_make_float4(0, 0, vector.z, 0);
//    textureScale.columns[3] = simd_make_float4(0, 0, 0, 1);
//
//    material.diffuse.contentsTransform = SCNMatrix4FromMat4(textureScale);
//
//
//    material.emission.contents = [UIImage imageNamed:@"grid.png"];
//    material.emission.contentsTransform = SCNMatrix4FromMat4(textureScale);
//    [material setDoubleSided:YES];
//    material.diffuse.wrapS = SCNWrapModeRepeat;
//    material.diffuse.wrapT = SCNWrapModeRepeat;
//    material.ambient.contents = [UIColor blackColor];
//    material.lightingModelName = SCNLightingModelConstant;
}

- (void)setUpExtentVisualStyle{
    self.extentNode.opacity = 0.6;
    SCNMaterial *material = self.extentNode.geometry.firstMaterial;
    material.diffuse.contents = [UIColor whiteColor];
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"wireframe_shader" ofType:@"metal" inDirectory:@"Assets.scnassets"];
    NSString *shader = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    material.shaderModifiers = @{SCNShaderModifierEntryPointSurface:shader};
}

- (CGSize)preferredSize{
    if (_preferredSize.width == 1.5 && _preferredSize.height == 2.7) {
        return _preferredSize;
    }
    return CGSizeMake(1.5, 2.7);
}

- (CGFloat)aspectRatio{
    if (_aspectRatio) {
        return _aspectRatio;
    }
    return _preferredSize.height / _preferredSize.width;
}
@end
