//
//  PaymentViewController.h
//  PJNails
//
//  Created by LQTCuong on 12/19/16.
//  Copyright © 2016 LQTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "AddTipPopUpViewController.h"

@interface PaymentViewController : UIViewController <SWTableViewCellDelegate,UITableViewDelegate,UITextFieldDelegate, UITableViewDataSource, AddTipPopUpViewControllerDelegate>
-(void)getDetails:(NSString*)billID;
@property (weak, nonatomic) IBOutlet UITableView *tbServicesList;
@property (weak, nonatomic) IBOutlet UILabel *lblTip;
@property (weak, nonatomic) IBOutlet UILabel *lblTotal;
@property (nonatomic, strong) UIPopoverController *addTipPopover;
@property (nonatomic, strong) NSString *tempTotal;
@property (nonatomic, strong) NSString *tempBillID;
@property (weak, nonatomic) IBOutlet UIButton *btnPayment;
- (IBAction)tapPayment:(id)sender;
@end
