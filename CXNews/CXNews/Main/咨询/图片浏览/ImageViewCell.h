//
//  IamgeViewCell.h
//  CXNews
//
//  Created by liyoubing on 16/5/10.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewCell : UICollectionViewCell<UIScrollViewDelegate> {

    UIImageView *_imgView;
    UIScrollView *_scrollView;
}

@property(nonatomic, copy)NSString *imgURL;

@end
