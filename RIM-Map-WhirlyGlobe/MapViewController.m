//
//  MapViewController.m
//  RIM-Map-WhirlyGlobe
//
//  Created by Jerald Abille on 9/30/15.
//  Copyright © 2015 Acacus Technologies. All rights reserved.
//

#import "MapViewController.h"
#import "Common.h"

@interface MapViewController () <MaplyViewControllerDelegate>

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.clearColor = (self != nil) ? [UIColor blackColor] : [UIColor whiteColor];
    self.frameInterval = 1;
    [self addLayerToMap];
}

- (void)addLayerToMap {
    [self addLayer:[Common earthLayer]];
}

- (void)setStartingCoordinatesLong:(float)lon lang:(float)lan {
    MaplyCoordinate startPoint = MaplyCoordinateMakeWithDegrees(lon, lan);
    //[self animateToPosition:startPoint time:1.0];
    [self setPosition:startPoint];
}

- (void)setZoomLimitsMin:(float)minHeight max:(float)maxHeight withInitialHeight:(float)initialHeight {
    [self setZoomLimitsMin:minHeight max:maxHeight];
    self.height = initialHeight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
