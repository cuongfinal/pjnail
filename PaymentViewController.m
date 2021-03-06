//
//  PaymentViewController.m
//  PJNails
//
//  Created by LQTCuong on 12/19/16.
//  Copyright © 2016 LQTC. All rights reserved.
//

#import "PaymentViewController.h"
#import "AFNetworking.h"
#import "DefineClass.h"
#import "AppDelegate.h"
#import "BillingDetailsModel.h"
#import "MBProgressHUD.h"
#import "ServicesCell.h"

@interface PaymentViewController ()

@end

ServicesModel *serviceModel;
NSMutableArray *arrayServices;
UIBarButtonItem *addTip;
UIAlertView *alertNoti;
@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tbServicesList.dataSource = self;
    _tbServicesList.delegate = self;
    
    self.btnPayment.layer.cornerRadius = 10;
    self.btnPayment.clipsToBounds = YES;
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dataChangeWithTipValue:(NSString *)tipValue{
    _lblTip.text = tipValue;
    NSNumber *total = [NSNumber numberWithInt:[_tempTotal intValue] + [tipValue intValue]];
    _lblTotal.text = [NSString stringWithFormat:@"%@", total];
    [self.addTipPopover dismissPopoverAnimated:YES];
}
-(void)getDetails:(NSString*)billID{
    _tempBillID = billID;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = @"Loading";
    
    arrayServices = [[NSMutableArray alloc] init];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *token = appDelegate.token;
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]; //Intialialize AFURLSessionManager
    NSString *urlBillDetails = [NSString stringWithFormat: @"%@/%@?udid=%@", @BillingDetails,billID, @"68753A44-4D6F-1226-9C60-0050E4C00067"];
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:urlBillDetails parameters:nil error:nil];
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setValue:token forHTTPHeaderField:@"Authorization"];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            [hud hideAnimated:YES];
            NSDictionary *groupDic = (NSDictionary *) responseObject;
            NSDictionary *servicesDict = [groupDic objectForKey:@"services"];
            _lblTotal.text = [NSString stringWithFormat:@"%@", [groupDic[@"total"] isKindOfClass:[NSNull class]] ? @"0" : groupDic[@"total"]];
            _tempTotal = _lblTotal.text;
            _lblTip.text = @"0";
            for(NSDictionary *services in servicesDict){
                serviceModel = [[ServicesModel alloc] init];
                serviceModel.serviceID = [NSString stringWithFormat:@"%@", [services[@"id"] isKindOfClass:[NSNull class]] ? @"0" : services[@"id"]];
                serviceModel.billID = [NSString stringWithFormat:@"%@", [billID isKindOfClass:[NSNull class]] ? @"0" : billID];
                serviceModel.service_name = [services[@"service_name"] isKindOfClass:[NSNull class]] ? @"No Data" : services[@"service_name"];
                serviceModel.employee_name = [services[@"employee_name"] isKindOfClass:[NSNull class]] ? @"No Data" : services[@"employee_name"];
                serviceModel.price = [NSString stringWithFormat:@"%@", [services[@"price"] isKindOfClass:[NSNull class]] ? @"0" : services[@"price"]];
                serviceModel.shop_fee = [NSString stringWithFormat:@"%@", [services[@"shop_fee"] isKindOfClass:[NSNull class]] ? @"0" : services[@"shop_fee"]];
                serviceModel.discount = [NSString stringWithFormat:@"%@", [services[@"discount"] isKindOfClass:[NSNull class]] ? @"0" : services[@"discount"]];
                serviceModel.tips = [NSString stringWithFormat:@"%@", [services[@"tips"] isKindOfClass:[NSNull class]] ? @"0" : services[@"tips"]];
                [arrayServices addObject:serviceModel];
                [arrayServices sortUsingDescriptors:[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"employee_name" ascending:YES], nil]];
                //sort data
                

            }
            
            [self.tbServicesList reloadData];
        } else {
            [hud hideAnimated:YES];
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert !!!" message:@"Can not get services details" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert setTag:1];
            [alert show];
        }
    }]resume];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayServices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ServicesCell *cell = (ServicesCell *)[tableView dequeueReusableCellWithIdentifier:@"serviceCell" forIndexPath:indexPath];
    [cell.tfTip setKeyboardType:UIKeyboardTypeNumberPad];
    ServicesModel *previousModel = arrayServices[indexPath.row];
    if(indexPath.row == 0){
        previousModel = nil;
    }
    else if(indexPath.row > 0){
        previousModel = arrayServices[indexPath.row - 1];
    }
    
    ServicesModel *model = arrayServices[indexPath.row];
    if(indexPath.row < arrayServices.count-1){
        ServicesModel *nextModel = arrayServices[indexPath.row + 1];
        if([model.employee_name isEqualToString:nextModel.employee_name]){
            cell.separatorInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, cell.bounds.size.width);
        }
    }
    
    cell.lblServicesName.text = model.service_name;
    if(![model.employee_name isEqualToString:previousModel.employee_name]){
        cell.lblEmployee.text = model.employee_name;
    }
    else{
        cell.tfTip.hidden = YES;
    }
    cell.lblPrice.text = model.price;
    cell.lblShopFee.text = model.shop_fee;

    cell.tfTip.text = @"0";
    cell.delegate = self;
    
    [cell.tfTip addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    
    return cell;
}

