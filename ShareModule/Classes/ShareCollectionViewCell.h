//
//  ShareCollectionViewCell.h
//  FirstProject
//
//  Created by Peyton on 2018/7/10.
//  Copyright © 2018年 BJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logoIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

- (void)setCellWithLogoImage:(UIImage *)logoImage name:(NSString *)name;

@end
