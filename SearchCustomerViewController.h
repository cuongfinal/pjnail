//
//  SearchCustomerViewController.h
//  PJNails
//
//  Created by lehongphong on 12/25/16.
//  Copyright © 2016 LQTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface SearchCustomerViewController : UIViewController <SWTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tfCustomerName;
@property (strong, nonatomic) IBOutlet UIView *btnSearch;
- (IBAction)tapSearch:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tbResultList;
@property (strong, nonatomic) NSString* token;
@end
