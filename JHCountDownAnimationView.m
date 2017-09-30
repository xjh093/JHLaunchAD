//
//  JHCountDownAnimationView.m
//  JHKit
//
//  Created by HaoCold on 2017/7/19.
//  Copyright © 2017年 HaoCold. All rights reserved.
//

#import "JHCountDownAnimationView.h"

@interface JHCountDownAnimationView()
@property (assign,  nonatomic) CGFloat angle;
@property (assign,  nonatomic) CGFloat increment;
@property (strong,  nonatomic) CADisplayLink *link;
@end

@implementation JHCountDownAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self jhSetupViews:frame];
    }
    return self;
}

- (void)jhSetupViews:(CGRect)frame
{
    self.layer.cornerRadius = frame.size.width*0.5;
    self.layer.masksToBounds = YES;
    self.jh_bgColor([UIColor colorWithWhite:0 alpha:0.3]);
    
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    [button setTitle:@"跳过" forState:0];
    [button setTitleColor:[UIColor whiteColor] forState:0];
    [button addTarget:self action:@selector(xx_skip_event) forControlEvents:1<<6];
    [self addSubview:button];
    
    _increment = 0.4*M_PI/60;
    _angle = -M_PI_2;
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay)];
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    _link = link;
}

- (void)xx_skip_event
{
    if (_delegate &&
        [_delegate respondsToSelector:@selector(jh_skip)]) {
        [_delegate jh_skip];
    }
}

- (void)jh_stop{
    if (_link) {
        [_link invalidate];
        _link = nil;
    }
}

- (void)drawRect:(CGRect)rect {
    
    CGFloat x = CGRectGetMidX(self.bounds);
    CGFloat y = CGRectGetMidY(self.bounds);
    CGFloat r = CGRectGetWidth(self.bounds)*0.5-4;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] set];
    CGContextSetLineWidth(context, 2);
    CGContextAddArc(context, x, y, r, _angle, M_PI_2*3, 0);
    CGContextDrawPath(context, kCGPathStroke);
    
    _angle += _increment;
    
    if (_angle >= M_PI_2*3) {
        [_link invalidate];
        _link = nil;
        
        if (_delegate &&
            [_delegate respondsToSelector:@selector(jh_count_down_over)]) {
            [_delegate jh_count_down_over];
        }
    }
}

/**<
 5s - 360度 - 2 * M_PI
 1s - 72度  - 0.4 * M_PI
 1s - 60次  -    
 */

@end
