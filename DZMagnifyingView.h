//
//  CWMagnifyingView.h
//  colorwheel
//
//  Created by Dan Zimmerman on 2/2/14.
//  Copyright (c) 2014 Dan Zimmerman. All rights reserved.
//

/*
 * @zdocs filedescription
 *
 * @title DZMagnifyingView Class Reference
 *
 * @@ This is a UIView subclass that acts like a magnifying glass.
 *
 * @Discussion You can initialize this class like an ordinary view with one caveat: the width and height should be the same, the behavior is unknown otherwise.
 */

#import <UIKit/UIKit.h>

@interface DZMagnifyingView : UIView {
    UIImage *fullImage;
    CGAffineTransform rotationTransform;
    BOOL animating;
    CALayer *imageLayer;
    CAShapeLayer *borderLayer;
    BOOL queueHide;
}
/*
 * @description The radius of what you want to magnify. Probably should be smaller than the size of the magnifying view if you want to magnify something
 */
@property (nonatomic) CGFloat closeupRadius;
/*
 * @description The center of what you want to magnify.
 */
@property (nonatomic) CGPoint closeupCenter;
/*
 * @description The actual view you want to magnify.
 *
 * @discussion If you want to update the cache of the view (something has changed on screen since you last set the targetView), just set this again with the same view. The device doesn't perform well automatically recaching everyframe or so, or even whenever you change the center of this view, so we require you to tell us to cache it instead.
 */
@property (nonatomic) UIView *targetView;

/*
 * @description Don't call -addSubview: with this view as the arguement manually on `targetView`, call this instead once you have set [closeupRadius](#closeupRadius), [closeupCenter](#closeupCenter) and [targetView](#targetView).
 *
 * @discussion You should set the center of the magnifying glass before calling this (or set the frame, just move it somewhere).
 */
- (void)show;
/*
 * @description Don't call -removeFromSuperview manually, call this instead.
 */
- (void)hide;

@end
