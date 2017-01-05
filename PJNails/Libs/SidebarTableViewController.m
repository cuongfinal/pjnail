//
//  SidebarTableViewController.m
//  PJNails
//
//  Created by LQTCuong on 1/5/17.
//  Copyright © 2017 LQTC. All rights reserved.
//

#import "SidebarTableViewController.h"
#import "SWRevealViewController.h"

@interface SidebarTableViewController ()

@end
NSArray *menuItems;
@implementation SidebarTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      menuItems = @[@"title", @"billinglist", @"aplist"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return menuItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return cell;
}



@end
