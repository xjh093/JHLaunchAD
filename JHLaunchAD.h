//
//  JHLaunchAD.h
//  JHKit
//
//  Created by HaoCold on 2017/7/19.
//  Copyright © 2017年 HaoCold. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JHLaunchADDelegate <NSObject>
///点击广告
- (void)jh_launchAD:(UINavigationController *)nav clickAD:(NSDictionary *)dic;
@end

@interface JHLaunchAD : UIView
@property (strong,    nonatomic) NSDictionary *dic;
@property (weak,      nonatomic) id <JHLaunchADDelegate> delegate;

///展示
- (void)jh_show;
///隐藏
- (void)jh_hide;
@end
