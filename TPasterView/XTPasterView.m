//
//  XTPasterView.m
//  XTPasterManager
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import "XTPasterView.h"

#define PASTER_SLIDE        100.0
#define FLEX_SLIDE          10.0
#define BT_SLIDE            20.0
#define BORDER_LINE_WIDTH   1.0
#define SECURITY_LENGTH     75.0


@interface XTPasterView ()
{
    CGFloat minWidth;
    CGFloat minHeight;
    CGFloat deltaAngle;
    CGPoint prevPoint;
    CGPoint touchStart;
    CGSize  prevSize;
    BOOL  isLab;
}
@property (nonatomic,strong) UIImageView    *btDelete ;
@property (nonatomic,strong) UIImageView    *btSizeCtrl ;

@end

@implementation XTPasterView



#pragma mark -- Initial
- (instancetype)initWithBgView:(CGRect )frame isImage:(BOOL)isImage{
    self = [super init];
    if (self)
    {
        prevSize = frame.size;
        [self setupWithBGFrame:frame] ;
        if (isImage == YES) {
            [self addSubview:self.imgContentView];
        } else{
            [self addSubview:self.contentLab];
        }
        //删除按钮
        [self btDelete] ;
        //旋转按钮
        [self btSizeCtrl] ;
        self.isOnFirst = YES ;
       
        
        
    }
    return self;
}
-(void)setImage:(UIImage *)image{
    self.imgContentView.image = image;
}
-(void)setCurrentStr:(NSString *)currentStr{
    self.contentLab.text = currentStr;
}
- (void)setupWithBGFrame:(CGRect)bgFrame
{
    self.frame = bgFrame ;
//    self.center = CGPointMake(bgFrame.size.width / 2, bgFrame.size.height / 2) ;
//    self.backgroundColor = [UIColor yellowColor] ;
    self.userInteractionEnabled = YES ;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)] ;
    [self addGestureRecognizer:tapGesture] ;
    UIPinchGestureRecognizer *pincheGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)] ;
    [self addGestureRecognizer:pincheGesture] ;
    UIRotationGestureRecognizer *rotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)] ;
    [self addGestureRecognizer:rotateGesture] ;
    minWidth   = self.bounds.size.width * 0.5;
    minHeight  = self.bounds.size.height * 0.5;
    deltaAngle = atan2(self.frame.origin.y+self.frame.size.height - self.center.y,
                       self.frame.origin.x+self.frame.size.width - self.center.x) ;

}

- (void)tap:(UITapGestureRecognizer *)tapGesture
{
    NSLog(@"tap paster become first respond") ;
    self.isOnFirst = YES ;
//    [self.delegate makePasterBecomeFirstRespond:self.pasterID] ;
}

- (void)handlePinch:(UIPinchGestureRecognizer *)pinchGesture
{
    self.isOnFirst = YES ;
//    [self.delegate makePasterBecomeFirstRespond:self.pasterID] ;

    self.imgContentView.transform = CGAffineTransformScale(self.imgContentView.transform,
                                                           pinchGesture.scale,
                                                           pinchGesture.scale) ;
    self.contentLab.transform = CGAffineTransformScale(self.contentLab.transform,
                                                           pinchGesture.scale,
                                                           pinchGesture.scale) ;
    pinchGesture.scale = 1 ;
}

