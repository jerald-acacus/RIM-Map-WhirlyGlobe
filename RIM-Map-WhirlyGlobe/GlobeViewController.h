//
//  GlobeViewController.h
//  RIM-Map-WhirlyGlobe
//
//  Created by Jerald Abille on 9/22/15.
//  Copyright © 2015 Jerald Abille. All rights reserved.
//

#import "ViewController.h"

@interface GlobeViewController : WhirlyGlobeViewController

@property (nonatomic, strong) MaplyScreenMarker *currentLocationMarker;

- (void)setZoomLimitsMin:(float)minHeight max:(float)maxHeight withInitialHeight:(float)initialHeight;
- (void)setStartingCoordinatesLong:(float)lon lang:(float)lan;

@end
