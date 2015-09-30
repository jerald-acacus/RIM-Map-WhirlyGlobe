//
//  MenuViewController.h
//  RIM-Map-WhirlyGlobe
//
//  Created by Jerald Abille on 9/29/15.
//  Copyright © 2015 Jerald Abille. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuViewControllerDelegate <NSObject>
@required
- (void)showDestinationMarkers;
@end

@interface MenuViewController : UITableViewController
{
    
}

@property (nonatomic, weak) id<MenuViewControllerDelegate>delegate;

@end
