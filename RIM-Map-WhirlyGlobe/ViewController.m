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

@interface ViewController () <CLLocationManagerDelegate, WhirlyGlobeViewControllerDelegate>
{
    GlobeViewController *globeView;
    CLLocationManager *locationManager;
}
@end

@implementation ViewController

typedef struct
{
    char name[20];
    float lat,lon;
} LocationInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"RIM Map POC";

    globeView = (GlobeViewController *)[self.childViewControllers firstObject];
    globeView.delegate = self;
    
    [self showGeodesicLine];
}

#pragma mark - Actions

- (void)showGeodesicLine {
    MaplyShapeGreatCircle *greatCircle = [[MaplyShapeGreatCircle alloc] init];
    greatCircle.startPt = MaplyCoordinateMakeWithDegrees(55.35, 25.25);
    greatCircle.endPt = MaplyCoordinateMakeWithDegrees(-122.37, 37.617);
    greatCircle.lineWidth = 4.0;
    float angle = [greatCircle calcAngleBetween];
    greatCircle.height = 0.05 * angle / M_PI;
    greatCircle.color = [UIColor redColor];
    NSMutableArray *circles = [[NSMutableArray alloc] init];
    [circles addObject:greatCircle];
    [globeView addShapes:circles desc:nil];
}

#pragma mark - WhirlyGlobeViewControllerDelegate

- (void)globeViewControllerDidStartMoving:(WhirlyGlobeViewController *)viewC userMotion:(bool)userMotion {
    
}

- (void)globeViewController:(WhirlyGlobeViewController *)viewC didMove:(MaplyCoordinate *)corners {
    NSLog(@"heading %f",globeView.heading * M_PI / -180.0);
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
