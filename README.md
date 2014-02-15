DZMagnifierView
===
I was creating a color picker when I decided that I needed a magnifying glass similar to the one created when one taps and holds text on iOS. I present `DZMagnifierView` the class for all of your magnifying needs!

## Documentation
### Tutorial
You initialize this view just like you would with any other UIView:
```Objective-C
    DZMagnifierView *magnifier = [[DZMagnifierView alloc] initWithFrame:CGRectMake(0,0,100,100)];
```
Note that the width and height should be the same, not doing so will result in undefined behavior. The actual radius of the glass will be half the width (and likewise half the height if you're doing this properly). From here you need to specify the view you want to magnify:
```Objective-C
    magnifier.targetView = aview;
```
Finally you specify the origin, or center of the magnifier view in the coordinates of the target view's window, and you specify the closeupCenter (the portion of the target view you want magnified) in the target view's coordinates:
```Objective-C
    CGPoint touchPointInTargetView;
    magnifier.center = CGPointMake(touchPointInTargetView.x, touchPointInTargetView.y - 50);
    magnifier.closeupCenter = touchPointInTargetView;
```
The API is designed so that you can place the magnifying glass wherever you want on screen and magnify a totally different part of the screen. Why you ask is this? Flexibility is always nice; also, let's say you were going to use this magnifying glass when someone touches a view, then you wouldn't want the magnifying glass center to line up with the touch itself, you would want the magnifying glass to float above the touch (similar to the example above) so that you can see what you're touching (note here that it is assumed you are trying to magnify what you are touching).

Pull requests are welcome, hopefully people enjoy!

###License: MIT
