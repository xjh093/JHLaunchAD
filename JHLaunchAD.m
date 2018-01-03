//
//  JHLaunchAD.m
//  JHKit
//
//  Created by HaoCold on 2017/7/19.
//  Copyright © 2017年 HaoCold. All rights reserved.
//
//  MIT License
//
//  Copyright (c) 2017 xjh093
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "JHLaunchAD.h"
#import "JHCountDownAnimationView.h"

@interface JHLaunchAD()<JHCountDownAnimationViewDelegate>
@property (strong,    nonatomic)JHCountDownAnimationView *cdaView;
@property (strong,    nonatomic)UIImageView *adImageView;
@end

@implementation JHLaunchAD

- (instancetype)initWithFrame:(CGRect)frame
{
    frame = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:frame];
    if (self) {
        [self jhSetupViews];
    }
    return self;
}

- (void)jhSetupViews
{
    _adImageView = [[UIImageView alloc] init];
    _adImageView.frame = self.bounds;
    _adImageView.backgroundColor = [UIColor whiteColor];
    _adImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_adImageView];
    
#if 1
    _adImageView.image = [UIImage imageNamed:@"bg"];
#else

    //在Assets.xcassets中设置好LaunchImage，才能使用下面的代码
    //启动页
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict)
    {
        //NSLog(@"ad dict:%@",dict);
        /**<
         {
         UILaunchImageMinimumOSVersion = "8.0";
         UILaunchImageName = "LaunchImage-800-Portrait-736h";
         UILaunchImageOrientation = Portrait;
         UILaunchImageSize = "{414, 736}";
         }
         */
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if(CGSizeEqualToSize(imageSize, viewSize))
        {
            UIImage *image = [UIImage imageNamed:dict[@"UILaunchImageName"]];
            self.layer.contents = (id)[image CGImage];
            break;
        }
    }

    
#endif
    
    UIButton *button = [[UIButton alloc] init];
    button.frame = self.bounds;
    [button addTarget:self action:@selector(xx_click_event) forControlEvents:1<<6];
    [self addSubview:button];
    
    _cdaView = [[JHCountDownAnimationView alloc] initWithFrame:CGRectMake(kScreenWidth-70, 30, 50, 50)];
    _cdaView.delegate = self;
    _cdaView.jh_addToView(self);
}

#pragma mark - JHCountDownAnimationViewDelegate
- (void)jh_skip{
    [self xx_animation];
}

- (void)jh_count_down_over{
    [self xx_animation];
}

- (void)xx_animation
{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [_cdaView jh_stop];
        [self removeFromSuperview];
    }];
}

- (void)xx_click_event
{
    if (_delegate &&
        [_delegate respondsToSelector:@selector(jh_launchAD:clickAD:)]) {
        [_delegate jh_launchAD:[self xx_navigationController:nil] clickAD:_dic];
        [_cdaView jh_stop];
        [self removeFromSuperview];
    }
}

- (void)jh_show{
    [[UIApplication sharedApplication].keyWindow.rootViewController.view.window addSubview:self];
}

- (void)jh_hide{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [_cdaView jh_stop];
        [self removeFromSuperview];
    }];
}


- (UINavigationController*)xx_navigationController:(UIViewController *)rootVC
{
    UINavigationController* nav = nil;
    if (!rootVC) {
        rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    if ([rootVC isKindOfClass:[UINavigationController class]]) {
        nav = (id)rootVC;
    }
    else {
        if ([rootVC isKindOfClass:[UITabBarController class]]) {
            nav = [self xx_navigationController:((UITabBarController*)rootVC).selectedViewController];
        }
        else {
            nav = rootVC.navigationController;
        }
    }
    return nav;
}

- (void)setDic:(NSDictionary *)dic{
    if (!dic) {
        [self jh_hide];
        return;
    }
    
    _dic = dic;
#if 0
    __weak typeof(self) ws = self;
    [_adImageView sd_setImageWithURL:[NSURL URLWithString:IMAGEURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) {
            __strong typeof(self) self = ws;
            [self jh_hide];
        }
        [self addSubview:_cdaView];
        [_cdaView jh_start];
    }];
#endif
}

@end
