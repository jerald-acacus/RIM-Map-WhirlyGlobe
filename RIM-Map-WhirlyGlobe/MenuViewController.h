//
//  MenuViewController.h
//  RIM-Map-WhirlyGlobe
//
//  Created by Jerald Abille on 9/29/15.
//  Copyright © 2015 Acacus Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuViewControllerDelegate <NSObject>
@required
- (void)showDestinationMarkers:(BOOL)show;
- (void)showGeodesicLine:(BOOL)show;
- (void)showWaypointMarkers:(BOOL)show;

- (void)switchCurrentView;

@end

@interface MenuViewController : UITableViewController
{
    IBOutlet UISegmentedControl *mapTypeSegmentedControl;
    IBOutlet UISwitch *destinationMarkersSwitch;
    IBOutlet UISwitch *geodesicLinesSwitch;
    IBOutlet UISwitch *waypointMarkersSwitch;
}

@property (nonatomic, weak) id<MenuViewControllerDelegate>delegate;

- (IBAction)mapTypeDidChangeValue:(id)sender;
- (IBAction)switchDidChangeValue:(id)sender;

@end
