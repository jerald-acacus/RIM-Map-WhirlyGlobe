//
//  ViewController.m
//  RIM-Map-WhirlyGlobe
//
//  Created by Jerald Abille on 9/22/15.
//  Copyright © 2015 Acacus Technologies. All rights reserved.
//

#import "ViewController.h"
#import <WhirlyGlobeComponent.h>
#import "GlobeViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "MenuViewController.h"
#import "Common.h"
#import "Constants.h"
#import <MaplyComponent.h>
#import "MapViewController.h"

@interface ViewController () <CLLocationManagerDelegate, WhirlyGlobeViewControllerDelegate, MaplyViewControllerDelegate>
{
    NSDictionary *flightData;
    NSDictionary *originPoint;
    NSDictionary *destinationPoint;
    
    GlobeViewController *globeView;
    MapViewController *mapView;
    MaplyBaseViewController *maplyBaseVC;
    CLLocationManager *locationManager;
    
    UIButton *menuButton;
    UIBarButtonItem *menuBarButton;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"RIM Map POC";
    
    menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [menuButton sizeToFit];
    menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    self.navigationItem.rightBarButtonItem = menuBarButton;
    [menuButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    
    [self parseData];
    
    if (![[Common userDefaults] objectForKey:kShowMapKey]) {
        [self setupGlobeView];
    } else {
        if ([[[Common userDefaults] objectForKey:kShowMapKey] isEqualToString:@"Globe"]) { // If kShowMapKey is not set, show map as initial view.
            [self setupGlobeView];
            
        } else if ([[[Common userDefaults] objectForKey:kShowMapKey] isEqualToString:@"Map"]) {
            [self setupMapView];
        }
    }
    
    [self showMapyObjects];
}

- (void)setupGlobeView {
    globeView = [[GlobeViewController alloc] init];
    globeView.view.frame = contentView.bounds;
    [contentView addSubview:globeView.view];
    [self addChildViewController:globeView];
    [globeView didMoveToParentViewController:self];
    
    globeView.delegate = self;
    [globeView setZoomLimitsMin:0.20 max:1.4 withInitialHeight:1];
    [globeView setStartingCoordinatesLong:[originPoint[@"lon"] floatValue] lang:[originPoint[@"lat"] floatValue]];
    maplyBaseVC = globeView;
    
    [Common defaultsSetObject:@"Globe" forKey:kShowMapKey];
}

- (void)setupMapView {
    mapView = [[MapViewController alloc] init];
    mapView.view.frame = contentView.bounds;
    [contentView addSubview:mapView.view];
    [self addChildViewController:mapView];
    NSLog(@"bounds %@",NSStringFromCGRect(contentView.bounds));
    NSLog(@"bounds %@",NSStringFromCGRect(mapView.view.frame));
    mapView.delegate = self;
    [mapView setZoomLimitsMin:0.1 max:10 withInitialHeight:1];
    [mapView setStartingCoordinatesLong:[originPoint[@"lon"] floatValue] lang:[originPoint[@"lat"] floatValue]];
    mapView.autoMoveToTap = NO;
    mapView.rotateGesture = NO;
    maplyBaseVC = mapView;
    
    [Common defaultsSetObject:@"Map" forKey:kShowMapKey];
}

- (void)switchCurrentView {
    if (maplyBaseVC == globeView) {
        NSLog(@"I'm the globe!");
        [self removeViewController:globeView];
        [self setupMapView];
        
    } else {
        NSLog(@"I'm the map!");
        [self removeViewController:mapView];
        [self setupGlobeView];
    }
    [self showMapyObjects];
}

- (void)cycleFromViewController:(UIViewController *)prevVC toViewController:(UIViewController *)newVC {
    [prevVC willMoveToParentViewController:nil];
    [self addChildViewController:newVC];
    
    CGRect endFrame = prevVC.view.frame;
    
    [self transitionFromViewController:prevVC toViewController:newVC duration:0.25 options:0 animations:^{
        newVC.view.frame = prevVC.view.frame;
        prevVC.view.frame = endFrame;
    } completion:^(BOOL finished) {
        [prevVC removeFromParentViewController];
        [newVC didMoveToParentViewController:self];
    }];
}

- (void)removeViewController:(UIViewController *)content {
    [content willMoveToParentViewController:nil];
    [content.view removeFromSuperview];
    [content removeFromParentViewController];
}

- (void)parseData {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sample-data" ofType:@"json"];
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:[[NSData alloc] initWithContentsOfFile:filePath] options:0 error:nil];
    NSLog(@"json data %@",jsonData);
    flightData = jsonData[@"flights"][@"UAE225-1443156000-schedule-0000:0"];
    originPoint = flightData[@"originPoint"];
    destinationPoint = flightData[@"destinationPoint"];
}

