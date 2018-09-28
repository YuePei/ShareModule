//
//  ShareListView.m
//  FirstProject
//
//  Created by Peyton on 2018/7/10.
//  Copyright © 2018年 BJ. All rights reserved.
//

#import "ShareListView.h"
#import "ShareCollectionViewCell.h"
#define MAS_SHORTHAND
#import "Masonry.h"

//屏幕宽高
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define BackgroundColor [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1]

@interface ShareListView () <UICollectionViewDelegate, UICollectionViewDataSource>

//中间的view, 用来展示collectionView和其他的View
@property (nonatomic, strong)UIView *middleView;
//collectionView
@property (nonatomic, strong)UICollectionView *collectionView;
//array
@property (nonatomic, strong)NSArray *array;
//icons
@property (nonatomic, strong)NSArray *icons;
//分割线
@property (nonatomic , strong) UIView *separaterLine;
//分割线上面的view
@property (nonatomic , strong) UIView *topView;
//分享视图左边的按钮，截图编辑
@property (nonatomic , strong) UIButton *screenShotButton;
//分享视图右边的按钮，添加
@property (nonatomic , strong) UIButton *addExpressionButton;

//blur
@property (nonatomic, strong)UIBlurEffect *effect;
//毛玻璃
@property (nonatomic, strong)UIVisualEffectView *effectView;
//screenShotImageView
@property (nonatomic, strong)UIImageView *screenShotImageView;
//半透明遮罩
@property (nonatomic, strong)UIView *translucentView;
//vc
@property (nonatomic, strong)UIViewController *viewController;

@end

@implementation ShareListView

static const float leftMargin = 30.0;
static const float rightMargin = 30.0;
static const float topMargin = 10.0;
static const float bottomMargin = 10.0;
static const float rowInterval = 30.0;
static const float columnInterval = 20.0;
static const float itemWidth = 50.0;
static const float itemHeight = itemWidth + 25;
static const float buttonWidth_Height = 100;


#pragma mark initMethods
- (instancetype)initWithShareIcons:(NSArray *)icons ShareTitles:(NSArray *)titles andVC:(UIViewController *)vc{
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    if (self = [super initWithFrame:rect]) {
        self.array = titles;
        self.icons = icons;
        
        self.backgroundColor = [UIColor colorWithRed:1 / 255.0 green:1 / 255.0 blue:1 / 255.0 alpha:0];
        [self collectionView];
        [self middleView];
        [self separaterLine];
        [self topView];
        [self screenShotButton];
        [self addExpressionButton];
        [self addGesture];
        [self showMiddleView];
        self.viewController = vc;
        self.screenShotImageView.image = [self screenShotWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return self;
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"shareCell" forIndexPath:indexPath];
    [cell setCellWithLogoImage:self.icons[indexPath.row] name:self.array[indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //1. 隐藏分享控件
    [self hideMiddleView];
    //2. 选择分享类型
    [self.delegate selectShareIconAtIndexPath:indexPath];
}

#pragma mark toolMethods

- (UIImage *)screenShotWithFrame:(CGRect )imageRect {
    
    UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, 0.0);
    [self.viewController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenShotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenShotImage;
}

//毛玻璃效果
- (void)addBlurView {
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    effectView.alpha = 1;
    [self insertSubview:effectView belowSubview:self.middleView];
}

//给半透明背景加点击手势, 点击半透明背景隐藏分享控件
- (void)addGesture {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideMiddleView)];
    [self.translucentView addGestureRecognizer:tapGesture];
}
//隐藏分享模块
- (void)hideMiddleView {
    
    [self.screenShotImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    [self.middleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(225);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        //0. 显示状态栏
        [UIApplication sharedApplication].statusBarHidden = NO;
        //1. 截图撑满屏幕
        [self.screenShotImageView layoutIfNeeded];
        //2. 动态模糊隐藏
        self.effectView.alpha = 0;
        //3. 半透明蒙板隐藏
        [self.translucentView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0]];
        //4. 分享模块隐藏
        [self.middleView.superview layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        //移除分享控件
        [self removeFromSuperview];
    }];
}

//显示分享模块
- (void)showMiddleView {
    //0. 隐藏状态栏
    [UIApplication sharedApplication].statusBarHidden = YES;
    //1. 截图
    self.screenShotImageView.image = [self screenShotWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    //2. 背景虚化
    [self effectView];
    
    //3. 将截图显示在页面上
    [self screenShotImageView];
    [self.screenShotImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50 * SCREEN_WIDTH / SCREEN_HEIGHT);
        make.top.mas_equalTo(50);
        make.right.mas_equalTo(-50 * SCREEN_WIDTH / SCREEN_HEIGHT);
        make.bottom.mas_equalTo(-50);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self.screenShotImageView layoutIfNeeded];
    }];
    
    //4. 黑色半透明蒙板
    [UIView animateWithDuration:0.3 animations:^{
        [self.translucentView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.2]];
    }];
    
    //5. 显示分享控件
    [self.middleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10);
    }];
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        [self.middleView.superview layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        NSLog(@"Show animation finished.");
    }];
}

