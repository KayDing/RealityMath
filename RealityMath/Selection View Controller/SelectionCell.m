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

@interface SelectionCell()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *image;
@property(nonatomic, strong) NSString *modelName;

@end

@implementation SelectionCell{



}

- (instancetype)initWithModelName:(NSString *)name{
    self = [super init];
    if (self) {
        self.modelName = name;
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.bgView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.imageView];
}

- (UIView *)bgView{
    if (_bgView) {
        return _bgView;
    }
    CGFloat bgHeight = 100 * 0.9;
    CGFloat bgWidth = SCREEN_WIDTH * 0.95;
    _bgView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - bgWidth) * 0.5, (100 - bgHeight) * 0.5, bgWidth, bgHeight)];
    [_bgView.layer setCornerRadius:25.0];
    [_bgView.layer setMasksToBounds:YES];
    _bgView.backgroundColor = [UIColor redColor];
    return _bgView;
}

- (UILabel *)titleLabel{
    if (_titleLabel) {
        return _titleLabel;
    }
    CGFloat labelHeight = 100 * 0.5;
    CGFloat labelWidth = SCREEN_WIDTH * 0.5;
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.25, (100 - labelHeight) * 0.5, labelWidth, labelHeight)];
    _titleLabel.text = _modelName;
    return _titleLabel;
}

- (UIImageView *)imageView{
    if (_image) {
        return _image;
    }
    CGFloat imageHeight = 100 * 0.8;
    CGFloat imageWidth = imageHeight;
    _image = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.6, (100 - imageWidth) * 0.5, imageWidth, imageHeight)];
    _image.image = [UIImage imageNamed:_modelName];
    return _image;
}
@end
