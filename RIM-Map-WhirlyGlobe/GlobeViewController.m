//
//  GlobeViewController.m
//  RIM-Map-WhirlyGlobe
//
//  Created by Jerald Abille on 9/22/15.
//  Copyright © 2015 Jerald Abille. All rights reserved.
//

#import "GlobeViewController.h"

@interface GlobeViewController () <WhirlyGlobeViewControllerDelegate>

@end

@implementation GlobeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureGlobe];
    [self addLayerToGlobe];
}

#pragma mark - Configuration Methods

- (void)configureGlobe {
    self.clearColor = (self != nil) ? [UIColor blackColor] : [UIColor whiteColor];
    self.frameInterval = 2;
}

- (void)addLayerToGlobe {
    MaplyMBTileSource *tileSource = [[MaplyMBTileSource alloc] initWithMBTiles:@"Offline-Map"];
    tileSource.minZoom = 0.01;
    MaplyQuadImageTilesLayer *layer = [[MaplyQuadImageTilesLayer alloc] initWithCoordSystem:tileSource.coordSys tileSource:tileSource];
    layer.handleEdges = self != nil;
    layer.coverPoles = self != nil;
    layer.requireElev = NO;
    layer.waitLoad = NO;
    layer.drawPriority = 0;
    layer.singleLevelLoading = NO;
    [self addLayer:layer];
}

- (void)setStartingCoordinatesLong:(float)lon lang:(float)lan {
    self.keepNorthUp = YES;
    MaplyCoordinate startPoint = MaplyCoordinateMakeWithDegrees(lon, lan);
    [self animateToPosition:startPoint time:1.0];
    self.keepNorthUp = NO;
}

- (void)setZoomLimitsMin:(float)minHeight max:(float)maxHeight withInitialHeight:(float)initialHeight {
    [self setZoomLimitsMin:minHeight max:maxHeight];
    self.height = initialHeight;
}

#pragma mark -

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
