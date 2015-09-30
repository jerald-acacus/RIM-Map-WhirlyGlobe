//
//  Common.h
//  RIM-Map-WhirlyGlobe
//
//  Created by Jerald Abille on 9/30/15.
//  Copyright © 2015 Acacus Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WhirlyGlobeComponent.h>

@interface Common : NSObject

+ (nonnull UIStoryboard *)storyBoard;

+ (nonnull NSUserDefaults *)userDefaults;
+ (BOOL)defaultsSetObject:(nullable id)value forKey:(nonnull NSString *)key;
+ (BOOL)defaultsSetBool:(BOOL)value forKey:(nonnull NSString *)key;

+ (nonnull MaplyQuadImageTilesLayer *)earthLayer;

@end
