//
//  MPKitRadar.m
//
//  Copyright 2016 mParticle, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "MPKitRadar.h"
#if defined(__has_include) && __has_include(<RadarSDK/RadarSDK.h>)
#import <RadarSDK/RadarSDK.h>
#else
#import "RadarSDK.h"
#endif

static NSString * const KEY_PUBLISHABLE_KEY = @"publishableKey";
static NSString * const KEY_RUN_AUTOMATICALLY = @"runAutomatically";
static NSString * const kMPUserIdentityTypeKey = @"n";
static NSString * const kMPUserIdentityIdKey = @"i";

NSUInteger MPKitInstanceCompanyName = 117;

@interface MPKitRadar() {
    BOOL runAutomatically;
}

@end

@implementation MPKitRadar

+ (NSNumber *)kitCode {
    return @117;
}

+ (void)load {
    MPKitRegister *kitRegister = [[MPKitRegister alloc] initWithName:@"Radar" className:@"MPKitRadar"];
    [MParticle registerExtension:kitRegister];
}

- (void)tryStartTracking {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    BOOL hasAuthorized = status == kCLAuthorizationStatusAuthorizedAlways;

    if (hasAuthorized) {
        [Radar startTracking];
    }
}

- (void)tryTrackOnce {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    BOOL hasAuthorized = status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse;

    if (hasAuthorized) {
        [Radar trackOnceWithCompletionHandler:nil];
    }
}

#pragma mark - MPKitInstanceProtocol methods

#pragma mark Kit instance and lifecycle
- (MPKitExecStatus *)didFinishLaunchingWithConfiguration:(NSDictionary *)configuration {
    MPKitExecStatus *execStatus = nil;

    NSString *publishableKey = configuration[KEY_PUBLISHABLE_KEY];
    runAutomatically = [(NSNumber *)configuration[KEY_RUN_AUTOMATICALLY] boolValue];

    if (!publishableKey) {
        execStatus = [[MPKitExecStatus alloc] initWithSDKCode:[[self class] kitCode] returnCode:MPKitReturnCodeRequirementsNotMet];
        return execStatus;
    }

    [Radar initializeWithPublishableKey:publishableKey];

    for (NSDictionary<NSString *, id> *userIdentity in self.userIdentities) {
        MPUserIdentity identityType = (MPUserIdentity)[userIdentity[kMPUserIdentityTypeKey] integerValue];
        NSString *identityString = userIdentity[kMPUserIdentityIdKey];

        if (identityType == MPUserIdentityCustomerId) {
            [Radar setUserId:identityString];
            break;
        }
    }

    _configuration = configuration;

    [self start];

    execStatus = [[MPKitExecStatus alloc] initWithSDKCode:[[self class] kitCode] returnCode:MPKitReturnCodeSuccess];
    return execStatus;
}

- (void)start {
    static dispatch_once_t kitPredicate;

    dispatch_once(&kitPredicate, ^{
        _started = YES;

        if (runAutomatically) {
            [self tryTrackOnce];
            [self tryStartTracking];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *userInfo = @{mParticleKitInstanceKey:[[self class] kitCode]};
            [[NSNotificationCenter defaultCenter] postNotificationName:mParticleKitDidBecomeActiveNotification object:nil userInfo:userInfo];
        });
    });
}

- (id const)providerKitInstance {
    return nil;
}

#pragma mark Application

- (MPKitExecStatus *)didBecomeActive {
    if (runAutomatically) {
        [self tryTrackOnce];
    }

    return [[MPKitExecStatus alloc] initWithSDKCode:[MPKitRadar kitCode] returnCode:MPKitReturnCodeSuccess];
}

#pragma mark Events

- (MPKitExecStatus *)logout {
    if (runAutomatically) {
        [Radar stopTracking];
    }

    return [[MPKitExecStatus alloc] initWithSDKCode:[MPKitRadar kitCode] returnCode:MPKitReturnCodeSuccess];
}

#pragma mark User attributes and identities

- (MPKitExecStatus *)setUserIdentity:(NSString *)identityString identityType:(MPUserIdentity)identityType {
    if (identityType == MPUserIdentityCustomerId) {
        [Radar setUserId:identityString];

        if (runAutomatically) {
            [self tryTrackOnce];
            [self tryStartTracking];
        }
    }

    return [[MPKitExecStatus alloc] initWithSDKCode:[MPKitRadar kitCode] returnCode:MPKitReturnCodeSuccess];
}

#pragma mark Assorted

- (MPKitExecStatus *)setOptOut:(BOOL)optOut {
    if (runAutomatically) {
        [Radar stopTracking];
    }

    return [[MPKitExecStatus alloc] initWithSDKCode:[MPKitRadar kitCode] returnCode:MPKitReturnCodeSuccess];
}

@end
