//
//  SearchCustomerViewController.h
//  PJNails
//
//  Created by lehongphong on 12/25/16.
//  Copyright © 2016 LQTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "AddServicePopupController.h"

@interface SearchCustomerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,SWTableViewCellDelegate,AddServicePopupControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tfCustomerName;
@property (strong, nonatomic) IBOutlet UIView *btnSearch;
- (IBAction)tapSearch:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tbResultList;
@property (strong, nonatomic) NSString* token;
@property (strong, nonatomic) NSString *customerIDRegistered;
@property (weak, nonatomic) IBOutlet UIButton *btnAddService;
- (IBAction)tapAdd:(id)sender;
@property (nonatomic, strong) UIPopoverController *addServicesPopover;
@end
