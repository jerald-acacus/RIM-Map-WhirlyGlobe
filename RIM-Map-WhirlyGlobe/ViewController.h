//
//  ViewController.h
//  RIM-Map-WhirlyGlobe
//
//  Created by Jerald Abille on 9/22/15.
//  Copyright © 2015 Acacus Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WhirlyGlobeComponent.h>
#import "MenuViewController.h"

@interface ViewController : UIViewController <MenuViewControllerDelegate>
{

}

//Maply Objects to track which one to remove.
@property (nonatomic, strong) MaplyComponentObject *originAndDestinationMarkers;
@property (nonatomic, strong) MaplyComponentObject *geodesicLines;
@property (nonatomic, strong) MaplyComponentObject *waypointMarkers;
@property (nonatomic, strong) MaplyComponentObject *waypointLines;

@end

