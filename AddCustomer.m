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

@implementation AddCustomer


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
    
    
//    NSError *error;      // Initialize NSError
//    NSDictionary *parameters = @{@"email": [self.txtUsername text], @"first_name": [self.txtPassword text], @"last_name": [self.txtPassword text], @"birthday": [self.txtPassword text], @"address": [self.txtPassword text], @"telephone": [self.txtPassword text], @"avatar": [self.txtPassword text], @"favorite": [self.txtPassword text], @"last_visit": [self.txtPassword text], @"last_service": [self.txtPassword text]};
//    
//    NSString *urlLogin = [NSString stringWithFormat: @"%@?udid=%@", @ShopLogin, @"68753A44-4D6F-1226-9C60-0050E4C00067"];
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error]; // Convert parameter to NSDATA
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]; // Convert data into string using NSUTF8StringEncoding
//    
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]; //Intialialize AFURLSessionManager
//    
//    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:@ShopLogin parameters:nil error:nil];
//    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
//    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [req setValue:token forHTTPHeaderField:@"Authorization"];
//    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        if (!error) {
//            NSDictionary *jsonDict = (NSDictionary *) responseObject;
//            NSString *status = [jsonDict objectForKey:@"status"];
//            if([status isEqualToString:@"success"]){
//                [self performSegueWithIdentifier:@"shop_login_success" sender:self];
//            }
//        } else {
//            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert !!!" message:@"Your username or password is incorrect" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//            [alert setTag:1];
//            [alert show];
//        }
//        
//    }]resume];

}
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
