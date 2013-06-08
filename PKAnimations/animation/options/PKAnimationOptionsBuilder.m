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

#import "PKAnimationOptionsBuilder.h"
#import "PKAnimationOptions.h"
#import "PKEase.h"

@interface PKAnimationOptionsBuilder ()
@property(nonatomic, strong) NSDictionary *allowedProtocols;
@property(nonatomic, strong) NSDictionary *allowedClasses;
@end

@implementation PKAnimationOptionsBuilder {
}

- (id)init {
    if (self = [super init]) {
        self.allowedProtocols = @{@"ease" : @protocol(PKEase)};
        self.allowedClasses = @{@"delay" : [NSNumber class]};
    }

    return self;
}

- (void)dealloc {
    self.allowedProtocols = nil;
    self.allowedClasses = nil;
}

- (PKAnimationOptions *)build: (NSDictionary *)arguments {
    PKAnimationOptions *options = [[PKAnimationOptions alloc] init];

    for (NSString *key in arguments) {
        [self apply: key value: [arguments valueForKey: key] to: options];
    }

    return options;
}

- (void)apply: (NSString *)key value: (id)value to: (PKAnimationOptions *)options {
    [self validate: key value: value];

    [options setValue: value forKey: key];
}

- (void)validate: (NSString *)key value: (id)value{
    Protocol *expectedProtocol = [self.allowedProtocols valueForKey: key];
    Class allowedClass = [self.allowedClasses valueForKey: key];

    if (expectedProtocol == nil && allowedClass == nil) {
        [NSException raise: @"Invalid key" format: @"Key: %@ is not expected.", key];
    }

    if (allowedClass && ![value isKindOfClass: allowedClass]) {
        [NSException raise: @"Class mismatch" format: @"Value: %@ for key: %@ does not match expected class: %@.", value, key, allowedClass];
    }

    if (expectedProtocol && ![value conformsToProtocol: expectedProtocol]) {
        [NSException raise: @"Protocol mismatch" format: @"Value: %@ for key: %@ does not match expected protocol: %@.", value, key, expectedProtocol];
    }
}

@end