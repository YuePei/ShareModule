# ShareModule

[![CI Status](https://img.shields.io/travis/YuePei/ShareModule.svg?style=flat)](https://travis-ci.org/YuePei/ShareModule)
[![Version](https://img.shields.io/cocoapods/v/ShareModule.svg?style=flat)](https://cocoapods.org/pods/ShareModule)
[![License](https://img.shields.io/cocoapods/l/ShareModule.svg?style=flat)](https://cocoapods.org/pods/ShareModule)
[![Platform](https://img.shields.io/cocoapods/p/ShareModule.svg?style=flat)](https://cocoapods.org/pods/ShareModule)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

ShareModule is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
source 'https://github.com/YuePei/privateSpecRepo.git'
source 'https://github.com/CocoaPods/Specs.git'

target 'test1' do

use_frameworks!
    pod 'ShareModule'

@end
```

## Use
#### 1. init
```
ShareListView *shareView = [[ShareListView alloc]initWithShareIcons:@[[UIImage imageNamed:@"weChat"],
                                                                      [UIImage imageNamed:@"朋友圈"],
                                                                      [UIImage imageNamed:@"QQ"],
                                                                      [UIImage imageNamed:@"空间"],
                                                                      [UIImage imageNamed:@"支付宝"],
                                                                      [UIImage imageNamed:@"微博"],
                                                                      [UIImage imageNamed:@"更多"]]
                                                         ShareTitles:@[@"微信",@"朋友圈",@"QQ好友",@"QQ空间",@"支付宝",@"微博", @"更多"]
                                                         andVC:self];
shareView.delegate = self;
[[UIApplication sharedApplication].keyWindow addSubview:shareView];
```

#### 2. select item
Follow `ShareViewDelegate` and implement `selectShareIconAtIndexPath` method like this :
```
#pragma mark ShareViewDelegate
- (void)screenshotToEdit {

}

- (void)addExpression {

}

- (void)selectShareIconAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:

            break;
        case 1:

            break;
        case 2:

            break;
        case 3:

            break;
        case 4:

            break;
        case 5:

            break;
        case 6: {

        }
            break;
        default:
            break;
    }
}

```

