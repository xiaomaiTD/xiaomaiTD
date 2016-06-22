//
//  InformationViewController.m
//  CXNews
//
//  Created by liyoubing on 16/4/26.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import "InformationViewController.h"
#import "RecommendViewController.h"
#import "EntertainmentViewController.h"
#import "VideoViewController.h"
#import "JokeViewController.h"

@interface InformationViewController ()

@end

@implementation InformationViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"咨询";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //创建子控制器
    RecommendViewController *recommendCtrl = [[RecommendViewController alloc] init];
    EntertainmentViewController *entertainmentCtrl = [[EntertainmentViewController alloc] init];
    VideoViewController *videoCtrl = [[VideoViewController alloc] init];
    JokeViewController *jokeCtrl = [[JokeViewController alloc] init];
    
    self.viewControllers = @[recommendCtrl,entertainmentCtrl,videoCtrl,jokeCtrl];
    
}


@end
