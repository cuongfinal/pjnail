//
//  ViewController.h
//  PJNails
//
//  Created by IVC on 4/27/16.
//  Copyright © 2016 LQTC. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface LoginController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) NSString *token;
- (IBAction)signInClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSignIn;
- (IBAction)backgroundTapped:(id)sender;


@end

