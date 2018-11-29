//
//  SYCPlaneModel.h
//  RealityMath
//
//  Created by 施昱丞 on 2018/11/28.
//  Copyright © 2018 Shi Yucheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ARKit/ARKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYCPlaneModel : NSObject

@property(nonatomic, strong) ARPlaneAnchor *anchor;

+ (SYCPlaneModel *)shardInstance;

@end

NS_ASSUME_NONNULL_END
