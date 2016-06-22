//
//  UserModel.h
//  CXNews
//
//  Created by liyoubing on 16/5/4.
//  Copyright © 2016年 liyoubing. All rights reserved.
/*
 address = "\U5317\U4eac";
 birthDayString = "2016-05-03";
 email = "";
 headImg = "/UpLoadFiles/head/2b6c5b94c14745248a71125f6794eb91.png";
 integral = 0;
 loginStatus = 1;
 nickName = "\U963f\U4f51";
 price = "0.00";
 qq = "";
 sex = 0;
 tel = 18513815093;
 token = "MTY0OTY3MjAxNi81LzQgMTQ6NDc6MDE=";
 trueName = ceshi;
 userName = 18513815093;
 */

#import "BaseModel.h"


@interface UserModel : BaseModel

@property(nonatomic, copy)NSString *address;
@property(nonatomic, copy)NSString *birthDayString;
@property(nonatomic, copy)NSString *email;
@property(nonatomic, copy)NSString *headImg;
@property(nonatomic, strong)NSNumber *integral;
@property(nonatomic, strong)NSNumber *loginStatus;
@property(nonatomic, copy)NSString *nickName;
@property(nonatomic, copy)NSString *price;
@property(nonatomic, copy)NSString *qq;
@property(nonatomic, strong)NSNumber *sex;
@property(nonatomic, copy)NSString *tel;
@property(nonatomic, copy)NSString *token;
@property(nonatomic, copy)NSString *trueName;
@property(nonatomic, copy)NSString *userName;

@property(nonatomic, copy)NSString *qqImg;

@property(nonatomic, strong)NSDictionary *userInfo; //用户所有信息

@end
