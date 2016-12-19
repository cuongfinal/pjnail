//
//  BillingDetailsViewController.m
//  PJNails
//
//  Created by LQTCuong on 12/12/16.
//  Copyright © 2016 LQTC. All rights reserved.
//

#import "BillingDetailsViewController.h"
#import "SWRevealViewController.h"
#import "AFNetworking.h"
#import "DefineClass.h"
#import "AppDelegate.h"
#import "BillingDetailsModel.h"
#import "BillingDetailsCell.h"
#import "MBProgressHUD.h"

@interface BillingDetailsViewController ()
@end

BillingDetailsModel *billModel;
ServicesModel *servicesModel;
NSMutableArray *arrServices;
@implementation BillingDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *paymentButton = [[UIBarButtonItem alloc] initWithTitle:@"Add Customer" style:UIBarButtonItemStylePlain target:self action:@selector(paymentButton)];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationItem.rightBarButtonItem = paymentButton;
    
    _lblPaymentType.text = @"";
    _lblReceive.text = @"";
    _lblNote.text = @"";
    _lblDone.text = @"";
    _lblBillingDate.text = @"";
    _lblCustomer.text = @"";
    _lblTotal.text = @"";
    _lblShopFee.text = @"";;
    _lblDiscount.text = @"";
    _lblTip.text = @"";
    
    _tbServicesList.dataSource = self;
    _tbServicesList.delegate = self;
}

-(void)paymentButton{
    [self performSegueWithIdentifier:@"add_customer" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getDetails:(NSString*)billID{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = @"Loading";
    
    arrServices = [[NSMutableArray alloc] init];
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
            BOOL isDone = [groupDic[@"done"] boolValue];
            NSString *stringDone = (isDone = 0) ? @"NO" : @"YES";
            _lblPaymentType.text = [groupDic[@"payment_type"] isKindOfClass:[NSNull class]] ? @"No Data" : groupDic[@"payment_type"];
            _lblReceive.text = [groupDic[@"receive"] isKindOfClass:[NSNull class]] ? @"No Data" : groupDic[@"receive"];
            _lblNote.text = [groupDic[@"note"] isKindOfClass:[NSNull class]] ? @"No Data" : groupDic[@"note"];
            _lblDone.text = stringDone;
            _lblBillingDate.text = [groupDic[@"billing_date"] isKindOfClass:[NSNull class]] ? @"No Data" : groupDic[@"billing_date"];
            _lblCustomer.text = [groupDic[@"customer"] isKindOfClass:[NSNull class]] ? @"1" : groupDic[@"customer"];
            _lblTotal.text = [NSString stringWithFormat:@"%@", [groupDic[@"total"] isKindOfClass:[NSNull class]] ? @"0" : groupDic[@"total"]];
            _lblShopFee.text = [NSString stringWithFormat:@"%@", [groupDic[@"shop_fee"] isKindOfClass:[NSNull class]] ? @"0" : groupDic[@"shop_fee"]];
            _lblDiscount.text = [NSString stringWithFormat:@"%@", [groupDic[@"discount"] isKindOfClass:[NSNull class]] ? @"0" : groupDic[@"discount"]];
            _lblTip.text = [NSString stringWithFormat:@"%@", [groupDic[@"tips"] isKindOfClass:[NSNull class]] ? @"0" : groupDic[@"tips"]];
            
            for(NSDictionary *services in servicesDict){
                servicesModel = [[ServicesModel alloc] init];
                servicesModel.serviceID = [NSString stringWithFormat:@"%@", [services[@"id"] isKindOfClass:[NSNull class]] ? @"0" : services[@"id"]];
                servicesModel.billID = [NSString stringWithFormat:@"%@", [billID isKindOfClass:[NSNull class]] ? @"0" : billID];
                servicesModel.service_name = [services[@"service_name"] isKindOfClass:[NSNull class]] ? @"No Data" : services[@"service_name"];
                servicesModel.employee_name = [services[@"employee_name"] isKindOfClass:[NSNull class]] ? @"No Data" : services[@"employee_name"];
                servicesModel.price = [NSString stringWithFormat:@"%@", [services[@"price"] isKindOfClass:[NSNull class]] ? @"0" : services[@"price"]];
                servicesModel.shop_fee = [NSString stringWithFormat:@"%@", [services[@"shop_fee"] isKindOfClass:[NSNull class]] ? @"0" : services[@"shop_fee"]];
                servicesModel.discount = [NSString stringWithFormat:@"%@", [services[@"discount"] isKindOfClass:[NSNull class]] ? @"0" : services[@"discount"]];
                servicesModel.tips = [NSString stringWithFormat:@"%@", [services[@"tips"] isKindOfClass:[NSNull class]] ? @"0" : services[@"tips"]];
                
                [arrServices addObject:servicesModel];
            }
            
            [self.tbServicesList reloadData];
        } else {
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert !!!" message:@"Can not get billing details" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
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
    return arrServices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BillingDetailsCell *cell = (BillingDetailsCell *)[tableView dequeueReusableCellWithIdentifier:@"servicesCell" forIndexPath:indexPath];
    
    ServicesModel *model = arrServices[indexPath.row];
    cell.lblServicesName.text = model.service_name;
    cell.lblEmployeeName.text = model.employee_name;
    cell.lblPrice.text = model.price;
    cell.lblShopFee.text = model.shop_fee;
    cell.lblDiscount.text = model.discount;
    cell.lblTips.text = model.tips;
    cell.delegate = self;
    
    UIImage *image = [UIImage imageNamed:@"services.png"];
    [cell.imgServices setImage:image];
    
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = @"Loading";
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSString *token = appDelegate.token;
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]; //Intialialize AFURLSessionManager
        
        NSError *error;
        ServicesModel *model = arrServices[indexPath.row];
        NSString *billID = model.billID;
        NSString *serviceID = model.serviceID;
        NSMutableArray *arr = [NSMutableArray arrayWithObjects:serviceID,nil];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:0 error:&error]; // Convert parameter to NSDATA
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSString *urlDeleteBill = [NSString stringWithFormat: @"%@/%@?udid=%@", @BillRemoveService,billID, @"68753A44-4D6F-1226-9C60-0050E4C00067"];
        NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlDeleteBill parameters:nil error:nil];
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
                if([status isEqualToString:@"success"]){
                    [arrServices removeObjectAtIndex:indexPath.row];
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                }
                else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert !!!" message:@"Delete Services Error" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [alert setTag:1];
                    [alert show];
                }
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert !!!" message:@"Delete Services Error" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert setTag:1];
                [alert show];
            }
            
        }]resume];
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

@end