- (void)trackUserLocation {
    
}

- (void)showMenu {
    UINavigationController *menuNav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MenuNavController"];
    MenuViewController *menuVC = (MenuViewController *)[[menuNav viewControllers] lastObject];
    menuNav.modalPresentationStyle = UIModalPresentationPopover;
    menuNav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    menuNav.preferredContentSize = CGSizeMake(400, 60 * 4);
    menuVC.delegate = self;
    UIPopoverPresentationController *presentationController = [menuNav popoverPresentationController];
    presentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    presentationController.barButtonItem = menuBarButton;
    [self presentViewController:menuNav animated:YES completion:nil];
}

#pragma mark - MaplyComponentObjects

- (void)showMapyObjects {
    [self showDestinationMarkers:[[Common userDefaults] boolForKey:kShowWaypointMarkersKey]];
    if (maplyBaseVC == globeView) {
        [self showGeodesicLine:[[Common userDefaults] boolForKey:kShowGeodesicLineKey]];
    }
    
    [self showWaypointMarkers:[[Common userDefaults] boolForKey:kShowWaypointMarkersKey]];
}

- (void)showDestinationMarkers:(BOOL)show {
    if (show) {
        CGSize size = CGSizeMake(25, 25);
        UIImage *markerImage = [UIImage imageNamed:@"marker"];
        
        NSMutableArray *markers = [[NSMutableArray alloc] init];
        NSMutableArray *points = [[NSMutableArray alloc] initWithArray:@[originPoint, destinationPoint]];
        for (NSDictionary *point in points) {
            MaplyScreenMarker *marker = [[MaplyScreenMarker alloc] init];
            marker.image = markerImage;
            marker.loc = MaplyCoordinateMakeWithDegrees([point[@"lon"] floatValue], [point[@"lat"] floatValue]);
            marker.size = size;
            marker.layoutImportance = MAXFLOAT;
            [markers addObject:marker];
        }
        _originAndDestinationMarkers = [maplyBaseVC addScreenMarkers:markers desc:nil];
        
    } else {
        [maplyBaseVC removeObject:_originAndDestinationMarkers];
        _originAndDestinationMarkers = nil;
    }
}

- (void)showGeodesicLine:(BOOL)show {
    if (show) {
        MaplyShapeGreatCircle *greatCircle = [[MaplyShapeGreatCircle alloc] init];
        
        greatCircle.startPt = MaplyCoordinateMakeWithDegrees([originPoint[@"lon"] floatValue], [originPoint[@"lat"] floatValue]);
        greatCircle.endPt = MaplyCoordinateMakeWithDegrees([destinationPoint[@"lon"] floatValue], [destinationPoint[@"lat"] floatValue]);
        
        greatCircle.lineWidth = 2.0;
        float angle = [greatCircle calcAngleBetween];
        greatCircle.height = 0.15 * angle / M_PI;
        greatCircle.color = [UIColor blueColor];
        NSMutableArray *circles = [[NSMutableArray alloc] init];
        [circles addObject:greatCircle];
        _geodesicLines = [maplyBaseVC addShapes:circles desc:nil];
        
    } else {
        [maplyBaseVC removeObject:_geodesicLines];
        _geodesicLines = nil;
    }
}

