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
#import "MBProgressHUD.h"

NSMutableArray *arrServicesSelected2;
NSString *strEmployeeSelected2;
@implementation AddCustomer

UIAlertView *alert;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Add Customer", nil);
    
    arrServicesSelected2 = [[NSMutableArray alloc] init];
    
    self.btnRegister.layer.cornerRadius = 10;
    self.btnRegister.clipsToBounds = YES;
    
    self.btnSelectServices.layer.cornerRadius = 10;
    self.btnSelectServices.clipsToBounds = YES;
    
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
-(void)dataChangeServices:(NSMutableArray *)servicesItem employees:(NSString *)employees{
    arrServicesSelected2 = servicesItem;
    strEmployeeSelected2 = employees;
    [self.addServicesPopover dismissPopoverAnimated:YES];
}
-(void)dataChangeServicesForBooking:(NSMutableArray *)servicesItem{
    arrServicesSelected2 = servicesItem;
    [self.addServicesPopover dismissPopoverAnimated:YES];
}
- (IBAction)clickRegister:(id)sender {

    if(arrServicesSelected2.count == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please select services first" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeAnnularDeterminate;
        hud.label.text = @"Loading";
        
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
                [hud hideAnimated:YES];
                NSDictionary *jsonDict = (NSDictionary *) responseObject;
                NSDictionary *arrData = [jsonDict objectForKey:@"data"];
                _customerIDRegistered = [NSString stringWithFormat:@"%@", arrData[@"id"]];
                
                NSString *status = [jsonDict objectForKey:@"status"];
                NSString *message = [jsonDict objectForKey:@"message"];
                if([status isEqualToString:@"success"]){
                    UITableViewController *previousController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
                    NSString *strPreviousController = NSStringFromClass([previousController class]);
                    if([strPreviousController isEqualToString:@"BillingListController"]) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Create Bill" message:@"Do you want to create new bill for this customer" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
                        [alert setTag:100];
                        [alert show];
                    }
                    else{
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Create Appoinment" message:@"Do you want to create new appointment for this customer" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
                        [alert setTag:102];
                        [alert show];
                    }
                }
                else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert !!!" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [alert show];
                }
            } else {
                [hud hideAnimated:YES];
                NSLog(@"Error: %@, %@, %@", error, response, responseObject);
                alert = [[UIAlertView alloc] initWithTitle:@"Alert !!!" message:@"Can not create customer, Please try again" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
            }
            
        }]resume];
    }
}

-(void)createBill{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = @"Loading";
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *token = appDelegate.token;
    
    NSError *error;      // Initialize NSError
//    NSDictionary *paramsArr = @{@"services_id": @"1", @"employees_id": @"1"};
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for(int i = 0; i < arrServicesSelected2.count; i++){
        NSDictionary *paramsArr = @{@"services_id": [arrServicesSelected2 objectAtIndex:i], @"employees_id": strEmployeeSelected2};
        if(i == 0){
            arr = [NSMutableArray arrayWithObjects:
                   paramsArr, nil];
        }
        else{
            [arr addObject:paramsArr];
        }
    }
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
            [hud hideAnimated:YES];
            NSDictionary *jsonDict = (NSDictionary *) responseObject;
            NSString *status = [jsonDict objectForKey:@"status"];
            NSString *message = [jsonDict objectForKey:@"message"];
            if([status isEqualToString:@"success"]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Bill Create Successfull" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert setTag:101];
                [alert show];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert !!!" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
            }

        } else {
            [hud hideAnimated:YES];
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            alert = [[UIAlertView alloc] initWithTitle:@"Alert !!!" message:@"Can not create Bill, Please try again" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
        
    }]resume];
}

-(void)createBooking{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = @"Loading";
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *token = appDelegate.token;
    
    NSError *error;      // Initialize NSError
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for(int i = 0; i < arrServicesSelected2.count; i++){
        [arr addObject:[arrServicesSelected2 objectAtIndex:i]];
    }
    NSDictionary *parameters = @{@"customers_id": _customerIDRegistered, @"services": arr, @"date": @"2017-12-11", @"start_time": @"08:30:00",@"end_time": @"09:00:00",@"note": @"Note for 2016-12-11"};
    
    NSString *urlCreate = [NSString stringWithFormat: @"%@?udid=%@", @BookingList, @"68753A44-4D6F-1226-9C60-0050E4C00067"];
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
            [hud hideAnimated:YES];
            NSDictionary *jsonDict = (NSDictionary *) responseObject;
            NSString *status = [jsonDict objectForKey:@"status"];
            NSString *message = [jsonDict objectForKey:@"message"];
            if([status isEqualToString:@"success"]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Appointment Create Successfull" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert setTag:101];
                [alert show];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert !!!" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
            }
            
        } else {
            [hud hideAnimated:YES];
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert !!!" message:@"Can not create Bill, Please try again" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
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
    else if(alertView.tag == 102){
        if (buttonIndex == 0)
        {
            [self createBooking];
        }
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
- (IBAction)tapServices:(id)sender {
    UITableViewController *previousController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    UIViewController *currentController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-1];
    NSString *strPreviousController = NSStringFromClass([previousController class]);
    
    AddServicePopupController *addServicesController = [[AddServicePopupController alloc] initWithNibName:@"AddServicePopupController" bundle:nil previousController:previousController currentController:currentController];
    addServicesController.delegate = self;
    
    if([strPreviousController isEqualToString:@"BookingListController"]) {
        AddServicePopupController *addServicesController = [[AddServicePopupController alloc] initWithNibName:@"AddServiceOnBookingPopupController" bundle:nil previousController:previousController currentController:currentController];
        addServicesController.delegate = self;
        self.addServicesPopover = [[UIPopoverController alloc] initWithContentViewController:addServicesController];
        self.addServicesPopover.popoverContentSize = CGSizeMake(505.0, 310.0);
        [self.addServicesPopover presentPopoverFromRect:[self.btnSelectServices frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
    else{
        AddServicePopupController *addServicesController = [[AddServicePopupController alloc] initWithNibName:@"AddServicePopupController" bundle:nil previousController:previousController currentController:currentController];
        addServicesController.delegate = self;
        self.addServicesPopover = [[UIPopoverController alloc] initWithContentViewController:addServicesController];
        self.addServicesPopover.popoverContentSize = CGSizeMake(505.0, 505.0);
        [self.addServicesPopover presentPopoverFromRect:[self.btnSelectServices frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
}
@end