//截图编辑按钮的点击方法
- (void)screenshot {
    [self.delegate screenshotToEdit];
}

//添加表情按钮的点击方法
- (void)addExpressions {
    [self.delegate addExpression];
}

//调整按钮的图文位置
- (void)adjustButtonImageViewUPTitleDownWithButton:(UIButton *)button {
    [self.topView layoutIfNeeded];
    //使图片和文字居左上角
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    CGFloat buttonHeight = CGRectGetHeight(button.frame);
    CGFloat buttonWidth = CGRectGetWidth(button.frame);
    
    CGFloat ivHeight = CGRectGetHeight(button.imageView.frame);
    CGFloat ivWidth = CGRectGetWidth(button.imageView.frame);
    
    CGFloat titleHeight = CGRectGetHeight(button.titleLabel.frame);
    CGFloat titleWidth = CGRectGetWidth(button.titleLabel.frame);
    //调整图片
    float iVOffsetY = buttonHeight / 2.0 - (ivHeight + titleHeight) / 2.0;
    float iVOffsetX = buttonWidth / 2.0 - ivWidth / 2.0;
    [button setImageEdgeInsets:UIEdgeInsetsMake(iVOffsetY, iVOffsetX, 0, 0)];
    
    //调整文字
    float titleOffsetY = iVOffsetY + CGRectGetHeight(button.imageView.frame) + 10;
    float titleOffsetX = 0;
    if (CGRectGetWidth(button.imageView.frame) >= (CGRectGetWidth(button.frame) / 2.0)) {
        //如果图片的宽度超过或等于button宽度的一半
        titleOffsetX = -(ivWidth + titleWidth - buttonWidth / 2.0 - titleWidth / 2.0);
    }else {
        titleOffsetX = buttonWidth / 2.0 - ivWidth - titleWidth / 2.0;
    }
    //    [button setTitleEdgeInsets:UIEdgeInsetsMake(titleOffsetY , titleOffsetX, 0, 0)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(titleOffsetY , -28.5, 0, 0)];
    NSLog(@"   :-(图片宽度(%f) + 文字宽度(%f) - 按钮宽度的一半(%f/2) - 文字宽度的一半(%f/2) = 文字的偏移量(%f))",ivWidth, titleWidth, buttonWidth, titleWidth, titleOffsetX);
}

#pragma mark lazy
- (UIView *)middleView {
    if (!_middleView) {
        _middleView = [UIView new];
        [self addSubview:_middleView];
        [_middleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(225);
            make.bottom.mas_equalTo(225);
        }];
        _middleView.backgroundColor = [UIColor whiteColor];
        _middleView.layer.cornerRadius = 10;
        _middleView.layer.masksToBounds = YES;
    }
    return _middleView;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [UIView new];
        [self.middleView addSubview:_topView];
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(self.separaterLine.mas_top);
        }];
        _topView.backgroundColor = [UIColor clearColor];
    }
    return _topView;
}

