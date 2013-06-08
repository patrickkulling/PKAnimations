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

#import <CoreGraphics/CoreGraphics.h>
#import "ViewController.h"
#import "MGSequentialCommandGroup.h"
#import "PKMoveAnimation.h"
#import "PKEaseLinear.h"
#import "PKScaleAnimation.h"
#import "PKFadeAnimation.h"
#import "PKEaseBack.h"
#import "PKEaseQuadratic.h"

@interface ViewController ()

@property(nonatomic, strong) UIImageView *rectangle;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createRectangle];
    [self createAnimations];
}

- (void)createRectangle {
    self.rectangle = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"rectangle.png"]];
    [self centerRectangle];

    [self.view addSubview: self.rectangle];
}

- (void)createAnimations {
    MGSequentialCommandGroup *sequence = [[MGSequentialCommandGroup alloc] init];

    [sequence addCommand: [[PKMoveAnimation alloc] initWithView: self.rectangle
                                                       duration: 1.0f
                                                             by: CGPointMake(0.0f, 100.0f)
                                                        options: @{@"ease" : [[PKEaseQuadraticInOut alloc] init], @"delay" : [NSNumber numberWithFloat: 1.3f]}]];

    [sequence addCommand: [[PKScaleAnimation alloc] initWithView: self.rectangle
                                                        duration: 1.3
                                                            from: 1.0f to: 1.3f]];

    [sequence addCommand: [[PKFadeAnimation alloc] initWithView: self.rectangle
                                                        duration: 2.0
                                                            from: 1.0f to: 0.2f]];

    [sequence addCommand: [[PKFadeAnimation alloc] initWithView: self.rectangle
                                                       duration: 0.3
                                                           from: 0.2f to: 1.0f
                                                        options: @{@"delay" : [NSNumber numberWithFloat: 1.3f]}]];

    [sequence addCommand: [[PKMoveAnimation alloc] initWithView: self.rectangle
                                                       duration: 1.0f
                                                             by: CGPointMake(0.0f, -100.0f)
                                                        options: @{@"ease" : [[PKEaseBackOut alloc] init]}]];

    [sequence addCommand: [[PKScaleAnimation alloc] initWithView: self.rectangle
                                                        duration: 0.8
                                                            from: 1.3f to: 1.0f]];

    [sequence execute];
}

- (void)centerRectangle {
    CGSize winSize = self.view.frame.size;
    CGSize size = self.rectangle.frame.size;
    self.rectangle.frame = CGRectMake(winSize.width/2 - size.width/2, winSize.height/2 - size.height, size.width, size.height);
}

@end
