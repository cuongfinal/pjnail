//
//  BillingDetailsCell.h
//  PJNails
//
//  Created by LQTCuong on 12/14/16.
//  Copyright © 2016 LQTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface BillingDetailsCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblServicesName;
@property (weak, nonatomic) IBOutlet UILabel *lblEmployeeName;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblShopFee;
@property (weak, nonatomic) IBOutlet UILabel *lblDiscount;
@property (weak, nonatomic) IBOutlet UILabel *lblTips;
@property (weak, nonatomic) IBOutlet UIImageView *imgServices;

@end
