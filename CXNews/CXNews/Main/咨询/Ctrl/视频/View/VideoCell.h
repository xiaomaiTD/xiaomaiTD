//
//  VideoCell.h
//  CXNews
//
//  Created by liyoubing on 16/5/9.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InformationModel;
@class CXTextField;

@interface VideoCell : UITableViewCell {

    CXTextField *_titleLabel;
    UIImageView *_imgView;
    UIImageView *_playImg;
    UILabel *_countLabel;
    UIImageView *_iconImg;
    UIButton *_shareButton;
}

@property(nonatomic, strong)InformationModel *model;

@end
