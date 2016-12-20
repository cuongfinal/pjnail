//
//  ServicesCell.h
//  PJNails
//
//  Created by LQTCuong on 12/20/16.
//  Copyright © 2016 LQTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface ServicesCell : SWTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblEmployee;
@property (weak, nonatomic) IBOutlet UILabel *lblServicesName;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblShopFee;
@property (weak, nonatomic) IBOutlet UITextField *tfTip;
@end
