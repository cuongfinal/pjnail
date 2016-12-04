//
//  ViewController.m
//  PJNails
//
//  Created by IVC on 4/27/16.
//  Copyright © 2016 LQTC. All rights reserved.
//

#import "LoginController.h"
#import "AFNetworking.h"
#import "SWRevealViewController.h"
#import "DefineClass.h"
#import "AppDelegate.h"

@interface LoginController ()

@end

@implementation LoginController
{
    AppDelegate *delegate;
   
}

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
    NSString *isUser = [NSString stringWithFormat:@"%@",(self.swUser.isOn ? @"Yes":@"No")];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *token = appDelegate.token;
    if([isUser isEqualToString:@"Yes"]){
         [self doLoginUser: token];
    }else{
         [self doLoginShop: token];
    }
}

-(void)doLoginShop:(NSString*)token{
    NSError *error;      // Initialize NSError
    NSDictionary *parameters = @{@"account": [self.txtUsername text], @"password": [self.txtPassword text], @"udid": @"68753A44-4D6F-1226-9C60-0050E4C00067"};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error]; // Convert parameter to NSDATA
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]; // Convert data into string using NSUTF8StringEncoding
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]; //Intialialize AFURLSessionManager
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:@ShopLogin parameters:nil error:nil];
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setValue:token forHTTPHeaderField:@"Authorization"];
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            NSDictionary *jsonDict = (NSDictionary *) responseObject;
            NSString *status = [jsonDict objectForKey:@"status"];
            if([status isEqualToString:@"success"]){
                [self performSegueWithIdentifier:@"shop_login_success" sender:self];
            }
        } else {
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert !!!" message:@"Your username or password is incorrect" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert setTag:1];
            [alert show];
        }
        
    }]resume];
}

-(void)doLoginUser:(NSString*)token{
    NSError *error;      // Initialize NSError
    NSDictionary *parameters = @{@"username": [self.txtUsername text], @"password": [self.txtPassword text]};
    NSString *urlLogin = [NSString stringWithFormat: @"%@?udid=%@", @ShopLogin, @"68753A44-4D6F-1226-9C60-0050E4C00067"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error]; // Convert parameter to NSDATA
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]; // Convert data into string using NSUTF8StringEncoding
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]; //Intialialize AFURLSessionManager
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:@ShopLogin parameters:nil error:nil];
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setValue:token forHTTPHeaderField:@"Authorization"];
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            NSDictionary *jsonDict = (NSDictionary *) responseObject;
            NSString *status = [jsonDict objectForKey:@"status"];
            if([status isEqualToString:@"success"]){
                [self performSegueWithIdentifier:@"shop_login_success" sender:self];
            }
        } else {
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert !!!" message:@"Your username or password is incorrect" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert setTag:1];
            [alert show];
        }
        
    }]resume];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}
@end
