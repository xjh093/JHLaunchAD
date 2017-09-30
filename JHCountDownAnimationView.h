//
//  JHCountDownAnimationView.h
//  JHKit
//
//  Created by HaoCold on 2017/7/19.
//  Copyright © 2017年 HaoCold. All rights reserved.
//  倒计时动画

#import <UIKit/UIKit.h>

@protocol JHCountDownAnimationViewDelegate <NSObject>
///跳过事件
- (void)jh_skip;
///倒计时结束
- (void)jh_count_down_over;
@end

@interface JHCountDownAnimationView : UIView
@property (weak,    nonatomic) id <JHCountDownAnimationViewDelegate> delegate;

///停止定时器
- (void)jh_stop;
@end
