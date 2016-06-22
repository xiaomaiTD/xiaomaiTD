//
//  CodeButton.m
//  CXNews
//
//  Created by liyoubing on 16/4/29.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "CodeButton.h"

@interface CodeButton () {


    UILabel *_titleLabel;
    UIActivityIndicatorView *_indicationView;
    UILabel *_timeLabel;
    NSTimer *_timer;
}

@end

@implementation CodeButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //创建子视图
        [self _initSubView];
    }
    return self;
}

//创建子视图
- (void)_initSubView {

    //创建label
    _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _titleLabel.textColor = DefaultColor;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.text = @"获取验证码";
    _titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_titleLabel];
    
    //创建加载提示视图
    _indicationView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicationView.frame = CGRectMake(5, (self.height-20)/2.0, 20, 20);
    [self addSubview:_indicationView];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_indicationView.right+5, _indicationView.top, (self.width-30), 20)];
    _timeLabel.textColor = [UIColor darkGrayColor];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.hidden = YES;
    [self addSubview:_timeLabel];
    
    //判断当前是否处于加载状态
    //(1)获取点击的时间
    NSTimeInterval touchTime = [[[NSUserDefaults standardUserDefaults] objectForKey:@"TouchTime"] doubleValue];
    //当前的时间
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    if (nowTime - touchTime <= 60) {
        
        //关闭点击事件
        self.enabled = NO;
        
        //当前是加载状态
        //UI操作
        _titleLabel.hidden = YES;
        [_indicationView startAnimating];
        _timeLabel.hidden = NO;
        _timeLabel.text = [NSString stringWithFormat:@"%ds",(int)(60-(nowTime-touchTime))];
       //在多线程中开启定时器
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //开启定时器
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
            //使用runLoop
            [[NSRunLoop currentRunLoop] run];
        });
    }
    
}

//点击事件
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    //记录当前的时间
    NSTimeInterval touchTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval lastTime = [[[NSUserDefaults standardUserDefaults] objectForKey:@"TouchTime"] doubleValue];
    
    if (touchTime-lastTime > 60 && _isPhoneNumber) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@(touchTime) forKey:@"TouchTime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        _timeLabel.text = @"60s";
        //UI操作
        _titleLabel.hidden = YES;
        [_indicationView startAnimating];
        _timeLabel.hidden = NO;
        
        //在多线程中开启定时器
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //开启定时器
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
            
            //使用runLoop
            [[NSRunLoop currentRunLoop] run];
        });
        self.enabled = NO;
        
        //发送点击事件
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

//定时器的方法
- (void)timeAction {

    //回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        //获取时间
        NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
        
        //获取点击的时间
        NSTimeInterval touchTime = [[[NSUserDefaults standardUserDefaults] objectForKey:@"TouchTime"] doubleValue];
        
        if (nowTime - touchTime <= 60) {
            _timeLabel.text = [NSString stringWithFormat:@"%ds",(int)(60-(nowTime-touchTime))];
        }else {
            //关闭定时器
            [_timer invalidate];
            [_indicationView stopAnimating];
            _timeLabel.hidden = YES;
            _titleLabel.hidden = NO;
            //恢复点击
            self.enabled = YES;
        }
    });
}

- (void)stop {

    //（1）移除本地缓存
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"TouchTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //（2）关闭定时器
    [_timer invalidate];
    _timer = nil;
    
    //（3）UI
    [_indicationView stopAnimating];
    _timeLabel.hidden = YES;
    _titleLabel.hidden = NO;
    
    //（4）恢复点击
    self.enabled = YES;
    
}

@end
