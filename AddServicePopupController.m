//
//  TestViewController.m
//  ActionSheetDemo
//
//  Created by Gabriel Theodoropoulos on 23/4/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "AddServicePopupController.h"
#import "SWRevealViewController.h"
#import "AFNetworking.h"
#import "DefineClass.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "ServicesModel.h"
#import "BillingDetailsViewController.h"
#import "SearchCustomerViewController.h"
#import "BillingListController.h"
#import "BookingListController.h"
@interface AddServicePopupController ()

@property (nonatomic, strong) NSMutableArray *arrServicesID;
@property (nonatomic, strong) NSMutableArray *arrServiceName;
@property (nonatomic, strong) NSMutableArray *arrEmployeesID;
@property (nonatomic, strong) NSMutableArray *arrEmployeesName;
@property (nonatomic, strong) NSMutableArray *arrServiceForAdd;

@end

NSString *strCurrentController;
NSString *strPreviousController;

@implementation AddServicePopupController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil previousController:(UITableViewController*)previousController currentController:(UIViewController*)currentController
{
    self.previousController = previousController;
    self.currentController = currentController;
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.token = appDelegate.token;
    
    strCurrentController = NSStringFromClass([self.currentController class]);
    strPreviousController = NSStringFromClass([self.previousController class]);
    
    self.arrServiceForAdd = [[NSMutableArray alloc] init];
    
    if([strPreviousController isEqualToString:@"BookingListController"] && [strCurrentController isEqualToString:@"SearchCustomerViewController"]){
        [self getServicesList:self.token];
        [self.pickerEmployee setHidden:YES];
        [_lblEmployee setHidden:YES];
    }
    else {
        [self getServicesList:self.token];
        [self getEmployeeList:self.token];
        [_lblEmployee setHidden:NO];
    }
    
    self.pickerEmployee.delegate = self;
    self.pickerEmployee.dataSource = self;
    self.pickerEmployee.tag = 101;
    
    [self.tbListServices setEditing:YES animated:YES];
    self.tbListServices.delegate=(id)self;
    self.tbListServices.dataSource=(id)self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getServicesList:(NSString*)token{
    self.arrServicesID = [[NSMutableArray alloc] init];
    self.arrServiceName = [[NSMutableArray alloc] init];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = @"Loading";
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]; //Intialialize AFURLSessionManager
    NSString *urlCustomerList = [NSString stringWithFormat: @"%@?udid=%@", @ServicesList, @"68753A44-4D6F-1226-9C60-0050E4C00067"];
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:urlCustomerList parameters:nil error:nil];
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setValue:token forHTTPHeaderField:@"Authorization"];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            [hud hideAnimated:YES];
            NSDictionary *jsonDict = (NSDictionary *) responseObject;
            for (NSDictionary *groupDic in jsonDict) {
                ServicesModel* model = [[ServicesModel alloc] init];
                model.serviceID = groupDic[@"id"];
                model.service_name = groupDic[@"name"];
                [self.arrServicesID addObject:model.serviceID];
                [self.arrServiceName addObject:model.service_name];
            }
            [self.tbListServices reloadData];
        } else {
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert !!!" message:@"Can not get Services list" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert setTag:1];
            [alert show];
        }
        
    }]resume];
}

-(void)getEmployeeList:(NSString*)token{
    self.arrEmployeesID = [[NSMutableArray alloc] init];
    self.arrEmployeesName = [[NSMutableArray alloc] init];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = @"Loading";
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]; //Intialialize AFURLSessionManager
    NSString *urlCustomerList = [NSString stringWithFormat: @"%@?udid=%@", @EmployeeList, @"68753A44-4D6F-1226-9C60-0050E4C00067"];
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:urlCustomerList parameters:nil error:nil];
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setValue:token forHTTPHeaderField:@"Authorization"];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            [hud hideAnimated:YES];
            NSDictionary *jsonDict = (NSDictionary *) responseObject;
            for (NSDictionary *groupDic in jsonDict) {
                NSString* employeeID = groupDic[@"id"];
                NSString* employeeName = [NSString stringWithFormat:@"%@ %@",groupDic[@"first_name"],groupDic[@"last_name"]];
                [self.arrEmployeesID addObject:employeeID];
                [self.arrEmployeesName addObject:employeeName];
            }
            [self.pickerEmployee reloadAllComponents];
        } else {
            [hud hideAnimated:YES];
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert !!!" message:@"Can not get Employee list" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert setTag:1];
            [alert show];
        }
    }]resume];
}

#pragma mark - Table List Services
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrServiceName count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [self.arrServiceName objectAtIndex:indexPath.row];
    return cell;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.arrServiceForAdd addObject:[self.arrServicesID objectAtIndex:indexPath.row]];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.arrServiceForAdd removeObject:[self.arrServicesID objectAtIndex:indexPath.row]];
}

#pragma mark - IBAction method implementation

- (IBAction)done:(id)sender {
    if([strPreviousController isEqualToString:@"BookingListController"] && [strCurrentController isEqualToString:@"SearchCustomerViewController"]){
        [self.delegate dataChangeServicesForBooking:self.arrServiceForAdd];
    }
    else{
        [self.delegate dataChangeServices:self.arrServiceForAdd employees:[self.arrEmployeesID objectAtIndex:[self.pickerEmployee selectedRowInComponent:0]]];
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
        return self.arrEmployeesName.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
        return [self.arrEmployeesName objectAtIndex:row];
}

@end
