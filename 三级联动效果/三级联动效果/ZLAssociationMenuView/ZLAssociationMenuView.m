//
//  ZLAssociationMenuView.m
//  三级联动效果
//
//  Created by appdev on 16/4/20.
//  Copyright © 2016年 appdev. All rights reserved.
//

#import "ZLAssociationMenuView.h"

NSString *const IDENTIFIER = @"CELL";
@interface ZLAssociationMenuView ()<UITableViewDataSource, UITableViewDelegate>
{
    
    NSArray *tables;
    UIView *bgView;
    
}
@end

@implementation ZLAssociationMenuView

- (instancetype)init
{
    if (self = [super init]) {
        // 初始化选择项
        for (int i = 0; i != 3; ++i) {
            // 初始化的时候都是-1也就是没有选中
            sels[i] = -1;
            
        }
        self.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        self.userInteractionEnabled = YES;
        // 取消按钮(只要点击菜单四周空白处,都可以取消选择器)
        UIButton *cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        cancelBtn.frame = self.frame;
        [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:cancelBtn];
        
        // 初始化菜单(三个tableView放到数组中)
        tables = @[ [[UITableView alloc]init],[[UITableView alloc]init],[[UITableView alloc]init] ];
        // 遍历数组
        [tables enumerateObjectsUsingBlock:^(UITableView *table, NSUInteger idx, BOOL *stop) {
            [table registerClass:[UITableViewCell class] forCellReuseIdentifier:IDENTIFIER];
            table.delegate = self;
            table.dataSource = self;
            table.frame = CGRectMake(0, 0, 0, 0);
            table.backgroundColor = [UIColor clearColor];
            table.tableFooterView = [UIView new];
        }];
        // 背景
        bgView = [[UIView alloc]init];
        bgView.backgroundColor = [UIColor colorWithRed:.1f green:.0f blue:.0f alpha:.3f];
        bgView.userInteractionEnabled = YES;
        [bgView addSubview:[tables objectAtIndex:0]];
    }
    
    return self;
}

/**
 *  调整表视图的位置,大小
 */
- (void)adjustTableViews
{
    int w = KScreenWidth;
    int __block showTableCount = 0;
    // 遍历数组
    [tables enumerateObjectsUsingBlock:^(UITableView *  t, NSUInteger idx, BOOL * _Nonnull stop) {
        // 主要是调整tableView的高度
        CGRect rect = t.frame;
        rect.size.height = KScreenHeight - bgView.frame.origin.y;
        t.frame = rect;
        if (t.superview) {
            ++showTableCount;
        }
    }];
    
    for (int i = 0; i != showTableCount; ++i) {
        // 调整tableView的宽度和x
        UITableView *t = [tables objectAtIndex:i];
        CGRect f = t.frame;
        f.size.width = w / showTableCount;
        f.origin.x = f.size.width * i;
        t.frame = f;
    }
}

/**
 *  取消选择
 */
- (void)cancel
{
    [self dismiss];
    if ([self.delegate respondsToSelector:@selector(assciationMenuViewCancel)]) {
        
        [self.delegate assciationMenuViewCancel];
        
    }
}

- (void)setSelectIndexForClass1:(NSInteger)idx_1 class2:(NSInteger)idx_2 class3:(NSInteger)idx_3
{
    sels[0] = idx_1;
    sels[1] = idx_2;
    sels[2] = idx_3;
}

/**
 *  保存table选中项
 */
- (void)saveSels
{
    [tables enumerateObjectsUsingBlock:^(UITableView *t, NSUInteger idx, BOOL * _Nonnull stop) {
        // 如果tableView有父视图,则保存选中的行数,如果没有父视图,则保存-1
        sels[idx] = t.superview ? t.indexPathForSelectedRow.row : -1;

    }];
    
    
}

// 加载选中的行数
- (void)loadSels
{
    [tables enumerateObjectsUsingBlock:^(UITableView  *t, NSUInteger idx, BOOL * _Nonnull stop) {
        // 选中tableView的行数(-1代表没有选中)
        [t selectRowAtIndexPath:[NSIndexPath indexPathForRow:sels[idx] inSection:0] animated:NO scrollPosition:(UITableViewScrollPositionNone)];
        // 如果数组里的数不等于-1(说明有选中),并且tableView不存在父视图,那么就讲tableView添加到bgView上
        if ((sels[idx] != -1 && !t.superview) || !idx) {
            
            [bgView addSubview:t];
            
        }
        
        
    }];
}
// 展示界面
- (void)showAsDrawDownView:(UIView *)view
{
    CGRect showFrame = view.frame;
    CGFloat x = 0.f;
    CGFloat y = showFrame.origin.y + showFrame.size.height;
    CGFloat w = KScreenWidth;
    CGFloat h = KScreenHeight - y;
    bgView.frame = CGRectMake(x, y, w, h);
    // 如果bgView不存在父视图
    if (!bgView.superview) {
        // 添加
        [self addSubview:bgView];
    }
    // 先加载选中的行数
    [self loadSels];
    // 调整tableView
    [self adjustTableViews];
    // 如果本身视图不存在父视图的话
    if (!self.superview) {
        // 将其添加到window上
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        self.alpha = .0f;
        // 用动画效果让其出来
        [UIView animateWithDuration:.25f animations:^{
            
            self.alpha = 1.0f;
            
        }];
    }
    // 放在最顶部
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:self];
    
    
    
}