- (UIButton *)screenShotButton {
    if (!_screenShotButton) {
        _screenShotButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [_screenShotButton setFrame:CGRectMake(20, 20, 60, 60)];
        [self.topView addSubview:_screenShotButton];
        [_screenShotButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.topView.mas_centerY);
            make.centerX.mas_equalTo(self.topView.mas_centerX).offset(- (CGRectGetWidth(self.frame) - 20) / 4.0);
            make.width.height.mas_equalTo(buttonWidth_Height);
            //            make.height.mas_equalTo(80);
        }];
        [_screenShotButton setTitle:@"截图编辑" forState:UIControlStateNormal];
        [_screenShotButton setImage:[UIImage imageNamed:@"图片剪切"] forState:UIControlStateNormal];
        _screenShotButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_screenShotButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setNeedsLayout];
        [self layoutIfNeeded];
        [self adjustButtonImageViewUPTitleDownWithButton:_screenShotButton];
        
        [_screenShotButton addTarget:self action:@selector(screenshot) forControlEvents:UIControlEventTouchUpInside];
    }
    return _screenShotButton;
}

- (UIButton *)addExpressionButton {
    if (!_addExpressionButton) {
        
        _addExpressionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.topView addSubview:_addExpressionButton];
        [_addExpressionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.topView.mas_centerY);
            make.centerX.mas_equalTo(self.topView.mas_centerX).mas_offset((CGRectGetWidth(self.frame) - 20) / 4.0);
            make.width.height.mas_equalTo(100);
            //            make.height.mas_equalTo(80);
        }];
        [_addExpressionButton setTitle:@"添加表情" forState:UIControlStateNormal];
        [_addExpressionButton setImage:[UIImage imageNamed:@"表情"] forState:UIControlStateNormal];
        _addExpressionButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_addExpressionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self adjustButtonImageViewUPTitleDownWithButton:_addExpressionButton];
        
        [_addExpressionButton addTarget:self action:@selector(addExpressions) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addExpressionButton;
}

- (UIView *)separaterLine {
    if (!_separaterLine) {
        _separaterLine = [[UIView alloc]init];
        [self.middleView addSubview:_separaterLine];
        [_separaterLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(-30);
            make.bottom.mas_equalTo(self.collectionView.mas_top).mas_offset(-10);
            make.height.mas_equalTo(1);
        }];
        _separaterLine.backgroundColor = BackgroundColor;
    }
    return _separaterLine;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        //一共有多少个cell
        long columnCount = self.array.count;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = rowInterval;
        layout.minimumInteritemSpacing = columnInterval;
        layout.sectionInset = UIEdgeInsetsMake(topMargin, leftMargin, bottomMargin, rightMargin);
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [self.middleView addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(itemHeight + topMargin + bottomMargin);
        }];
        _collectionView.contentSize = CGSizeMake(leftMargin + columnCount * itemWidth + (columnCount -1) * columnInterval + rightMargin, CGRectGetHeight(_collectionView.frame));
        
        //注册cell
        NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
        [_collectionView registerNib:[UINib nibWithNibName:@"ShareCollectionViewCell" bundle:thisBundle] forCellWithReuseIdentifier:@"shareCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (NSArray *)array {
    if (!_array) {
        _array = [NSArray array];
    }
    return _array;
}

- (NSArray *)icons {
    if (!_icons) {
        _icons = [NSArray array];
    }
    return _icons;
}

- (UIBlurEffect *)effect {
    if (!_effect) {
        _effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    }
    return _effect;
}

- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        _effectView = [[UIVisualEffectView alloc]initWithEffect:self.effect];
        [_effectView setFrame:self.frame];
        _effectView.alpha = 0.9;
        [self insertSubview:_effectView belowSubview:self.middleView];
    }
    return _effectView;
}

- (UIImageView *)screenShotImageView {
    if (!_screenShotImageView) {
        _screenShotImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self insertSubview:_screenShotImageView aboveSubview:self.effectView];
    }
    return _screenShotImageView;
}

- (UIView *)translucentView {
    if (!_translucentView) {
        _translucentView = [[UIView alloc]initWithFrame:self.frame];
        [self insertSubview:_translucentView aboveSubview:self.screenShotImageView];
    }
    return _translucentView;
}

@end

