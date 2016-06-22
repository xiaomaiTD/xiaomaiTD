//
//  InformationModel.h
//  CXNews
//
//  Created by liyoubing on 16/5/9.
//  Copyright © 2016年 liyoubing. All rights reserved.
/*
 click = 0;
 date = "2015/12/4 17:00:23";
 id = 58;
 img = "/UpLoadFiles/Images/96097b8e070146d2ad7de4dc1ecb3048.jpeg";
 newid = BCNN6FDL05198FG4;
 pid = 8;
 remark = "\U5411\U6765\U53e3\U51fa\U72c2\U8a00\U7684\U201c\U5927\U5634\U201d\U7279\U6717\U666e\Uff0c\U6700\U8fd1\U53c8\U5728\U671d\U9c9c\U6838\U95ee\U9898\U4e0a\U53d1\U8868\U75af\U766b\U8a00\U8bba\Uff0c\U65e0\U6545\U5c06\U671d\U6838\U95ee\U9898\U7684\U8d23\U4efb\U63a8\U5230\U4e2d\U56fd\U8eab\U4e0a\U3002";
 title = "\U5927\U5634\U7279\U6717\U666e\Uff1a \U6211\U82e5\U5f53\U603b\U7edf\Uff0c\U4e00\U62db\U5e72\U8db4\U4e2d\U56fd\U7ecf\U6d4e";
 url = "http://c.m.163.com/nc/article/BCNN6FDL05198FG4/full.html"
 */

#import "BaseModel.h"

@interface InformationModel : BaseModel

@property(nonatomic, strong)NSNumber *click;
@property(nonatomic, copy)NSString *date;
@property(nonatomic, copy)NSString *img;
@property(nonatomic, strong)NSNumber *newid;
@property(nonatomic, copy)NSString *pid;
@property(nonatomic, copy)NSString *remark;
@property(nonatomic, copy)NSString *title;
@property(nonatomic, copy)NSString *url;
@property(nonatomic, copy)NSString *InformationID;

@property(nonatomic, strong)NSDictionary *modelInfo;

@end
