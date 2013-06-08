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

#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import "PKMoveAnimation.h"
#import "PKEaseLinear.h"
#import "PKAnimationOptions.h"
#import "PKAnimationOptionsBuilder.h"

static const NSString *kGZAnimationKeyPrefix = @"PKMoveAnimation";
static const CGFloat FPS = 30.0f;

@interface PKMoveAnimation ()
@property(nonatomic, weak) UIView *view;
@property(nonatomic) float duration;
@property(nonatomic) CGPoint by;
@property(nonatomic, strong) PKAnimationOptions *options;
@property(nonatomic, strong) NSString *animationKey;
@property(nonatomic, strong) CAAnimation *animation;
@end

@implementation PKMoveAnimation {
}

- (id)initWithView: (UIView *)view duration: (float)duration by: (CGPoint)by {
    self = [self initWithView: view duration: duration by: by options: @{}];
    return self;
}

- (id)initWithView: (UIView *)view duration: (float)duration by: (CGPoint)by ease: (id <PKEase>)ease {
    self = [self initWithView: view duration: duration by: by options: @{@"ease" : ease}];
    return self;
}

- (id)initWithView: (UIView *)view duration: (float)duration by: (CGPoint)by options: (NSDictionary *)options {
    if (self = [super init]) {
        NSAssert(view, @"view is nil!");

        self.view = view;
        self.duration = duration;
        self.by = by;
        self.options = [[[PKAnimationOptionsBuilder alloc] init] build: options];

        self.animationKey = [self createAnimationKey];
        self.animation = [self createAnimation];
    }

    return self;
}

- (void)dealloc {
	self.animationKey = nil;
	self.animation = nil;
	self.options = nil;
}

- (void)execute {
    float delay = [self.options.delay floatValue];

    if(delay > 0.0f)
        [self performSelector: @selector(animate) withObject: nil afterDelay: delay];
    else
        [self animate];
}

-(void) animate {
    if([self completesImmediatly])
        [self moveImmediatly];
    else
        [self startAnimation];
}

- (BOOL)completesImmediatly {
	return self.duration == 0.0f;
}

- (void)moveImmediatly {
	CGSize size = self.view.frame.size;
	CGPoint newPoint = self.view.frame.origin;
	newPoint.x += self.by.x;
	newPoint.y += self.by.y;

	self.view.frame = CGRectMake(newPoint.x, newPoint.y, size.width, size.height);
}

- (void)startAnimation {
	[self.view.layer addAnimation: self.animation forKey: self.animationKey];
}

- (void)animationDidStart:(CAAnimation *)theAnimation {
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
	CALayer *newLayer = (CALayer *)self.view.layer.presentationLayer;
	self.view.frame = newLayer.frame;

	[self.view.layer removeAnimationForKey: self.animationKey];

	self.completeHandler();
}

- (NSString *)createAnimationKey {
	return [NSString stringWithFormat: @"%@_%f", kGZAnimationKeyPrefix, [[NSDate date] timeIntervalSince1970]];
}

- (CAAnimation *)createAnimation {
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation"];
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
	NSMutableArray* transforms = [NSMutableArray array];

	for(NSUInteger i = 0; i < frames; i++)
	{
		CGFloat xValue = [self.options.ease getValue: i startValue: 0 changeByValue: self.by.x duration: frames];
		CGFloat yValue = [self.options.ease getValue: i startValue: 0 changeByValue: self.by.y duration: frames];

		CGPoint point = CGPointMake(xValue, yValue);
		[transforms addObject:[NSValue valueWithCGPoint: point]];
	}

	return transforms;
}

@end