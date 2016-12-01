//
//  LeftSideBarController.m
//  PJNails
//
//  Created by lehongphong on 12/2/16.
//  Copyright © 2016 LQTC. All rights reserved.
//

#import "LeftSideBarController.h"
#import "SWRevealViewController.h"
@implementation LeftSideBarController

-(void)setUpLeftSideBar{
    SWRevealViewController *revealController = [self revealViewController];
    
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
}
@end
