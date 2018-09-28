//
//  ShareListView.h
//  FirstProject
//
//  Created by Peyton on 2018/7/10.
//  Copyright © 2018年 BJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShareViewDelegate <NSObject>

- (void)selectShareIconAtIndexPath:(NSIndexPath *)indexPath;

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

@end

