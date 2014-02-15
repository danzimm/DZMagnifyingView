//
//  CWMagnifyingView.h
//  colorwheel
//
//  Created by Dan Zimmerman on 2/2/14.
//  Copyright (c) 2014 Dan Zimmerman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZMagnifyingView : UIView {
    UIImage *fullImage;
    CGAffineTransform rotationTransform;
    BOOL animating;
    CALayer *imageLayer;
    CAShapeLayer *borderLayer;
    BOOL queueHide;
}

@property (nonatomic) CGFloat closeupRadius;
@property (nonatomic) CGPoint closeupCenter;
@property (nonatomic) UIView *targetView;

- (void)show;
- (void)hide;

@end
