//
//  ViewController.m
//  RIM-Map-WhirlyGlobe
//
//  Created by Jerald Abille on 9/22/15.
//  Copyright © 2015 Jerald Abille. All rights reserved.
//

#import "ViewController.h"
#import <WhirlyGlobeComponent.h>
#import "GlobeViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "MenuViewController.h"

@interface ViewController () <CLLocationManagerDelegate, WhirlyGlobeViewControllerDelegate, MaplyViewControllerDelegate>
{
    NSDictionary *flightData;
    NSDictionary *originPoint;
    NSDictionary *destinationPoint;
    
    GlobeViewController *globeView;
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
    
    globeView = (GlobeViewController *)[self.childViewControllers firstObject];
    globeView.delegate = self;
    [globeView setZoomLimitsMin:0.20 max:1.4 withInitialHeight:1];
    [globeView setStartingCoordinatesLong:[originPoint[@"lon"] floatValue] lang:[originPoint[@"lat"] floatValue]];
    maplyBaseVC = globeView;
    
    //[self showDestinationMarkers];
    [self showWaypointMarkers];
    [self showGeodesicLine];
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
    //MenuViewController *menuVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MenuViewController"];
    UINavigationController *menuNav = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MenuNavController"];
    MenuViewController *menuVC = (MenuViewController *)[[menuNav viewControllers] lastObject];
    menuNav.modalPresentationStyle = UIModalPresentationFormSheet; //UIModalPresentationPopover;
    menuNav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    menuNav.preferredContentSize = CGSizeMake(400, 60 * 5);
    menuVC.delegate = self;
    UIPopoverPresentationController *presentationController = [menuNav popoverPresentationController];
    presentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    presentationController.barButtonItem = menuBarButton;
    [self presentViewController:menuNav animated:YES completion:nil];
}

#pragma mark - Actions

- (void)showGeodesicLine {
    MaplyShapeGreatCircle *greatCircle = [[MaplyShapeGreatCircle alloc] init];
    
    greatCircle.startPt = MaplyCoordinateMakeWithDegrees([originPoint[@"lon"] floatValue], [originPoint[@"lat"] floatValue]);
    greatCircle.endPt = MaplyCoordinateMakeWithDegrees([destinationPoint[@"lon"] floatValue], [destinationPoint[@"lat"] floatValue]);
    
    greatCircle.lineWidth = 2.0;
    float angle = [greatCircle calcAngleBetween];
    greatCircle.height = 0.15 * angle / M_PI;
    greatCircle.color = [UIColor blueColor];
    NSMutableArray *circles = [[NSMutableArray alloc] init];
    [circles addObject:greatCircle];
    _geodesicLines = [globeView addShapes:circles desc:nil];
}

- (void)showDestinationMarkers {
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
    _originAndDestinationMarkers = [globeView addScreenMarkers:markers desc:nil];
}

- (void)hideDestinationMarkers {
    [maplyBaseVC removeObject:_originAndDestinationMarkers];
    _originAndDestinationMarkers = nil;
}

- (void)showWaypointMarkers {
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
    _waypointMarkers = [globeView addScreenMarkers:markers desc:nil];
    
    NSMutableArray *vectors = [[NSMutableArray alloc] init];
    MaplyCoordinate coords[points.count];
    for (int x = 0; x < points.count; x++) {
        NSDictionary *point = [points objectAtIndex:x];
        coords[x] = MaplyCoordinateMakeWithDegrees([point[@"lon"] floatValue], [point[@"lat"] floatValue]);
    }
    MaplyVectorObject *vec = [[MaplyVectorObject alloc] initWithLineString:coords numCoords:(int)points.count attributes:nil];
    [vectors addObject:vec];
    NSDictionary *desc = @{kMaplyColor: [UIColor redColor], kMaplySubdivType: kMaplySubdivStatic, kMaplySubdivEpsilon: @(0.001), kMaplyVecWidth: @(2.0)};
    MaplyBaseViewController *baseVC = globeView;
    _waypointLines = [baseVC addVectors:vectors desc:desc];
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
