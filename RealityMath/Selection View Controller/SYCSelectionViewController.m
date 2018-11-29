//
//  SYCSelectionViewController.m
//  RealityMath
//
//  Created by 施昱丞 on 2018/11/29.
//  Copyright © 2018 Shi Yucheng. All rights reserved.
//

#import "SYCSelectionViewController.h"
#import "../SYCBaseViewController.h"
#import "SelectionCell.h"

@interface SYCSelectionViewController ()

@end

@implementation SYCSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[SelectionCell class] forCellReuseIdentifier:@"SelectionCell"];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor grayColor];
    
}

- (void)setUpTableView{
    
}


//Table view delegate method
- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
    if (!cell) {
        if (indexPath.row == 0) {
            cell = [[SelectionCell alloc] initWithModelName:@"圆柱面"];
        }else if (indexPath.row == 1){
            cell = [[SelectionCell alloc] initWithModelName:@"圆锥面"];
        }else{
            cell = [[SelectionCell alloc] initWithModelName:@"旋转双曲面"];
        }
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SYCBaseViewController *baseVC;
    switch (indexPath.row) {
        case 0:
            baseVC = [[SYCBaseViewController alloc] initWithModelName:@"圆柱面"];
            break;
            
        case 1:
            baseVC = [[SYCBaseViewController alloc] initWithModelName:@"圆锥面"];
            break;
            
        case 2:
            baseVC = [[SYCBaseViewController alloc] initWithModelName:@"旋转双曲面"];
            break;
            
        default:
            break;
    }
    [self presentViewController:baseVC animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
@end