- (void)showWaypointMarkers:(BOOL)show {
    if (show) {
        CGSize size = CGSizeMake(20, 20);
        UIImage *markerImage = [UIImage imageNamed:@"note"];
        
        NSMutableArray *markers = [[NSMutableArray alloc] init];
        NSArray *waypoints = flightData[@"waypoints"];
        NSMutableArray *points = [[NSMutableArray alloc] initWithArray:waypoints];
        for (NSDictionary *point in points) {
            MaplyScreenMarker *marker = [[MaplyScreenMarker alloc] init];
            marker.image = markerImage;
            marker.loc = MaplyCoordinateMakeWithDegrees([point[@"lon"] floatValue], [point[@"lat"] floatValue]);
            marker.size = size;
            marker.layoutImportance = MAXFLOAT;
            marker.userObject = @"test";
            [markers addObject:marker];
            marker.offset = CGPointZero; //CGPointMake(5, 0); // Offset on icon if it doesn't look centered.
        }
        _waypointMarkers = [maplyBaseVC addScreenMarkers:markers desc:nil];
        
        NSMutableArray *vectors = [[NSMutableArray alloc] init];
        MaplyCoordinate coords[points.count];
        for (int x = 0; x < points.count; x++) {
            NSDictionary *point = [points objectAtIndex:x];
            coords[x] = MaplyCoordinateMakeWithDegrees([point[@"lon"] floatValue], [point[@"lat"] floatValue]);
        }
        MaplyVectorObject *vec = [[MaplyVectorObject alloc] initWithLineString:coords numCoords:(int)points.count attributes:nil];
        [vectors addObject:vec];
        NSDictionary *desc = @{kMaplyColor: [UIColor redColor], kMaplySubdivType: kMaplySubdivStatic, kMaplySubdivEpsilon: @(0.001), kMaplyVecWidth: @(2.0)};
        _waypointLines = [maplyBaseVC addVectors:vectors desc:desc];
        
    } else {
        [maplyBaseVC removeObject:_waypointMarkers];
        [maplyBaseVC removeObject:_waypointLines];
        _waypointMarkers = nil;
        _waypointLines = nil;
    }
}

#pragma mark - WhirlyGlobeViewControllerDelegate

- (void)globeViewControllerDidStartMoving:(WhirlyGlobeViewController *)viewC userMotion:(bool)userMotion {
    
}

- (void)globeViewController:(WhirlyGlobeViewController *)viewC didMove:(MaplyCoordinate *)corners {
    // NSLog(@"heading %f",globeView.heading * M_PI / -180.0);
}

- (void)globeViewControllerDidTapOutside:(WhirlyGlobeViewController *)viewC {
    
}

- (void)globeViewController:(WhirlyGlobeViewController *)viewC didSelect:(NSObject *)selectedObj {
    NSLog(@"test");
    if ([selectedObj isKindOfClass:[MaplyScreenMarker class]]) {
        MaplyScreenMarker *selectedMarker = (MaplyScreenMarker *)selectedObj;
        MaplyAnnotation *annotate = [[MaplyAnnotation alloc] init];
        annotate.title = (NSString *)selectedMarker.userObject;
        annotate.subTitle = @"...";
        [globeView clearAnnotations];
        [globeView addAnnotation:annotate forPoint:selectedMarker.loc offset:CGPointZero];
    }
}

- (void)globeViewController:(WhirlyGlobeViewController *)viewC didTapAt:(WGCoordinate)coord {
    [globeView clearAnnotations];
}

#pragma mark - MaplyViewControllerDelegate

- (void)maplyViewController:(MaplyViewController *)viewC didStopMoving:(MaplyCoordinate *)corners userMotion:(bool)userMotion {
    NSLog(@"Map Height %f",mapView.height);
    if (mapView.height <= 0.20) {
        mapView.rotateGesture = YES;
    } else {
        mapView.rotateGesture = NO;
        mapView.heading = 0;
    }
    
}

- (void)maplyViewController:(MaplyViewController *)viewC didSelect:(NSObject *)selectedObj {
    NSLog(@"test");
    if ([selectedObj isKindOfClass:[MaplyScreenMarker class]]) {
        MaplyScreenMarker *selectedMarker = (MaplyScreenMarker *)selectedObj;
        MaplyAnnotation *annotate = [[MaplyAnnotation alloc] init];
        annotate.title = (NSString *)selectedMarker.userObject;
        annotate.subTitle = @"...";
        [mapView clearAnnotations];
        [mapView addAnnotation:annotate forPoint:selectedMarker.loc offset:CGPointZero];
    }
}

- (void)maplyViewController:(MaplyViewController *)viewC didTapAt:(MaplyCoordinate)coord {
    [mapView clearAnnotations];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
