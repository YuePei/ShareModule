//
//  ShareListView.h
//  FirstProject
//
//  Created by Peyton on 2018/7/10.
//  Copyright © 2018年 BJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShareViewDelegate <NSObject>

//选择了某一分享类型
- (void)selectShareIconAtIndexPath:(NSIndexPath *)indexPath;

//截图编辑
- (void)screenshotToEdit;

//添加表情
- (void)addExpression;

@end

@interface ShareListView : UIView
//delegate
@property (nonatomic, weak)id<ShareViewDelegate> delegate;

/**
 @param icons       图标
 @param titles      标题
 @param vc          分享视图将要加载到哪个页面上, 一般传self即可
 */
- (instancetype)initWithShareIcons:(NSArray *)icons ShareTitles:(NSArray *)titles andVC:(UIViewController *)vc;

//显示分享控件
- (void)showShareModule;

//隐藏分享控件
- (void)hideShareModule;

@end

