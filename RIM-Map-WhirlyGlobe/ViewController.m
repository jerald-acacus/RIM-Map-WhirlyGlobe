//
//  ViewController.m
//  RIM-Map-WhirlyGlobe
//
//  Created by Jerald Abille on 9/22/15.
//  Copyright © 2015 Jerald Abille. All rights reserved.
//

#import "ViewController.h"
#import <WhirlyGlobeComponent.h>

@interface ViewController () <WhirlyGlobeViewControllerDelegate>

@end

@implementation ViewController
{
    WhirlyGlobeViewController *globeVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"RIM Map POC";
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    globeVC = [[WhirlyGlobeViewController alloc] init];
    [self.view addSubview:globeVC.view];
    globeVC.view.frame = self.view.bounds;
    globeVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    globeVC.clearColor = (globeVC != nil) ? [UIColor blackColor] : [UIColor whiteColor];
    globeVC.frameInterval = 2;
    [globeVC setZoomLimitsMin:0.25 max:1.0];
    globeVC.height = .25f;
    
    MaplyCoordinate startPoint = MaplyCoordinateMakeWithDegrees(55.35, 25.25);
    
    globeVC.keepNorthUp = YES;
    [globeVC animateToPosition:startPoint time:1.0];
    globeVC.keepNorthUp = NO;
    globeVC.delegate = self;
    
    [self addChildViewController:globeVC];
    
    // Add layer to globe
    MaplyMBTileSource *tileSource = [[MaplyMBTileSource alloc] initWithMBTiles:@"geography-class_medres"];
    MaplyQuadImageTilesLayer *layer = [[MaplyQuadImageTilesLayer alloc] initWithCoordSystem:tileSource.coordSys tileSource:tileSource];
    layer.handleEdges = globeVC != nil;
    layer.coverPoles = globeVC != nil;
    layer.requireElev = NO;
    layer.waitLoad = NO;
    layer.drawPriority = 0;
    layer.singleLevelLoading = NO;
    [globeVC addLayer:layer];
    
    UIImage *markerIcon = [UIImage imageNamed:@"marker"];
    MaplyScreenMarker *marker = [[MaplyScreenMarker alloc] init];
    marker.image = markerIcon;
    marker.loc = startPoint;
    marker.size = CGSizeMake(25, 25);
    [globeVC addScreenMarkers:@[marker] desc:nil];
}

- (void)globeViewControllerDidStartMoving:(WhirlyGlobeViewController *)viewC userMotion:(bool)userMotion {
    
}

- (void)showGreatCircle {
    
}

- (void)showWaypoints {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
