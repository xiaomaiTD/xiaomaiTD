//
//  RecommendCell.h
//  CXNews
//
//  Created by liyoubing on 16/5/9.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InformationModel;

@interface RecommendCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property(nonatomic, strong)InformationModel *model;

@end
