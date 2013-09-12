/*
 * Copyright (c) 2013 Patrick Kulling
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PKFadeAnimation.h"
#import "PKEaseLinear.h"
#import "PKAnimationOptionsBuilder.h"
#import "PKAnimationOptions.h"

static const NSString *kGZAnimationKeyPrefix = @"PKFadeAnimation";
static const CGFloat FPS = 30.0f;

@interface PKFadeAnimation ()
@property(nonatomic, weak) UIView *view;
@property(nonatomic) float duration;
@property(nonatomic) float from;
@property(nonatomic) float to;
@property(nonatomic, strong) NSString *animationKey;
@property(nonatomic, strong) CAAnimation *animation;
@property(nonatomic, strong) PKAnimationOptions *options;
@end

@implementation PKFadeAnimation {
}

- (id)initWithView: (UIView *)view duration: (float)duration from: (float)from to: (float)to {
    self = [self initWithView: view duration: duration from: from to: to options: @{}];
    return self;
}

- (id)initWithView: (UIView *)view duration: (float)duration from: (float)from to: (float)to ease: (id <PKEase>)ease {
    self = [self initWithView: view duration: duration from: from to: to options: @{@"ease": ease}];
    return self;
}

- (id)initWithView: (UIView *)view duration: (float)duration from: (float)from to: (float)to options: (NSDictionary *)options {
    if(self = [super init])
    {
        NSAssert(view, @"view is nil!");

        self.view = view;
        self.duration = duration;
        self.from = from;
        self.to = to;
        self.options = [[[PKAnimationOptionsBuilder alloc] init] build: options];

        self.animationKey = [self createAnimationKey];
        self.animation = [self createAnimation];
    }

    return self;    
}

- (void)execute {
    float delay = [self.options.delay floatValue];

    if(delay > 0.0f)
        [self performSelector: @selector(animate) withObject: nil afterDelay: delay];
    else
        [self animate];
}

-(void) animate {
    if([self completesImmediatly]) {
        [self fadeImmediatly];
        [self complete];
    }
    else {
        [self startAnimation];
    }
}

- (BOOL)completesImmediatly {
    return self.duration == 0.0f;
}

- (void)fadeImmediatly {
    self.view.alpha = self.to;
}

- (void)complete {
    if(self.completeHandler != nil) {
        self.completeHandler();
    }
}

- (void)startAnimation {
    self.view.alpha = self.from;
    [self.view.layer addAnimation: self.animation forKey: self.animationKey];
}

- (void)animationDidStart:(CAAnimation *)theAnimation {
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    [self fadeImmediatly];
    [self.view.layer removeAnimationForKey: self.animationKey];
    [self complete];
}

- (NSString *)createAnimationKey {
    return [NSString stringWithFormat: @"%@_%f", kGZAnimationKeyPrefix, [[NSDate date] timeIntervalSince1970]];
}

- (CAAnimation *)createAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    animation.delegate = self;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.repeatCount = 1;
    animation.duration = self.duration;
    animation.values = [self calculateValues];

    return animation;
}

- (NSMutableArray *)calculateValues {
    NSInteger frames = self.duration * FPS;
    float by = (self.to - self.from);

    NSMutableArray* transforms = [NSMutableArray array];

    for(NSUInteger i = 0; i < frames; i++)
    {
        CGFloat value = [self.options.ease getValue: i startValue: self.from changeByValue: by duration: frames];

        [transforms addObject:[NSNumber numberWithFloat: value]];
    }

    return transforms;
}

@end