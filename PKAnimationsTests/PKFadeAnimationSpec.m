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
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import "Kiwi.h"
#import "PKEaseLinear.h"
#import "PKFadeAnimation.h"

SPEC_BEGIN(PKFadeAnimationSpec)
        describe(@"A PKFadeAnimation", ^{
            context(@"when initWithView:duration:from:to:ease: is called", ^{
                __block PKEaseLinear *ease;

                beforeEach(^{
                    ease = [[PKEaseLinear alloc] init];
                });

                context(@"when duration is > 0.0f", ^{
                    it(@"will calculate the position using the given ease", ^{
                        [[ease should] receive: @selector(getValue:startValue:changeByValue:duration:)
                              withCountAtLeast: 1];

                        [[PKFadeAnimation alloc] initWithView: [[UIView alloc] init]
                                                     duration: 1.0f
                                                         from: 0.0
                                                           to: 1.0
                                                         ease: ease];
                    });
                });

                context(@"when duration is 0.0f", ^{
                    it(@"will not call the ease selector", ^{
                        PKEaseLinear *ease = [[PKEaseLinear alloc] init];

                        [[ease shouldNot] receive: @selector(getValue:startValue:changeByValue:duration:)];

                        [[PKFadeAnimation alloc] initWithView: [[UIView alloc] init]
                                                     duration: 1.0f
                                                         from: 0.0
                                                           to: 1.0
                                                         ease: ease];
                    });
                });

                context(@"when view is nil", ^{
                    it(@"will fail", ^{
                        [[theBlock(^
                        {
                            [[PKFadeAnimation alloc] initWithView: nil duration: 1.0f
                                                             from: 0.0
                                                               to: 1.0
                                                             ease: [[PKEaseLinear alloc] init]];
                        }) should] raise];
                    });
                });

                context(@"when ease is nil", ^{
                    it(@"will fail", ^{
                        [[theBlock(^
                        {
                            [[PKFadeAnimation alloc] initWithView: [[UIView alloc] init]
                                                         duration: 1.0f
                                                             from: 0.0
                                                               to: 1.0
                                                             ease: nil];
                        }) should] raise];
                    });
                });
            });

            context(@"when initWithView:duration:from:to: is called", ^{
                it(@"will not fail", ^{
                    [[theBlock(^
                    {
                        [[PKFadeAnimation alloc] initWithView: [[UIView alloc] init]
                                                     duration: 1.0f
                                                         from: 0.0
                                                           to: 1.0];
                    }) shouldNot] raise];
                });
            });

            context(@"when execute: is called", ^{
                __block UIView *view;
                __block float fadeTo;

                beforeEach(^{
                    view = [[UIView alloc] initWithFrame: CGRectZero];
                    fadeTo = 0.85f;
                });

                context(@"when duration is 0.0f", ^{
                    it(@"will fade the view immediatly", ^{
                        PKFadeAnimation *animation = [[PKFadeAnimation alloc] initWithView: view
                                                                                  duration: 0.0f
                                                                                      from: 0.0
                                                                                        to: fadeTo];

                        [animation execute];

                        [[theValue(view.alpha) should] equal: theValue(fadeTo)];
                    });
                });

                context(@"when duration is > 1.0f", ^{
                    it(@"will add the animation", ^{
                        PKFadeAnimation *animation = [[PKFadeAnimation alloc] initWithView: view
                                                                                  duration: 1.0f
                                                                                      from: 0.0
                                                                                        to: fadeTo];

                        [[view.layer should] receive: @selector(addAnimation:forKey:)];

                        [animation execute];
                    });
                });
            });
        });

SPEC_END