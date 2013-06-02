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

#import "PKEaseElastic.h"

@interface PKEaseElasticIn ()
@property(nonatomic) float amplitude;
@property(nonatomic) float period;
@end

@implementation PKEaseElasticIn {
}

- (id)init {
    if (self = [super init]) {
        self.amplitude = 0.0f;
        self.period = 0.0f;
    }

    return self;
}


- (CGFloat)getValue: (CGFloat)currentTime startValue: (CGFloat)startValue changeByValue: (CGFloat)changeByValue duration: (CGFloat)duration {
    if (currentTime == 0)
        return startValue;

    if ((currentTime /= duration) == 1)
        return startValue + changeByValue;

    if (!self.period)
        self.period = duration * 0.3;

    float s = 0;
    if (!self.amplitude || self.amplitude < abs(changeByValue))
    {
        self.amplitude = changeByValue;
        s = self.period / 4;
    }
    else
    {
        s = self.period / (2 * M_PI) * asin(changeByValue / self.amplitude);
    }

    return -(self.amplitude * pow(2, 10 * (currentTime -= 1)) *
            sin((currentTime * duration - s) * (2 * M_PI) / self.period)) + startValue;
}

@end

@interface PKEaseElasticOut ()
@property(nonatomic) float period;
@property(nonatomic) float amplitude;
@end

@implementation PKEaseElasticOut {
}

- (id)init {
    if (self = [super init]) {
        self.amplitude = 0.0f;
        self.period = 0.0f;
    }

    return self;
}

- (CGFloat)getValue: (CGFloat)currentTime startValue: (CGFloat)startValue changeByValue: (CGFloat)changeByValue duration: (CGFloat)duration {
    if (currentTime == 0)
        return startValue;

    if ((currentTime /= duration) == 1)
        return startValue + changeByValue;

    if (!self.period)
        self.period = duration * 0.3;

    float s = 0;
    if (!self.amplitude || self.amplitude < abs(changeByValue))
    {
        self.amplitude = changeByValue;
        s = self.period / 4;
    }
    else
    {
        s = self.period / (2 * M_PI) * asin(changeByValue / self.amplitude);
    }

    return self.amplitude * pow(2, -10 * currentTime) *
            sin((currentTime * duration - s) * (2 * M_PI) / self.period) + changeByValue + startValue;
}

@end

@interface PKEaseElasticInOut ()
@property(nonatomic) float amplitude;
@property(nonatomic) float period;
@end

@implementation PKEaseElasticInOut {
}

- (id)init {
    if (self = [super init]) {
        self.amplitude = 0.0f;
        self.period = 0.0f;
    }

    return self;
}

- (CGFloat)getValue: (CGFloat)currentTime startValue: (CGFloat)startValue changeByValue: (CGFloat)changeByValue duration: (CGFloat)duration {
    if (currentTime == 0)
        return startValue;

    if ((currentTime /= duration / 2) == 2)
        return startValue + changeByValue;

    if (!self.period)
        self.period = duration * (0.3 * 1.5);

    float s = 0;
    if (!self.amplitude || self.amplitude < abs(changeByValue))
    {
        self.amplitude = changeByValue;
        s = self.period / 4;
    }
    else
    {
        s = self.period / (2 * M_PI) * asin(changeByValue / self.amplitude);
    }

    if (currentTime < 1)
    {
        return -0.5 * (self.amplitude * pow(2, 10 * (currentTime -= 1)) *
                sin((currentTime * duration - s) * (2 * M_PI) /self.period)) + startValue;
    }

    return self.amplitude * pow(2, -10 * (currentTime -= 1)) *
            sin((currentTime * duration - s) * (2 * M_PI) / self.period ) * 0.5 + changeByValue + startValue;
}
@end