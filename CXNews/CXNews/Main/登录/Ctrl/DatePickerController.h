//
//  DatePickerController.h
//  CXNews
//
//  Created by liyoubing on 16/5/4.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GetSelectDateDelegate <NSObject>

- (void)getSelectResult:(NSString *)dateStr;

@end

@interface DatePickerController : UIViewController

@property(nonatomic, weak)id<GetSelectDateDelegate> delegate;

@property(nonatomic, copy)NSString *selectDate; //2015-03-06

@end
