//
//  JokeCell.h
//  CXNews
//
//  Created by liyoubing on 16/5/9.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InformationModel;

@interface JokeCell : UITableViewCell {

    UILabel *_titleLabel;
    UILabel *_remarkLabel;
    UILabel *_timeLabel;
    UIImageView *_shareImgView;
}

@property(nonatomic, strong)InformationModel *model;

+ (CGFloat)getRemarkHeight:(NSString *)content;

@end
