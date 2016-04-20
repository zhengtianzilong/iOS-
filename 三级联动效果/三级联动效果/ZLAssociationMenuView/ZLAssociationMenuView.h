//
//  ZLAssociationMenuView.h
//  三级联动效果
//
//  Created by appdev on 16/4/20.
//  Copyright © 2016年 appdev. All rights reserved.
//

#import <UIKit/UIKit.h>
// 获取屏幕宽度
#define KScreenWidth     [UIScreen mainScreen].bounds.size.width
// 获取屏幕高度
#define KScreenHeight    [UIScreen mainScreen].bounds.size.height

@class ZLAssociationMenuView;

@protocol ZLAssociationMenuViewDelegate <NSObject>

@required
/**
 *  获取第class级菜单的数据数量
 *
 *  @param asView 联动菜单
 *  @param idx    第几级
 *
 *  @return 返回该级菜单的数据数量
 */
- (NSInteger)assciationMenuView:(ZLAssociationMenuView *)asView countForClass:(NSInteger)idx;

/**
 *  获取第一级菜单选项的title
 *
 *  @param asView 联动菜单
 *  @param idx_1  第一级
 *
 *  @return 返回标题
 */
- (NSString *)assciationMenuView:(ZLAssociationMenuView *)asView titleForClass_1:(NSInteger)idx_1;

/**
 *  获取第二级菜单选项的title
 *
 *  @param asView 联动菜单
 *  @param idx_1  第一级
 *  @param idx_2  第二级
 *
 *  @return 返回标题
 */
- (NSString *)assciationMenuView:(ZLAssociationMenuView *)asView titleForClass_1:(NSInteger)idx_1 class_2:(NSInteger)idx_2;

/**
 *  获取第三级菜单选项的title
 *
 *  @param asView 联动菜单
 *  @param idx_1  第一级
 *  @param idx_2  第二级
 *  @param idx_3  第三级
 *
 *  @return 返回标题
 */
- (NSString *)assciationMenuView:(ZLAssociationMenuView *)asView titleForClass_1:(NSInteger)idx_1 class_2:(NSInteger)idx_2 class_3:(NSInteger)idx_3;

@optional
/**
 *  取消选择
 */
- (void)assciationMenuViewCancel;

/**
 *  选择第一级菜单
 *
 *  @param asView 联动菜单
 *  @param idx_1  第一级
 *
 *  @return 是否展示下一级
 */
- (BOOL)assciationMenuView:(ZLAssociationMenuView *)asView idxChooseInClass1:(NSInteger)idx_1;

/**
 *  选择第二级菜单
 *
 *  @param asView 联动菜单
 *  @param idx_1  第一级菜单
 *  @param idx_2  第二级菜单
 *
 *  @return 是否展示下一级
 */
- (BOOL)assciationMenuView:(ZLAssociationMenuView *)asView idxChooseInClass1:(NSInteger)idx_1 idxChooseInClass2:(NSInteger)idx_2;

/**
 *  选择第三级菜单
 *
 *  @param asView 联动菜单
 *  @param idx_1  第一级
 *  @param idx2   第二级
 *  @param idx_3  第三级
 *
 *  @return 是否消失(三级菜单全选完了,就应该保留数据并且消失了)
 */
- (BOOL)assciationMenuView:(ZLAssociationMenuView *)asView idxChooseInClass1:(NSInteger)idx_1
         idxChooseInClass2:(NSInteger)idx2 idxChooseInClass3:(NSInteger)idx_3;

// 返回最终被选择的结果
- (void)assciationMenuView:(ZLAssociationMenuView *)asView finalSelectedResult:(NSString *)result;

@end

@interface ZLAssociationMenuView : UIView{
    
    // 表示数组元素类型为NSInteger
    NSInteger sels[3];
    
    
}
extern __strong NSString *const IDENTIFIER;

@property (nonatomic, weak) id<ZLAssociationMenuViewDelegate>delegate;

/**
 *  设置选中项, -1为未被选中
 *
 *  @param idx_1 第一级选中项
 *  @param idx_2 第二级选中项
 *  @param idx_3 第三级选中项
 */
- (void)setSelectIndexForClass1:(NSInteger)idx_1 class2:(NSInteger)idx_2 class3:(NSInteger)idx_3;

/**
 *  菜单显示在view的下面
 *
 *  @param view 显示在该view下
 */
- (void)showAsDrawDownView:(UIView *)view;

/**
 *  隐藏菜单
 */
- (void)dismiss;



@end
