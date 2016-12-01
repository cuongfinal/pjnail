//
//  ViewController.m
//  PJNails
//
//  Created by IVC on 4/27/16.
//  Copyright © 2016 LQTC. All rights reserved.
//

#import "LoginController.h"
#import "AFNetworking.h"


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
    if([[self.txtUsername text] isEqualToString:@""] || [[self.txtPassword text] isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert !!!" message:@"Please enter Username and Password" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert setTag:1];
        [alert show];
    }
    [self getAccessToken];

}
-(void)getAccessToken{
    NSError *error;      // Initialize NSError
    NSDictionary *parameters = @{@"username": [self.txtUsername text], @"password": [self.txtPassword text]};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error]; // Convert parameter to NSDATA
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]; // Convert data into string using NSUTF8StringEncoding
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]; //Intialialize AFURLSessionManager
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"http://f24915cc.ngrok.io/api/api-users/token" parameters:nil error:nil];
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            NSDictionary *jsonDict = (NSDictionary *) responseObject;
            NSDictionary *dataArray = [jsonDict objectForKey:@"data"];
            _token = [dataArray objectForKey:@"token"];
            NSLog(@"Get token successful");
            //            [self performSegueWithIdentifier:@"user_login_success" sender:self];
        } else {
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert !!!" message:@"Your username or password is incorrect" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert setTag:1];
            [alert show];
        }
        
    }]resume];
}

-(void)doLogin{

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}
@end
