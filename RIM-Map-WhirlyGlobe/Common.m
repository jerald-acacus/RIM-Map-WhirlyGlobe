//
//  Common.m
//  RIM-Map-WhirlyGlobe
//
//  Created by Jerald Abille on 9/30/15.
//  Copyright © 2015 Acacus Technologies. All rights reserved.
//

#import "Common.h"

@implementation Common

+ (nonnull UIStoryboard *)storyBoard {
    return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}

+ (nonnull NSUserDefaults *)userDefaults {
    return [NSUserDefaults standardUserDefaults];
}

+ (BOOL)defaultsSetObject:(nullable id)value forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)defaultsSetBool:(BOOL)value forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