// 消失
- (void)dismiss
{
    // 如果有父视图的话
    if (self.superview) {
        
        [UIView animateWithDuration:.25f animations:^{
            // 隐藏
            self.alpha = .0f;
        } completion:^(BOOL finished) {
            
            // 完成之后,将子视图全部移除
            [bgView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                [obj removeFromSuperview];
            }];
            // 自己也移除
            [self removeFromSuperview];
        }];
    }
}

#pragma mark --- tableView的代理及数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger __block count;
    [tables enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj == tableView) {
            //代理传出去,由外部确定其个数
            count = [_delegate assciationMenuView:self countForClass:idx];
            
            *stop = YES;
        }
    }];
    
    return count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 不同的tableView对应不同的不同的cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER];
    if (tableView == [tables objectAtIndex:0]) {
        
        cell.textLabel.text = [_delegate assciationMenuView:self titleForClass_1:indexPath.row];
        
    }else if (tableView == [tables objectAtIndex:1]){
        
        cell.textLabel.text = [_delegate assciationMenuView:self titleForClass_1:((UITableView *)tables[0]).indexPathForSelectedRow.row  class_2:indexPath.row];
    }else if (tableView == [tables objectAtIndex:2]){
        
        cell.textLabel.text = [_delegate assciationMenuView:self titleForClass_1:((UITableView *)tables[0]).indexPathForSelectedRow.row class_2:((UITableView *)tables[1]).indexPathForSelectedRow.row class_3:indexPath.row];
    }
    
    return cell;
}

// tableView选中时的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取出tableView
    UITableView *t0 = [tables objectAtIndex:0];
    UITableView *t1 = [tables objectAtIndex:1];
    UITableView *t2 = [tables objectAtIndex:2];
    // 默认是有下一级菜单的
    BOOL isNextClass = true;
    if (tableView == t0) {
        
        if ([self.delegate respondsToSelector:@selector(assciationMenuView:idxChooseInClass1:)]) {
            isNextClass = [_delegate assciationMenuView:self idxChooseInClass1:indexPath.row];
        }
        // 如果有下一级数据
        if (isNextClass) {
            // 刷新下一级菜单的数据
            [t1 reloadData];

            if (!t1.superview) {
                [bgView addSubview:t1];
            }
            if (t2.superview) {
                [t2 removeFromSuperview];
            }
            [self adjustTableViews];
        }else{
            // 如果没有下一级菜单,则应该把t1和t2全部删除
            if (t1.superview) {
                
                [t1 removeFromSuperview];
                
            }
            if (t2.superview) {
                
                [t2 removeFromSuperview];
            }
            [self saveSels];
            [self dismiss];
            
        }
    }else if (tableView == t1){
        if ([self.delegate respondsToSelector:@selector(assciationMenuView:idxChooseInClass1:idxChooseInClass2:)]) {
            
            isNextClass = [_delegate assciationMenuView:self idxChooseInClass1:t0.indexPathForSelectedRow.row idxChooseInClass2:indexPath.row];
        }
        if (isNextClass) {
            [t2 reloadData];
            if (!t2.superview) {
                
                [bgView addSubview:t2];
            }
            [self adjustTableViews];
        }else{
            if (t2.superview) {
                
                [t2 removeFromSuperview];
            }
            [self saveSels];
            [self dismiss];
        }
 
    }else if (tableView == t2){
        
        if ([self.delegate respondsToSelector:@selector(assciationMenuView:idxChooseInClass1:idxChooseInClass2:idxChooseInClass3:)]) {
            
            isNextClass = [_delegate assciationMenuView:self idxChooseInClass1:t0.indexPathForSelectedRow.row idxChooseInClass2:t1.indexPathForSelectedRow.row idxChooseInClass3:indexPath.row];
        }
        if (isNextClass) {
            
            // 最后传出去最终选择的值
            if ([self.delegate respondsToSelector:@selector(assciationMenuView:finalSelectedResult:)]) {
                
                [_delegate assciationMenuView:self finalSelectedResult:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
                
            }
            [self saveSels];
 
            [self dismiss];
            
        }
    }
}

@end
