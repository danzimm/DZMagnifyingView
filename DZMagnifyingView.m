//
//  CWMagnifyingView.m
//  colorwheel
//
//  Created by Dan Zimmerman on 2/2/14.
//  Copyright (c) 2014 Dan Zimmerman. All rights reserved.
//

#import "DZMagnifyingView.h"

@implementation DZMagnifyingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.closeupRadius = 10/[[UIScreen mainScreen] scale];
        imageLayer = [CALayer layer];
        imageLayer.frame = self.bounds;
        imageLayer.mask = [CAShapeLayer layer];
        imageLayer.transform = CATransform3DMakeAffineTransform([self transformForOrientation:[[UIApplication sharedApplication] statusBarOrientation]]);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarDidChangeFrame:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
        [self.layer addSublayer:imageLayer];
        borderLayer = [CAShapeLayer layer];
        borderLayer.fillColor = nil;
        borderLayer.strokeColor = [UIColor blackColor].CGColor;
        borderLayer.lineWidth = 0.5;
        [self.layer addSublayer:borderLayer];
        self.layer.shadowOpacity = 0.75;
        self.layer.shadowRadius = 10;
        self.layer.shadowOffset = CGSizeMake(-5, 0);
        [self updateLayers];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    if (!imageLayer)
        return;
    [self updateLayers];
}

- (void)updateLayers {
    UIBezierPath *p = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5) radius:self.frame.size.height*0.5-1 startAngle:0 endAngle:2*M_PI clockwise:NO];
    
    ((CAShapeLayer *)imageLayer.mask).path = p.CGPath;
    borderLayer.path = p.CGPath;
    

    self.layer.shadowPath = p.CGPath;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    imageLayer.frame = self.bounds;
}

- (void)show {
    if (self.superview || animating) {
        return;
    }
    animating = YES;
    self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [self.targetView.window addSubview:self];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:1 options:0 animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        animating = NO;
        [self setNeedsDisplay];
        if (queueHide)
            [self hide];
    }];
}

- (void)hide {
    if (!self.superview || animating) {
        queueHide = animating;
        return;
    }
    queueHide = NO;
    animating = YES;
    self.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.1 animations:^{
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        animating = NO;
        [self removeFromSuperview];
    }];
}

- (void)setCloseupRadius:(CGFloat)closeupRadius {
    _closeupRadius = closeupRadius;
    [self updateSnapshot];
}

- (void)setCloseupCenter:(CGPoint)closeupCenter {
    _closeupCenter = closeupCenter;
    [self updateSnapshot];
}

- (void)setTargetView:(UIView *)targetView {
    _targetView = targetView;
    [self updateFullImage];
}

- (void)updateFullImage {
    UIGraphicsBeginImageContextWithOptions(self.targetView.bounds.size, NO, 0);
    [self.targetView drawViewHierarchyInRect:self.targetView.bounds afterScreenUpdates:YES];
    fullImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

}

- (void)updateSnapshot {
    
    CGRect r;
    r.origin.x = (self.closeupCenter.x - self.closeupRadius) * fullImage.scale;
    r.origin.y = (self.closeupCenter.y - self.closeupRadius) * fullImage.scale;
    r.size.width = r.size.height = 2*self.closeupRadius * fullImage.scale;
    
    CGImageRef img = CGImageCreateWithImageInRect(fullImage.CGImage, r);
    imageLayer.contents = (__bridge id)(img);
    CGImageRelease(img);
    

    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image2.png"];
//    [UIImagePNGRepresentation(snapshotImage) writeToFile:filePath atomically:YES];

}

- (CGAffineTransform)transformForOrientation:(UIInterfaceOrientation)orientation {
    
    switch (orientation) {
            
        case UIInterfaceOrientationLandscapeLeft:
            return CGAffineTransformMakeRotation(-M_PI_2);
            
        case UIInterfaceOrientationLandscapeRight:
            return CGAffineTransformMakeRotation(M_PI_2);
            
        case UIInterfaceOrientationPortraitUpsideDown:
            return CGAffineTransformMakeRotation(M_PI);
            
        case UIInterfaceOrientationPortrait:
        default:
            return CGAffineTransformMakeRotation(0);
    }
}

- (void)statusBarDidChangeFrame:(NSNotification *)notification {
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    imageLayer.transform = CATransform3DMakeAffineTransform([self transformForOrientation:orientation]);
    
}


@end
