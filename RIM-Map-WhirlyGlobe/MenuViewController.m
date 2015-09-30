//
//  MenuViewController.m
//  RIM-Map-WhirlyGlobe
//
//  Created by Jerald Abille on 9/29/15.
//  Copyright © 2015 Jerald Abille. All rights reserved.
//

#import "MenuViewController.h"
#import "ViewController.h"

@interface MenuViewController ()
{
    NSMutableArray *menuItems;
}
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Menu";
    self.navigationItem.rightBarButtonItem = nil;
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton sizeToFit];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    self.navigationItem.rightBarButtonItem = doneBarButton;
    [doneButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    
    menuItems = [[NSMutableArray alloc] initWithObjects:@"Origin and Destination", @"Geodesic Line", @"Waypoint Markers", @"Waypoint Lines", nil];
    self.tableView.allowsSelection = NO;
    [self.delegate showDestinationMarkers];
}

- (void)done {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return menuItems.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    UINavigationController *navVC = (UINavigationController *)self.presentingViewController;
    ViewController *vc = (ViewController *)[[navVC viewControllers] lastObject];
    if (!vc.originAndDestinationMarkers) {
        
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
    UINavigationController *navVC = (UINavigationController *)self.presentingViewController;
    ViewController *vc = (ViewController *)[[navVC viewControllers] lastObject];
    if (vc.originAndDestinationMarkers) {
        
    }
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
