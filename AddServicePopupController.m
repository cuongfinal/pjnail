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
@interface AddServicePopupController ()

@property (nonatomic, strong) NSMutableArray *arrServicesID;
@property (nonatomic, strong) NSMutableArray *arrServiceName;
@property (nonatomic, strong) NSMutableArray *arrEmployeesID;
@property (nonatomic, strong) NSMutableArray *arrEmployeesName;
@end


@implementation AddServicePopupController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
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
    
    [self getServicesList:self.token];
    [self getEmployeeList:self.token];

    self.pickerServices.delegate = self;
    self.pickerServices.dataSource = self;
    self.pickerServices.tag = 100;
    
    self.pickerEmployee.delegate = self;
    self.pickerEmployee.dataSource = self;
    self.pickerEmployee.tag = 101;
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
            [self.pickerServices reloadAllComponents];
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
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert !!!" message:@"Can not get Employee list" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert setTag:1];
            [alert show];
        }
    }]resume];
}

#pragma mark - IBAction method implementation

- (IBAction)done:(id)sender {
    [self.delegate dataChangeServices:[self.arrServicesID objectAtIndex:[self.pickerServices selectedRowInComponent:0]] employees:[self.arrEmployeesID objectAtIndex:[self.pickerEmployee selectedRowInComponent:0]]];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(pickerView.tag == 100){
        return self.arrServiceName.count;
    }else{
        return self.arrEmployeesName.count;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(pickerView.tag == 100){
        return [self.arrServiceName objectAtIndex:row];
    }else{
        return [self.arrEmployeesName objectAtIndex:row];
    }
}

@end
