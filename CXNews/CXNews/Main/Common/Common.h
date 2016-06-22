//
//  Common.h
//  CXNews
//
//  Created by liyoubing on 16/4/26.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#ifndef Common_h
#define Common_h

#define KScreenWidth    [UIScreen mainScreen].bounds.size.width
#define KScreenHeight   [UIScreen mainScreen].bounds.size.height

#define DefaultColor    [UIColor colorWithRed:29/255.0 green:43/255.0 blue:137/255.0 alpha:1]
#define DefaultBgColor    [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1]

/*--------------------------腾讯app------------------------*/
#define APPID   @"1105328701"
#define APPKEY  @"rlLJKhV24ThPaHZG"

/*--------------------------微博app------------------------*/
#define WAppKey  @"1179867711"
#define WAppSecret  @"2a13e20ff1adcb80abc98f9c283b31c9"
#define RedirectURL    @"http://www.cxwlbj.com/"

/*--------------------------接口定义------------------------*/
#define KApi_appInfo    @"https://itunes.apple.com/lookup?id=425349261"
#define KApi_updataInfo     @"https://itunes.apple.com/cn/app/xing-zuo-zhan-bo-da-shi-mian/id561653603?mt=8"
#define BaseURL         @"http://123.57.246.163:8044/api/"

//短信的key
#define CodeKey         @"55f5f0fe4ac4"
#define CodeSecret      @"33c154f6bc2e1e159087b8d5e5bb9361"
/*-----------------设置模块-------------*/
#define AddFeedback     @"AddFeedback.aspx"

/*-----------------我的模块-------------*/
#define LoginMessage    @"LoginMessage"     //存储用户信息的key
#define RegisterUser    @"Register.aspx"    //注册接口
#define LoginUser       @"Login.aspx"   //登录接口
#define LoginOutUser    @"LoginOut.aspx"    //注销用户
#define EditUserInfo    @"editUserInfo.aspx"    //修改用户信息
#define UpHeading       @"upHeadImg.aspx"       //上传头像


/*-----------------资讯模块-------------*/
#define GetNewList          @"GetNewsList.aspx"       //资讯一级视图数据
#define GetNewInfo(newID)   [NSString stringWithFormat:@"http://c.m.163.com/nc/article/%@/full.html",newID]
#define SavePath            [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/newList.plist"]
#define AddFollow           @"AddFollow.aspx"

/*-----------------收藏模块-------------*/
#define GetMyFollowList     @"GetMyFollowList.aspx"


/*-----------------------字符串常量-----------------------------*/
// 关于我们信息
#define kText_aboutUSText @"北京畅想未来科技有限公司，是一家集成培训与科研一体的研发公司，总部坐落在北京,主要负责培训、研发、和生产的工作。\n北京畅想未来科技有限公司，主要致力于开发、培训和销售先进的APP产品。公司产品涉及：APP研发、企宣站开发设计、系统管理后台、等十多个互联网领域。产品主要应用在企业发展,公司的产品设计旨在满足各公司的商业需求。\n北京畅想未来科技有限公司在学员中具有广泛赞誉，培训稳定可靠，多样性性好，很多指标已经成为业内标准。\n在未来，北京畅想未来科技有限公司更加重视中国市场的开发与拓展，提供更多更好的培训与服务。"

// 联系我们信息
#define kText_ContactUSText @"公司地址 : 北京市通州梨园贵友大厦A座1602-1604\n3g学院 : http://www.cxwlbj.com\n技术研发 : http://www.cxwelike.com\nE－Mail : siming_zhu@163.com\nTEL : 010－57176540\n"


#endif /* Common_h */
