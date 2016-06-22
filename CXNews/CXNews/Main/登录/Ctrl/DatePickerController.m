//
//  DatePickerController.m
//  CXNews
//
//  Created by liyoubing on 16/5/4.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "DatePickerController.h"

@interface DatePickerController () {

    UIDatePicker *_datePicker;
}

@end

@implementation DatePickerController

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置当前视图的背景
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    
    //创建子视图
    [self _initSubView];
    
    
}

//创建子视图
- (void)_initSubView {

    //创建父视图
    UIView *superView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth*0.6, 276*0.6)];
    superView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:superView];
    //设置边框
    superView.layer.cornerRadius = 10;
    superView.layer.masksToBounds = YES;
//    superView.transform = CGAffineTransformMakeScale(0.6, 0.6);
    superView.center = self.view.center;
    
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 276-40)];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.transform = CGAffineTransformMakeScale(0.6, 0.6);
    _datePicker.origin = CGPointMake(0, 0);
    //设置初始时间
    _datePicker.date = [NSDate date];
    
    [superView addSubview:_datePicker];
    
    for (int i=0; i<2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor whiteColor];
        button.frame = CGRectMake(i*(superView.width/2.0-1), superView.height-40, superView.width/2.0+i*1, 40);

        NSString *title = i==0?@"取消":@"确定";
        //设置标题
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.tag = i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [superView addSubview:button];
    }
}

- (void)setSelectDate:(NSString *)selectDate {

    _selectDate = selectDate;
    
    if (_selectDate.length > 0) {   //设置外界传递的数据
        //2015-03-06
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *selecteDate = [dateFormatter dateFromString:_selectDate];
        
        _datePicker.date = selecteDate;
        
    }
}

- (void)buttonAction:(UIButton *)button {

    //隐藏视图
    self.view.window.hidden = YES;
    
    //如果点击的是确定
    if (button.tag == 1) {
        //获取选择的时间
        //2015-03-06
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        _selectDate = [dateFormatter stringFromDate:_datePicker.date];
        
        //回调
        if ([_delegate respondsToSelector:@selector(getSelectResult:)]) {
            [_delegate getSelectResult:_selectDate];
        }
        
    }
    
    
    
}

@end
