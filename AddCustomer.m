//
//  AddCustomer.m
//  PJNails
//
//  Created by lehongphong on 12/5/16.
//  Copyright © 2016 LQTC. All rights reserved.
//

#import "AddCustomer.h"
#import "AFNetworking.h"
#import "DefineClass.h"
#import "AppDelegate.h"
#import "BillingListController.h"

@implementation AddCustomer

UIAlertView *alert;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Add Customer", nil);
    
    UIDatePicker *birthDayPicker = [[UIDatePicker alloc]init];
    [birthDayPicker setDate:[NSDate date]];
    birthDayPicker.datePickerMode = UIDatePickerModeDate;
    [birthDayPicker addTarget:self action:@selector(birthDayTextField:) forControlEvents:UIControlEventValueChanged];
    [_txtBirthday setInputView:birthDayPicker];
    
    UIDatePicker *lastVisitPicker = [[UIDatePicker alloc]init];
    [lastVisitPicker setDate:[NSDate date]];
    lastVisitPicker.datePickerMode = UIDatePickerModeDate;
    [lastVisitPicker addTarget:self action:@selector(lastVisitTextField:) forControlEvents:UIControlEventValueChanged];
    [_txtLastVisit setInputView:lastVisitPicker];
    
}
- (IBAction)clickRegister:(id)sender {

    
    NSString *swValue = [NSString stringWithFormat:@"%d",(self.swFavorite.isOn ? 0:1)];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *token = appDelegate.token;
    
    NSError *error;      // Initialize NSError
    NSDictionary *parameters = @{@"email": [self.txtEmail text], @"first_name": [self.txtFirstName text], @"last_name": [self.txtLastName text], @"birthday": [self.txtBirthday text], @"address": [self.txtAddress text], @"telephone": [self.txtTelephone text], @"avatar": @"1", @"favorite": swValue, @"last_visit": [self.txtLastVisit text], @"last_service": [self.txtServices text]};
    
    NSString *urlCreate = [NSString stringWithFormat: @"%@?udid=%@", @CreateCustomer, @"68753A44-4D6F-1226-9C60-0050E4C00067"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error]; // Convert parameter to NSDATA
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]; //Intialialize AFURLSessionManager
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlCreate parameters:nil error:nil];
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setValue:token forHTTPHeaderField:@"Authorization"];
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            NSDictionary *jsonDict = (NSDictionary *) responseObject;
            NSDictionary *arrData = [jsonDict objectForKey:@"data"];
            _customerIDRegistered = [NSString stringWithFormat:@"%@", arrData[@"id"]];
            
            NSString *status = [jsonDict objectForKey:@"status"];
            if([status isEqualToString:@"success"]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Create Bill" message:@"Do you want to create new bill for this customer" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
                [alert setTag:100];
                [alert show];
            }
        } else {
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            alert = [[UIAlertView alloc] initWithTitle:@"Alert !!!" message:@"Can not create customer, Please try again" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
        
    }]resume];

}

-(void)createBill{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *token = appDelegate.token;
    
    NSError *error;      // Initialize NSError
    NSDictionary *paramsArr = @{@"services_id": @"1", @"employees_id": @"1"};
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:paramsArr,nil];
    
    NSDictionary *parameters = @{@"customers_id": _customerIDRegistered, @"services": arr};
    
    NSString *urlCreate = [NSString stringWithFormat: @"%@?udid=%@", @CreateBill, @"68753A44-4D6F-1226-9C60-0050E4C00067"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error]; // Convert parameter to NSDATA
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]; //Intialialize AFURLSessionManager
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlCreate parameters:nil error:nil];
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
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Bill Create Successfull" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert setTag:101];
                [alert show];
            }

        } else {
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            alert = [[UIAlertView alloc] initWithTitle:@"Alert !!!" message:@"Can not create Bill, Please try again" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
        
    }]resume];
    
}

//click on alert
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 100){
        if (buttonIndex == 0)
        {
            [self createBill];
        }
    }
    else if(alertView.tag == 101){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//date picker
-(void) birthDayTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)_txtBirthday.inputView;
    [picker setMaximumDate:[NSDate date]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *eventDate = picker.date;
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateString = [dateFormat stringFromDate:eventDate];
    _txtBirthday.text = [NSString stringWithFormat:@"%@",dateString];
}

-(void) lastVisitTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)_txtLastVisit.inputView;
    [picker setMaximumDate:[NSDate date]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *eventDate = picker.date;
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateString = [dateFormat stringFromDate:eventDate];
    _txtLastVisit.text = [NSString stringWithFormat:@"%@",dateString];
}
@end
