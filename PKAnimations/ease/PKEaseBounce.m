/*
============================================================================================
 Easing Equations
 (c) 2003 Robert Penner, all rights reserved.
 This work is subject to the terms in http://www.robertpenner.com/easing_terms_of_use.html.
============================================================================================

TERMS OF USE - EASING EQUATIONS

Open source under the BSD License.

All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
    * Neither the name of the author nor the names of contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "PKEaseBounce.h"


@implementation PKEaseBounce {
}
@end

@implementation PKEaseBounceIn {
}

- (CGFloat)getValue: (CGFloat)currentTime startValue: (CGFloat)startValue changeByValue: (CGFloat)changeByValue duration: (CGFloat)duration {
    CGFloat easeOut = [[[PKEaseBounceOut alloc] init] getValue: duration - currentTime
                                                    startValue: 0
                                                 changeByValue: changeByValue
                                                      duration: duration];

    return changeByValue - easeOut + startValue;
}

@end

@implementation PKEaseBounceOut {
}

- (CGFloat)getValue: (CGFloat)currentTime startValue: (CGFloat)startValue changeByValue: (CGFloat)changeByValue duration: (CGFloat)duration {
    if ((currentTime /= duration) < (1 / 2.75))
        return  changeByValue * (7.5625 * currentTime * currentTime) + startValue;

    else if (currentTime < (2 / 2.75))
        return  changeByValue * (7.5625 * (currentTime -= (1.5 / 2.75)) * currentTime + 0.75) + startValue;

    else if (currentTime < (2.5 / 2.75))
        return  changeByValue * (7.5625 * (currentTime -= (2.25 / 2.75)) * currentTime + 0.9375) + startValue;

    return changeByValue * (7.5625 * (currentTime -= (2.625 / 2.75)) * currentTime + 0.984375) + startValue;
}

@end

@implementation PKEaseBounceInOut {
}

- (CGFloat)getValue: (CGFloat)currentTime startValue: (CGFloat)startValue changeByValue: (CGFloat)changeByValue duration: (CGFloat)duration {

    if (currentTime < duration / 2) {
        CGFloat easeIn = [[[PKEaseBounceIn alloc] init] getValue: 2 * currentTime
                                                      startValue: 0
                                                   changeByValue: changeByValue
                                                        duration: duration];
        return easeIn * 0.5 + startValue;
    }
    CGFloat easeOut = [[[PKEaseBounceOut alloc] init] getValue: 2 * currentTime - duration
                                                    startValue: 0
                                                 changeByValue: changeByValue
                                                      duration: duration];
    return easeOut * 0.5 + changeByValue * 0.5 + startValue;
}

@end