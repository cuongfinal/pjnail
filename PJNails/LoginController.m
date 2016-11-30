//
//  ViewController.m
//  PJNails
//
//  Created by IVC on 4/27/16.
//  Copyright © 2016 LQTC. All rights reserved.
//

#import "LoginController.h"

@interface LoginController ()

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signInClick:(id)sender {
    BOOL isLoginSuccess = YES;
    if(isLoginSuccess){
        if([[self.txtUsername text] isEqualToString:@""] || [[self.txtPassword text]isEqualToString:@""]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert !!!" message:@"Please enter Username and Password" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert setTag:1];
            [alert show];
        }
        else{
            [self performSegueWithIdentifier:@"user_login_success" sender:self];
        }
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}
@end
