//
//  MenuViewController.m
//  RIM-Map-WhirlyGlobe
//
//  Created by Jerald Abille on 9/29/15.
//  Copyright © 2015 Acacus Technologies. All rights reserved.
//

#import "MenuViewController.h"
#import "ViewController.h"
#import "Common.h"
#import "Constants.h"

@interface MenuViewController ()
{

}
@end

#define kTagMapType             1
#define kTagDestinationMarkers  2
#define kTagGeodesicLine        3
#define kTagWaypointMarkers     4

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Options";
    self.navigationItem.rightBarButtonItem = nil;
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton sizeToFit];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    self.navigationItem.rightBarButtonItem = doneBarButton;
    [doneButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.allowsSelection = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self setupSegmentedControl];
    [self setupSwitches];
}

- (void)done {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupSegmentedControl {
    if (![[Common userDefaults] objectForKey:kShowMapKey]) {
        mapTypeSegmentedControl.selectedSegmentIndex = 0;
    } else {
        if ([[[Common userDefaults] objectForKey:kShowMapKey] isEqualToString:@"Globe"]) {
            mapTypeSegmentedControl.selectedSegmentIndex = 0;
        } else {
            mapTypeSegmentedControl.selectedSegmentIndex = 1;
        }
    }
}

- (IBAction)mapTypeDidChangeValue:(id)sender {
    [self.delegate switchCurrentView];
}

- (void)setupSwitches {
    destinationMarkersSwitch.on = [[Common userDefaults] boolForKey:kShowDestinationMarkersKey];
    geodesicLinesSwitch.on = [[Common userDefaults] boolForKey:kShowGeodesicLineKey];
    waypointMarkersSwitch.on = [[Common userDefaults] boolForKey:kShowWaypointMarkersKey];
}

- (IBAction)switchDidChangeValue:(id)sender {
    UISwitch *theSwitch = (UISwitch *)sender;
    BOOL isOn = theSwitch.isOn;
    switch (theSwitch.tag) {
        case kTagDestinationMarkers:
            [self.delegate showDestinationMarkers:isOn];
            [Common defaultsSetBool:isOn forKey:kShowDestinationMarkersKey];
            break;
        case kTagGeodesicLine:
            [self.delegate showGeodesicLine:isOn];
            [Common defaultsSetBool:isOn forKey:kShowGeodesicLineKey];
            break;
        case kTagWaypointMarkers:
            [self.delegate showWaypointMarkers:isOn];
            [Common defaultsSetBool:isOn forKey:kShowWaypointMarkersKey];
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 3;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
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
