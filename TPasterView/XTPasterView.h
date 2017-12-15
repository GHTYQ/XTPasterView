//
//  XTPasterView.h
//  XTPasterManager
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XTPasterView ;

@protocol XTPasterViewDelegate <NSObject>
- (void)makePasterBecomeFirstRespond:(int)pasterID ;
- (void)removePaster:(int)pasterID ;
@end

@interface XTPasterView : UIView
@property (nonatomic,strong) UIImageView    *imgContentView ;
@property (nonatomic,strong) UILabel        *contentLab;
@property (nonatomic,strong) UIImage        *image;
@property (nonatomic,strong) NSString       *currentStr;
@property (nonatomic)        BOOL           isOnFirst;
@property (nonatomic,weak)   id <XTPasterViewDelegate> delegate ;
-(instancetype)initWithBgView:(CGRect )frame isImage:(BOOL)isImage;
- (void)remove ;

@end
