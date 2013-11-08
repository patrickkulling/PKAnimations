## Introduction

This library provides an easy way to chain multiple `CAAnimation`s in sequence and/or parallel.
It also allows you to apply custom or [predefined easing equations](http://easings.net/) to each animation.

## Dependencies
[* MGCommand 0.1.1](https://github.com/MattesGroeger/MGCommand)

## Installation via CocoaPods
Add to Podfile

```
   platform :ios
    pod 'PKAnimations'
   end
```

`pod install`
`pod update`

## Usage
Creating a new Animation is as easy as pie:

```obj-c
[[[PKMoveAnimation alloc] initWithView: self.view
                              duration: 1.0f
                                    by: CGPointMake(0.0f, 100.0f)
                               options: @{@"ease": [[PKEaseBounceOut alloc] init]}] execute];
```

If you want to delay the animation, you can specify the delay inside the 'options' NSDictionary:

```obj-c
[[[PKMoveAnimation alloc] initWithView: self.view
                              duration: 1.0f
                                    by: CGPointMake(0.0f, 100.0f)
                               options: @{@"delay": [NSNumber numberWithFloat: 1.3f]}] execute];
```

For a basic usage, please take a look inside the included `PKAnimationsExample` project.

If you want to find out more about the MGCommand library, please see [MGCommand](https://github.com/MattesGroeger/MGCommand).

## Extending the library
Feel free to add your own Animation commands or easing equations.
All easing equations need to conform to the given `PKEase` protocol:

```obj-c
@protocol PKEase <NSObject>

-(CGFloat)getValue: (CGFloat)currentTime startValue: (CGFloat)startValue changeByValue: (CGFloat)changeByValue duration:(CGFloat)duration;

@end
```

## Changelog

**0.2.3** (11-08-2013)

* [INFO] Remove fixed version for MGCommand dependency

**0.2.2** (10-28-2013)

* [FIX] Out of bounds issues for a duration of 0.0f

**0.2.1** (10-17-2013)

* [FIX] Rounding issues for some Easing functions

**0.2.0** (10-07-2013)

* [FIX] Retain cycle with using CAAnimation
* [FIX] Compiler warnings
* [INFO] bump MGCommand dependency to version 0.2.0 to fix memory leaks

**0.1.2** (06-17-2013)

* [NEW] Add PKAnimations.h header file to import all dependencies at once

**0.1.1** (06-08-2013)

* [NEW] Add new optional parameter 'options' to Move, Scale & FadeAnimation
* [NEW] Add 'delay' support
* [INFO] Add 'ease' as optional parameter support
* [FIX] Single animations can now be executed without wrapping them into a MGCommandGroup

**0.1.0** (06-03-2013)

* [NEW] Add default easing equations
* [NEW] Add Move, Scale & Fade Animation

## Contribution

This library is released under the [MIT licence](http://opensource.org/licenses/MIT). Contributions are more than welcome!

Follow me on Twitter: [@Patrick_Kulling](https://twitter.com/Patrick_Kulling).
