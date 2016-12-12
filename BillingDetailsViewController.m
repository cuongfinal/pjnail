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

@interface BillingDetailsViewController ()
@end

BillingDetailsModel *billModel;
ServicesModel *servicesModel;

@implementation BillingDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getDetails:(NSString*)billID{
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *token = appDelegate.token;
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]; //Intialialize AFURLSessionManager
    NSString *urlCustomerList = [NSString stringWithFormat: @"%@/%@?udid=%@", @CustomerList,billID, @"68753A44-4D6F-1226-9C60-0050E4C00067"];
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:urlCustomerList parameters:nil error:nil];
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setValue:token forHTTPHeaderField:@"Authorization"];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            NSDictionary *jsonDict = (NSDictionary *) responseObject;
            NSDictionary *servicesDict = [jsonDict objectForKey:@"services"];
            for (NSDictionary *groupDic in jsonDict) {
                billModel = [[BillingDetailsModel alloc] init];
                billModel.payment_type = groupDic[@"payment_type"];
                billModel.receive = groupDic[@"receive"];
                billModel.note = groupDic[@"note"];
                billModel.done = groupDic[@"done"];
                billModel.billing_date = groupDic[@"address"];
                billModel.returns = groupDic[@"returns"];
                billModel.customer = groupDic[@"customer"];
                billModel.total = groupDic[@"total"];
                billModel.shop_fee = groupDic[@"shop_fee"];
                billModel.discount = groupDic[@"discount"];
                billModel.tips = groupDic[@"tips"];

            }
            for(NSDictionary *services in servicesDict){
                servicesModel = [[ServicesModel alloc] init];
                servicesModel.service_name = services[@"service_name"];
                servicesModel.employee_name = services[@"employee_name"];
                servicesModel.price = services[@"price"];
                servicesModel.shop_fee = services[@"shop_fee"];
                servicesModel.discount = services[@"discount"];
                servicesModel.tips = services[@"tips"];
            }
            
            [self.tbServicesList reloadData];
        } else {
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert !!!" message:@"Your username or password is incorrect" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert setTag:1];
            [alert show];
        }
        
    }]resume];
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