- (void)handleRotation:(UIRotationGestureRecognizer *)rotateGesture
{
    self.isOnFirst = YES ;
//    [self.delegate makePasterBecomeFirstRespond:self.pasterID] ;

    self.transform = CGAffineTransformRotate(self.transform, rotateGesture.rotation) ;
    rotateGesture.rotation = 0 ;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.isOnFirst = YES ;
//    [self.delegate makePasterBecomeFirstRespond:self.pasterID] ;

    UITouch *touch = [touches anyObject] ;
    touchStart = [touch locationInView:self.superview] ;
}
- (void)translateUsingTouchLocation:(CGPoint)touchPoint
{
    CGPoint newCenter = CGPointMake(self.center.x + touchPoint.x - touchStart.x,
                                    self.center.y + touchPoint.y - touchStart.y) ;
    // Ensure the translation won't cause the view to move offscreen. BEGIN
    CGFloat midPointX = CGRectGetMidX(self.bounds) ;
    if (newCenter.x > self.superview.bounds.size.width - midPointX + SECURITY_LENGTH)
    {
        newCenter.x = self.superview.bounds.size.width - midPointX + SECURITY_LENGTH;
    }
    if (newCenter.x < midPointX - SECURITY_LENGTH)
    {
        newCenter.x = midPointX - SECURITY_LENGTH;
    }
    CGFloat midPointY = CGRectGetMidY(self.bounds);
    if (newCenter.y > self.superview.bounds.size.height - midPointY + SECURITY_LENGTH)
    {
        newCenter.y = self.superview.bounds.size.height - midPointY + SECURITY_LENGTH;
    }
    if (newCenter.y < midPointY - SECURITY_LENGTH)
    {
        newCenter.y = midPointY - SECURITY_LENGTH;
    }
    // Ensure the translation won't cause the view to move offscreen. END
    self.center = newCenter;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(self.btSizeCtrl.frame, touchLocation)) {
        return;
    }
    
    CGPoint touch = [[touches anyObject] locationInView:self.superview];
    
    [self translateUsingTouchLocation:touch] ;
    
    touchStart = touch;
}
- (void)resizeTranslate:(UIPanGestureRecognizer *)recognizer{
    if ([recognizer state] == UIGestureRecognizerStateBegan)
    {
        //开始的位置
        prevPoint = [recognizer locationInView:self];
        [self setNeedsDisplay];
    }
    else if ([recognizer state] == UIGestureRecognizerStateChanged)
    {
        // preventing from the picture being shrinked too far by resizing
        if (self.bounds.size.width < minWidth || self.bounds.size.height < minHeight)
        {
            self.bounds = CGRectMake(self.bounds.origin.x,
                                     self.bounds.origin.y,
                                     minWidth + 1 ,
                                     minHeight + 1);
            self.imgContentView.frame = CGRectMake(FLEX_SLIDE, FLEX_SLIDE, minWidth + 1 - BT_SLIDE, minHeight + 1 -BT_SLIDE);
            self.contentLab.frame = CGRectMake(FLEX_SLIDE, FLEX_SLIDE, minWidth + 1 - BT_SLIDE, minHeight + 1 -BT_SLIDE);
            self.btSizeCtrl.frame =CGRectMake(self.bounds.size.width-BT_SLIDE,
                                              self.bounds.size.height-BT_SLIDE,
                                              BT_SLIDE,
                                              BT_SLIDE);
            prevPoint = [recognizer locationInView:self];
        }
        // Resizing
        else
        {
            CGPoint point = [recognizer locationInView:self];
            float wChange = 0.0, hChange = 0.0;
            
            wChange = (point.x - prevPoint.x);
            float wRatioChange = (wChange/(float)self.bounds.size.width);
//            self.contentLab.font = [UIFont systemFontOfSize:15 * wRatioChange];
            hChange = wRatioChange * self.bounds.size.height;
            
            if (ABS(wChange) > 50.0f || ABS(hChange) > 50.0f)
            {
                prevPoint = [recognizer locationOfTouch:0 inView:self];
                return;
            }
            
            CGFloat finalWidth  = self.bounds.size.width + (wChange) ;
            CGFloat finalHeight = self.bounds.size.height + (wChange) ;
            
            if (finalWidth > prevSize.width*(1+0.5))
            {
                finalWidth = prevSize.width*(1+0.5) ;
            }
            if (finalWidth < prevSize.width*(1-0.5))
            {
                finalWidth = prevSize.width*(1-0.5) ;
            }
            if (finalHeight > prevSize.height*(1+0.5))
            {
                finalHeight = prevSize.height*(1+0.5) ;
            }
            if (finalHeight < prevSize.height*(1-0.5))
            {
                finalHeight = prevSize.height*(1-0.5) ;
            }
            
            self.bounds = CGRectMake(self.bounds.origin.x,
                                     self.bounds.origin.y,
                                     finalWidth,
                                     finalHeight) ;
            self.imgContentView.frame = CGRectMake(FLEX_SLIDE, FLEX_SLIDE, finalWidth - BT_SLIDE, finalHeight -BT_SLIDE);
            self.contentLab.frame = CGRectMake(FLEX_SLIDE, FLEX_SLIDE, finalWidth - BT_SLIDE, finalHeight -BT_SLIDE);
            self.btSizeCtrl.frame = CGRectMake(self.bounds.size.width-BT_SLIDE  ,
                                               self.bounds.size.height-BT_SLIDE ,
                                               BT_SLIDE ,
                                               BT_SLIDE) ;
            
            prevPoint = [recognizer locationOfTouch:0
                                             inView:self] ;
        }
        
        /* Rotation */
        float ang = atan2([recognizer locationInView:self.superview].y - self.center.y,
                          [recognizer locationInView:self.superview].x - self.center.x) ;
        
        float angleDiff = deltaAngle - ang ;
        
        self.transform = CGAffineTransformMakeRotation(-angleDiff) ;
        
        [self setNeedsDisplay] ;
    }
    else if ([recognizer state] == UIGestureRecognizerStateEnded)
    {
        prevPoint = [recognizer locationInView:self];
        [self setNeedsDisplay];
    }
}