- (void)textFieldDidChange:(UITextField*)textField{
    if([textField.text length] > 0){
        _lblTip.text = textField.text;
        NSNumber *total = [NSNumber numberWithInt:[_tempTotal intValue] + [textField.text intValue]];
        _lblTotal.text = [NSString stringWithFormat:@"%@", total];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)tapPayment:(id)sender {

}
-(void)doTip{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeAnnularDeterminate;
        hud.label.text = @"Loading";
        
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSString *token = appDelegate.token;
        
        NSError *error;      // Initialize NSError
        NSDictionary *paramsArr = @{@"tips": _lblTip.text};
        
        NSString *urlBillingTip = [NSString stringWithFormat: @"%@/%@?udid=%@", @BillingTip, self.tempBillID ,@"68753A44-4D6F-1226-9C60-0050E4C00067"];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramsArr options:0 error:&error]; // Convert parameter to NSDATA
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]; //Intialialize AFURLSessionManager
        
        NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlBillingTip parameters:nil error:nil];
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
                    [self doPayment];
                }
                else{
                    alertNoti = [[UIAlertView alloc] initWithTitle:@"Alert !!!" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [alertNoti show];
                }
                
            } else {
                [hud hideAnimated:YES];
                NSLog(@"Error: %@, %@, %@", error, response, responseObject);
                alertNoti = [[UIAlertView alloc] initWithTitle:@"Alert !!!" message:@"Can not Tip, Please try again" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alertNoti show];
            }
            
        }]resume];
}
-(void)doPayment{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = @"Tip done, Payment now";
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *token = appDelegate.token;
    
    NSError *error;      // Initialize NSError
    NSDictionary *paramsArr = @{@"payment_type": @"1", @"receive": @"0", @"returns": @"0", @"note": @"Payment Successfully"};
    
    NSString *urlBillingDone = [NSString stringWithFormat: @"%@/%@?udid=%@", @BillingDone, self.tempBillID ,@"68753A44-4D6F-1226-9C60-0050E4C00067"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramsArr options:0 error:&error]; // Convert parameter to NSDATA
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]; //Intialialize AFURLSessionManager
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlBillingDone parameters:nil error:nil];
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
                alertNoti = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Payment Successfull" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alertNoti setTag:101];
                [alertNoti show];
            }
            else{
                alertNoti = [[UIAlertView alloc] initWithTitle:@"Alert !!!" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alertNoti show];
            }
            
        } else {
            [hud hideAnimated:YES];
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            alertNoti = [[UIAlertView alloc] initWithTitle:@"Alert !!!" message:@"Can not Payment, Please try again" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertNoti show];
        }
        
    }]resume];
}
@end
