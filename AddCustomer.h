//
//  AddCustomer.h
//  PJNails
//
//  Created by lehongphong on 12/5/16.
//  Copyright © 2016 LQTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCustomer : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;
@property (weak, nonatomic) IBOutlet UITextField *txtBirthday;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtTelephone;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UISwitch *swFavorite;
@property (weak, nonatomic) IBOutlet UITextField *txtLastVisit;
@property (weak, nonatomic) IBOutlet UITextField *txtServices;

- (IBAction)clickRegister:(id)sender;
@end
