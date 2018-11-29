//
//  SelectionCell.h
//  RealityMath
//
//  Created by 施昱丞 on 2018/11/29.
//  Copyright © 2018 Shi Yucheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectionCell : UITableViewCell

@property(nonatomic, strong) NSString *modelName;

- (instancetype)initWithModelName:(NSString *)modelName;

@end

NS_ASSUME_NONNULL_END
