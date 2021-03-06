//
//  SearchCustomerViewController.m
//  PJNails
//
//  Created by lehongphong on 12/25/16.
//  Copyright © 2016 LQTC. All rights reserved.
//

#import "SearchCustomerViewController.h"
#import "SWRevealViewController.h"
#import "AFNetworking.h"
#import "DefineClass.h"
#import "AppDelegate.h"
#import "LoginController.h"
#import "CustomerModel.h"
#import "MBProgressHUD.h"
#import "ResultListCell.h"

@interface SearchCustomerViewController ()

@end

CustomerModel *modelCus;
NSMutableArray *arrCustomer3;
NSMutableArray *arrName3;
NSMutableArray *arrCusID3;
NSMutableArray *arrPhone3;
NSMutableArray *arrServicesSelected;
NSString *strEmployeeSelected;
@implementation SearchCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Search Customer", nil);
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.token = appDelegate.token;
    
    self.btnSearch.layer.cornerRadius = 10;
    self.btnSearch.clipsToBounds = YES;
    
    arrName3 = [[NSMutableArray alloc] init];
    arrPhone3 = [[NSMutableArray alloc] init];
    arrCusID3 = [[NSMutableArray alloc] init];
    arrCustomer3 = [[NSMutableArray alloc] init];
    arrServicesSelected = [[NSMutableArray alloc] init];
    self.tbResultList.dataSource = self;
    self.tbResultList.delegate = self;
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)tapAdd:(id)sender {
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
        [self.addServicesPopover presentPopoverFromRect:[self.btnAddService frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
    else{
        AddServicePopupController *addServicesController = [[AddServicePopupController alloc] initWithNibName:@"AddServicePopupController" bundle:nil previousController:previousController currentController:currentController];
        addServicesController.delegate = self;
        self.addServicesPopover = [[UIPopoverController alloc] initWithContentViewController:addServicesController];
        self.addServicesPopover.popoverContentSize = CGSizeMake(505.0, 505.0);
        [self.addServicesPopover presentPopoverFromRect:[self.btnAddService frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
}
-(void)dataChangeServices:(NSMutableArray *)servicesItem employees:(NSString *)employees{
    arrServicesSelected = servicesItem;
    strEmployeeSelected = employees;
    [self.addServicesPopover dismissPopoverAnimated:YES];
}
-(void)dataChangeServicesForBooking:(NSMutableArray *)servicesItem{
    arrServicesSelected = servicesItem;
    [self.addServicesPopover dismissPopoverAnimated:YES];
}
- (IBAction)tapSearch:(id)sender {
    [self.view endEditing:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = @"Loading";
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]; //Intialialize AFURLSessionManager
    NSString *urlCustomerList = [NSString stringWithFormat: @"%@%@&udid=%@", @SearchCustomer, self.tfCustomerName.text, @"68753A44-4D6F-1226-9C60-0050E4C00067"];
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:urlCustomerList parameters:nil error:nil];
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setValue:self.token forHTTPHeaderField:@"Authorization"];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            [hud hideAnimated:YES];
            NSDictionary *jsonDict = (NSDictionary *) responseObject;
            for (NSDictionary *groupDic in jsonDict) {
                modelCus = [[CustomerModel alloc] init];
                modelCus.customerID = groupDic[@"id"];
                modelCus.shops_id = groupDic[@"shops_id"];
                modelCus.first_name = groupDic[@"first_name"];
                modelCus.last_name = groupDic[@"last_name"];
                modelCus.birthday = groupDic[@"birthday"];
                modelCus.address = groupDic[@"address"];
                modelCus.telephone = groupDic[@"telephone"];
                modelCus.email = groupDic[@"email"];
                NSString *name = [NSString stringWithFormat:@"%@ %@", modelCus.first_name, modelCus.last_name];
                [arrName3 addObject:name];
                [arrPhone3 addObject:modelCus.telephone];
                [arrCustomer3 addObject:modelCus];
                [arrCusID3 addObject:modelCus.customerID];
            }
            [self.tbResultList reloadData];
        } else {
            [hud hideAnimated:YES];
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert !!!" message:@"Can not get any customer info" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert setTag:1];
            [alert show];
        }
        
    }]resume];
}

-(void)createBill{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = @"Loading";
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *token = appDelegate.token;
    
    NSError *error;      // Initialize NSError
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for(int i = 0; i < arrServicesSelected.count; i++){
            NSDictionary *paramsArr = @{@"services_id": [arrServicesSelected objectAtIndex:i], @"employees_id": strEmployeeSelected};
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert !!!" message:@"Can not create Bill, Please try again" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
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
    for(int i = 0; i < arrServicesSelected.count; i++){
            [arr addObject:[arrServicesSelected objectAtIndex:i]];
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
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrCustomer3.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ResultListCell *cell = (ResultListCell *)[tableView dequeueReusableCellWithIdentifier:@"resultListCell" forIndexPath:indexPath];
    cell.delegate = self;
    
    cell.lblName.text = arrName3[indexPath.row];
    cell.lblPhone.text = arrPhone3[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewController *previousController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    NSString *strPreviousController = NSStringFromClass([previousController class]);
    
    if(arrServicesSelected.count == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please select services first" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else{
        if([strPreviousController isEqualToString:@"BillingListController"]) {
            // set Segue Identifier from your first viewcontroller to second viewController in stoaryboard
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Create Bill" message:@"Do you want to create new bill for this customer" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
            self.customerIDRegistered = [arrCusID3 objectAtIndex:indexPath.row];
            [alert setTag:100];
            [alert show];
        }else{
            // set Segue Identifier from your first viewcontroller to second viewController in stoaryboard
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Create Appoinment" message:@"Do you want to create new appointment for this customer" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
            self.customerIDRegistered = [arrCusID3 objectAtIndex:indexPath.row];
            [alert setTag:102];
            [alert show];
        }
    }
}

@end
