//
//  ShareCollectionViewCell.m
//  FirstProject
//
//  Created by Peyton on 2018/7/10.
//  Copyright © 2018年 BJ. All rights reserved.
//

#import "ShareCollectionViewCell.h"

@implementation ShareCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCellWithLogoImage:(UIImage *)logoImage name:(NSString *)name {
    self.logoIV.image = logoImage;
    self.nameLabel.text = name;
}
@end
