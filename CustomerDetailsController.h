//
//  CustomerDetailsController.h
//  PJNails
//
//  Created by lehongphong on 12/4/16.
//  Copyright © 2016 LQTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerModel.h"

@interface CustomerDetailsController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblBirthday;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblTelephone;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblShopID;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;

@property (strong, nonatomic) NSMutableArray *arrDetails;
-(void)displayDetails:(CustomerModel*)model;
@end
