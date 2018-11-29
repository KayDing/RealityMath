//
//  SYCPlaneModel.m
//  RealityMath
//
//  Created by 施昱丞 on 2018/11/28.
//  Copyright © 2018 Shi Yucheng. All rights reserved.
//

#import "SYCPlaneModel.h"

@implementation SYCPlaneModel

+ (SYCPlaneModel *)shardInstance{
    static SYCPlaneModel *model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[SYCPlaneModel alloc] init];
    });
    return model;
}

@end
