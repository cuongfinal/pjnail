//
//  CustomerRegisterController.h
//  PJNails
//
//  Created by IVC on 5/5/16.
//  Copyright © 2016 LQTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerRegisterController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerServices;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;
- (IBAction)clickRegister:(id)sender;

@end