#pragma mark -- Properties
- (void)setIsOnFirst:(BOOL)isOnFirst
{
    _isOnFirst = isOnFirst ;
    self.btDelete.hidden = !isOnFirst ;
    self.btSizeCtrl.hidden = !isOnFirst ;
    //图片
    self.imgContentView.layer.borderWidth = isOnFirst ? BORDER_LINE_WIDTH : 0.0f ;
    self.imgContentView.layer.borderColor = isOnFirst ? [UIColor redColor].CGColor : [UIColor clearColor].CGColor;
    //文字
    self.contentLab.layer.borderWidth = isOnFirst ? BORDER_LINE_WIDTH : 0.0f ;
    self.contentLab.layer.borderColor = isOnFirst ? [UIColor redColor].CGColor : [UIColor clearColor].CGColor;
    
    if (isOnFirst)
    {
//        NSLog(@"pasterID : %d is On",self.pasterID) ;
    }
}

- (UIImageView *)imgContentView{
    if (!_imgContentView){
        _imgContentView = [[UIImageView alloc] init] ;
        _imgContentView.frame = CGRectMake(FLEX_SLIDE, FLEX_SLIDE, prevSize.width - BT_SLIDE, prevSize.height -BT_SLIDE);
//        _imgContentView.backgroundColor = [UIColor redColor] ;
        _imgContentView.layer.borderColor = [UIColor clearColor].CGColor ;
        _imgContentView.layer.borderWidth = BORDER_LINE_WIDTH ;
        _imgContentView.contentMode = UIViewContentModeScaleAspectFit ;
//        if (![_imgContentView superview])
//        {
//            [self addSubview:_imgContentView];
//        }
    }
    return _imgContentView ;
}
-(UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [[UILabel alloc]init];
        _contentLab.frame = CGRectMake(FLEX_SLIDE, FLEX_SLIDE, prevSize.width - BT_SLIDE, prevSize.height - BT_SLIDE);
//        _contentLab.backgroundColor = [UIColor redColor] ;
        _contentLab.textAlignment = NSTextAlignmentCenter;
        _contentLab.font = [UIFont systemFontOfSize:15];
        _contentLab.textColor = [UIColor redColor];
        _contentLab.layer.borderColor = [UIColor clearColor].CGColor ;
        _contentLab.layer.borderWidth = BORDER_LINE_WIDTH ;
    }
    return  _contentLab;
}

- (UIImageView *)btSizeCtrl{
    if (!_btSizeCtrl){
        _btSizeCtrl = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - BT_SLIDE  ,
                                                                        self.frame.size.height - BT_SLIDE ,
                                                                        BT_SLIDE ,
                                                                        BT_SLIDE)
                            ] ;
        _btSizeCtrl.userInteractionEnabled = YES;
        _btSizeCtrl.image = [UIImage imageNamed:@"bt_paster_transform"] ;
        UIPanGestureRecognizer *panResizeGesture = [[UIPanGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(resizeTranslate:)] ;
        [_btSizeCtrl addGestureRecognizer:panResizeGesture] ;
        if (![_btSizeCtrl superview]) {
            [self addSubview:_btSizeCtrl] ;
        }
    }
    return _btSizeCtrl ;
}

- (UIImageView *)btDelete
{
    if (!_btDelete)
    {
//        CGRect btRect = CGRectZero ;
//        btRect.size = CGSizeMake(BT_SLIDE, BT_SLIDE) ;
        CGRect btRect = CGRectMake(0, 0, BT_SLIDE, BT_SLIDE);
        _btDelete = [[UIImageView alloc]initWithFrame:btRect] ;
        _btDelete.userInteractionEnabled = YES;
        _btDelete.image = [UIImage imageNamed:@"bt_paster_delete"] ;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(btDeletePressed:)] ;
        [_btDelete addGestureRecognizer:tap] ;
        if (![_btDelete superview]) {
            [self addSubview:_btDelete] ;
        }
    }
    
    return _btDelete ;
}

- (void)btDeletePressed:(id)btDel
{
    NSLog(@"btDel") ;
    [self remove] ;
}
- (void)remove
{
    [self removeFromSuperview] ;
}
//- (void)btOriginalAction
//{
//    [self.delegate clickOriginalButton] ;
//}

@end
