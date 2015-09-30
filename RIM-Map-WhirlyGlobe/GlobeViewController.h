//
//  GlobeViewController.h
//  RIM-Map-WhirlyGlobe
//
//  Created by Jerald Abille on 9/22/15.
//  Copyright © 2015 Acacus Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WhirlyGlobeComponent.h>

@interface GlobeViewController : WhirlyGlobeViewController

@property (nonatomic, strong) MaplyScreenMarker *currentLocationMarker;

- (void)setZoomLimitsMin:(float)minHeight max:(float)maxHeight withInitialHeight:(float)initialHeight;
- (void)setStartingCoordinatesLong:(float)lon lang:(float)lan;

@end
