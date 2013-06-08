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

#import "Kiwi.h"
#import "PKAnimationOptionsBuilder.h"
#import "PKAnimationOptions.h"
#import "PKEaseLinear.h"
#import "PKEaseBounce.h"

SPEC_BEGIN(PKAnimationOptionsBuilderSpec)

        describe(@"A PKAnimationOptionsBuilder", ^{

            __block PKAnimationOptionsBuilder *builder;

            beforeEach(^{
                builder = [[PKAnimationOptionsBuilder alloc] init];
            });

            context(@"when build: is called", ^{
                context(@"when arguments are empty", ^{
                    it(@"will return an instance of PKAnimationOptions with default values", ^{
                        PKAnimationOptions *options = [builder build: @{}];

                        [[(id) options.ease should] beMemberOfClass: [PKEaseLinear class]];
                        [[options.delay should] equal: [NSNumber numberWithFloat: 0.0f]];
                    });
                });

                context(@"when arguments contain 'ease'", ^{

                    context(@"when 'ease' conforms to protocol", ^{
                        it(@"will return an instance of PKAnimationOptions with defined ease", ^{
                            PKAnimationOptions *options = [builder build: @{@"ease" : [[PKEaseBounceOut alloc] init]}];

                            [[(id) options.ease should] beMemberOfClass: [PKEaseBounceOut class]];
                        });
                    });

                    context(@"when 'ease' is nil", ^{
                        it(@"will return an instance of PKAnimationOptions with defined ease", ^{
                            [[theBlock(^{
                                NSDictionary *arguments = @{};
                                [arguments setValue: nil forKey: @"ease"];

                                [builder build: arguments];

                            }) should] raise];
                        });
                    });

                    context(@"when 'ease' does not conform to protocol", ^{
                        it(@"will raise an exception", ^{
                            [[theBlock(^{
                                [builder build: @{@"ease" : [[NSArray alloc] init]}];

                            }) should] raiseWithName: @"Protocol mismatch"];
                        });
                    });
                });

                context(@"when arguments contain 'delay'", ^{
                    it(@"will return an instance of PKAnimationOptions with defined delay", ^{
                        PKAnimationOptions *options = [builder build: @{@"delay": [NSNumber numberWithFloat: 1.3f]}];

                        [[options.delay should] equal: [NSNumber numberWithFloat: 1.3f]];
                    });
                });

                context(@"when arguments contain unknown PKAnimationOptions property", ^{
                    it(@"will raise an exception", ^{
                        [[theBlock(^{
                            [builder build: @{@"unknown_property" : [[PKEaseBounceOut alloc] init]}];
                        }) should] raiseWithName: @"Invalid key"];
                    });
                });
            });
        });

        SPEC_END