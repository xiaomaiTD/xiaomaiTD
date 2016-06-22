//
//  CXSegmentCtontrol.h
//  CXNews
//
//  Created by liyoubing on 16/5/11.
//  Copyright © 2016年 liyoubing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXSegmentCtontrol : UIControl {

    NSArray *_titleArray;
    UIImageView *_selectImgView;
}

@property(nonatomic, assign)NSInteger selectIndex; //选中的下标

- (id)initWithFrame:(CGRect)frame
         withTitles:(NSArray *)titleArray;

@end
