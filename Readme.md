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
                                  ease: [[PKEaseBounceOut alloc] init]] execute];
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
**0.1.0** (06-03-2013)

* [NEW] Add default easing equations
* [NEW] Add Move, Scale & Fade Animation

## Contribution

This library is released under the [MIT licence](http://opensource.org/licenses/MIT). Contributions are more than welcome!

Follow me on Twitter: [@Patrick_Kulling](https://twitter.com/Patrick_Kulling).