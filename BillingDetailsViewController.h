//
//  BillingDetailsViewController.h
//  PJNails
//
//  Created by LQTCuong on 12/12/16.
//  Copyright © 2016 LQTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface BillingDetailsViewController : UIViewController  <SWTableViewCellDelegate,UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *lblPaymentType;
@property (weak, nonatomic) IBOutlet UILabel *lblReceive;
@property (weak, nonatomic) IBOutlet UILabel *lblNote;
@property (weak, nonatomic) IBOutlet UILabel *lblDone;
@property (weak, nonatomic) IBOutlet UILabel *lblBillingDate;
@property (weak, nonatomic) IBOutlet UILabel *lblCustomer;
@property (weak, nonatomic) IBOutlet UILabel *lblTotal;
@property (weak, nonatomic) IBOutlet UILabel *lblShopFee;
@property (weak, nonatomic) IBOutlet UILabel *lblDiscount;
@property (weak, nonatomic) IBOutlet UILabel *lblTip;
@property (weak, nonatomic) IBOutlet UITableView *tbServicesList;
-(void)getDetails:(NSString*)billID;
@end
