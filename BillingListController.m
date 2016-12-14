//
//  BillingListController.m
//  PJNails
//
//  Created by lehongphong on 12/6/16.
//  Copyright © 2016 LQTC. All rights reserved.
//

#import "BillingListController.h"
#import "BillingListCell.h"
#import "BillingDetailsViewController.h"
#import "SWRevealViewController.h"
#import "AFNetworking.h"
#import "DefineClass.h"
#import "AppDelegate.h"
#import "LoginController.h"
#import "BillingModel.h"

BillingModel *model;
NSMutableArray *arrBill;
NSMutableArray *arrName;
NSMutableArray *arrService;

@implementation BillingListController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Billing List", nil);
    
    SWRevealViewController *revealController = [self revealViewController];
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    UIBarButtonItem *addCustomerButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add Customer" style:UIBarButtonItemStylePlain target:self action:@selector(addCustomer)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationItem.rightBarButtonItem = addCustomerButtonItem;
    
    
//    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    NSString *token = appDelegate.token;
//    [self getBillingList:token];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:NO];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *token = appDelegate.token;
    [self getBillingList:token];
}
-(void)addCustomer{
    [self performSegueWithIdentifier:@"add_customer" sender:self];
}
-(void)getBillingList:(NSString*)token{
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]; //Intialialize AFURLSessionManager
    NSString *urlCustomerList = [NSString stringWithFormat: @"%@?udid=%@", @BillingList, @"68753A44-4D6F-1226-9C60-0050E4C00067"];
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:urlCustomerList parameters:nil error:nil];
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setValue:token forHTTPHeaderField:@"Authorization"];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            arrBill = [[NSMutableArray alloc] init];
            arrName = [[NSMutableArray alloc] init];
            arrService = [[NSMutableArray alloc] init];
            
            NSDictionary *jsonDict = (NSDictionary *) responseObject;
            for (NSDictionary *groupDic in jsonDict) {
                model = [[BillingModel alloc] init];
                model.name = groupDic[@"customer"];
                model.service = groupDic[@"services"];
                model.billID = [NSString stringWithFormat:@"%@", groupDic[@"id"]];
                [arrName addObject:model.name];
                [arrService addObject:model.service];
                [arrBill addObject:model];
            }
            [self.tableView reloadData];
        } else {
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert !!!" message:@"Can not get billing list" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
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
    return arrBill.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BillingListCell *cell = (BillingListCell *)[tableView dequeueReusableCellWithIdentifier:@"BillingListCell" forIndexPath:indexPath];
    
    // Add utility buttons
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor: [UIColor colorWithRed:0.75 green:0.22 blue:0.17 alpha:1.0]
                                                title:@"Delete"];
    
    cell.leftUtilityButtons = leftUtilityButtons;
    cell.rightUtilityButtons = rightUtilityButtons;
    cell.delegate = self;
    
    UIImage *image = [UIImage imageNamed:@"checked-icon.png"];
    cell.lblName.text = arrName[indexPath.row];
    cell.lblPhone.text = [NSString stringWithFormat:@"%@",arrService[indexPath.row]];
    //    if([arrStatus[indexPath.row]  isEqual: @"0"]){
    //        image = [UIImage imageNamed:@"uncheck-icon.png"];
    //    }
    //    [cell.imgStatus setImage:image];
    
    return cell;
}
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            [self performSegueWithIdentifier:@"show_billing_details" sender:self];
            break;
        }
        default:
            break;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // set Segue Identifier from your first viewcontroller to second viewController in stoaryboard
    [self performSegueWithIdentifier:@"show_billing_details" sender:indexPath];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"show_billing_details"]) {
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        BillingModel *model = arrBill[indexPath.row];
        NSString *billID = model.billID;
        BillingDetailsViewController *billingDetails = segue.destinationViewController;
        [billingDetails getDetails:[NSString stringWithFormat:@"%@", billID]];
    }
}

@end
