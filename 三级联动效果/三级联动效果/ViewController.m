//
//  ViewController.m
//  三级联动效果
//
//  Created by appdev on 16/4/20.
//  Copyright © 2016年 appdev. All rights reserved.
//

#import "ViewController.h"
#import "ZLAssociationMenuView.h"
@interface ViewController ()<ZLAssociationMenuViewDelegate>

@property (nonatomic, strong)ZLAssociationMenuView *v;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.v = [ZLAssociationMenuView new];
    self.v.delegate = self;

}
- (IBAction)testClick:(UIButton *)sender {
    
    [self.v showAsDrawDownView:sender];
    
}

- (NSInteger)assciationMenuView:(ZLAssociationMenuView *)asView countForClass:(NSInteger)idx
{
    NSLog(@"choose %ld",idx);
    if (idx == 0) {
        return 5;
    }else if (idx == 1){
        return 10;
    }else if (idx == 2){
        return 15;
    }
    return 1;
}

- (NSString *)assciationMenuView:(ZLAssociationMenuView *)asView titleForClass_1:(NSInteger)idx_1
{
    NSLog(@"title %ld",idx_1);
    return [NSString stringWithFormat:@"title %ld",idx_1];
}

- (NSString *)assciationMenuView:(ZLAssociationMenuView *)asView titleForClass_1:(NSInteger)idx_1 class_2:(NSInteger)idx_2
{
    NSLog(@"title %ld, %ld",idx_1,idx_2);
    return [NSString stringWithFormat:@"title %ld,%ld",idx_1,idx_2];
}

- (NSString *)assciationMenuView:(ZLAssociationMenuView *)asView titleForClass_1:(NSInteger)idx_1 class_2:(NSInteger)idx_2 class_3:(NSInteger)idx_3
{
    NSLog(@"title %ld, %ld,%ld",idx_1,idx_2,idx_3);
    return [NSString stringWithFormat:@"title %ld,%ld,%ld",idx_1,idx_2,idx_3];
}

- (void)assciationMenuView:(ZLAssociationMenuView *)asView finalSelectedResult:(NSString *)result
{
    NSLog(@"%@",result);
}

@end
