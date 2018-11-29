//
//  SelectionCell.m
//  RealityMath
//
//  Created by 施昱丞 on 2018/11/29.
//  Copyright © 2018 Shi Yucheng. All rights reserved.
//

#import "SelectionCell.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@implementation SelectionCell{
    UIView *bgView;
    UILabel *titleLabel;
    UIImageView *imageView;
}

- (instancetype)initWithModelName:(NSString *)modelName{
    self = [super init];
    if (self) {
        CGFloat labelHeight = 100 * 0.5;
        CGFloat labelWidth = SCREEN_WIDTH * 0.5;
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.25, (100 - labelHeight) * 0.5, labelWidth, labelHeight)];
        titleLabel.text = modelName;
        
        CGFloat imageHeight = 100 * 0.8;
        CGFloat imageWidth = imageHeight;
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.6, (100 - imageWidth) * 0.5, imageWidth, imageHeight)];
        imageView.image = [UIImage imageNamed:modelName];
        
        CGFloat bgHeight = 100 * 0.9;
        CGFloat bgWidth = SCREEN_WIDTH * 0.95;
        bgView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - bgWidth) * 0.5, (100 - bgHeight) * 0.5, bgWidth, bgHeight)];
        [bgView.layer setCornerRadius:25.0];
        [bgView.layer setMasksToBounds:YES];
        bgView.backgroundColor = [UIColor redColor];

    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:bgView];
    [self addSubview:titleLabel];
    [self addSubview:imageView];
}


@end
