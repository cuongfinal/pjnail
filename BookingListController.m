//
//  CustomerAppointmentController.m
//  PJNails
//
//  Created by IVC on 5/5/16.
//  Copyright © 2016 LQTC. All rights reserved.
//

#import "BookingListController.h"
#import "BookingListCell.h"
#import "SWRevealViewController.h"
#import "AFNetworking.h"
#import "DefineClass.h"
#import "AppDelegate.h"
#import "LoginController.h"
#import "BookingModel.h"
#import "MBProgressHUD.h"


BookingModel *bookingModel;
NSMutableArray *arrBooking;
NSMutableArray *arrNameOnBooking;
NSMutableArray *arrNote;

@implementation BookingListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Booking List", nil);
    
    SWRevealViewController *revealController = [self revealViewController];
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    UIBarButtonItem *searchButton         = [[UIBarButtonItem alloc]
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                             target:self
                                             action:@selector(searchCustomer)];
    
    UIBarButtonItem *addButton          = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                           target:self action:@selector(addCustomer)];
    
    self.navigationItem.rightBarButtonItems =
    [NSArray arrayWithObjects:addButton, searchButton, nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:NO];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *token = appDelegate.token;
    [self getBookingList:token];
}
-(void)addCustomer{
    [self performSegueWithIdentifier:@"booking_add_customer" sender:self];
}
-(void)searchCustomer{
    [self performSegueWithIdentifier:@"booking_search_customer" sender:self];
}
-(void)getBookingList:(NSString*)token{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = @"Loading";
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]; //Intialialize AFURLSessionManager
    NSString *urlCustomerList = [NSString stringWithFormat: @"%@?udid=%@&from=%@&to=%@", @BookingList, @"68753A44-4D6F-1226-9C60-0050E4C00067",@"2016-12-10",@"2018-12-20"];
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:urlCustomerList parameters:nil error:nil];
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setValue:token forHTTPHeaderField:@"Authorization"];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            [hud hideAnimated:YES];
            arrBooking = [[NSMutableArray alloc] init];
            arrNameOnBooking = [[NSMutableArray alloc] init];
            arrNote = [[NSMutableArray alloc] init];
            
            NSDictionary *jsonDict = (NSDictionary *) responseObject;

            for (NSDictionary *groupDic in jsonDict) {
                bookingModel = [[BookingModel alloc] init];
                bookingModel.note = groupDic[@"note"];
                bookingModel.bookingID = [NSString stringWithFormat:@"%@", groupDic[@"id"]];
                NSDictionary *customerDict = [groupDic objectForKey:@"customer"];
                NSString *employeeName;
                for(NSDictionary *customer in customerDict){
                    employeeName = [NSString stringWithFormat:@"%@ %@",customerDict[@"first_name"],customerDict[@"last_name"]];
                }
                [arrNameOnBooking addObject:employeeName];
                [arrNote addObject:bookingModel.note];
                [arrBooking addObject:bookingModel];
            }
            [self.tableView reloadData];
        } else {
            [hud hideAnimated:YES];
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert !!!" message:@"Can not get booking list" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
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
    return arrBooking.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BookingListCell *cell = (BookingListCell *)[tableView dequeueReusableCellWithIdentifier:@"BookingListCell" forIndexPath:indexPath];
    
    cell.delegate = self;
    cell.lblName.text = arrNameOnBooking[indexPath.row];
    cell.lblNote.text = [NSString stringWithFormat:@"%@",arrNote[indexPath.row]];
    
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
        
        BookingModel *model = arrBooking[indexPath.row];
        NSString *bookingID = model.bookingID;
        NSString *urlDeleteBooking = [NSString stringWithFormat: @"%@/%@?udid=%@", @BookingList,bookingID, @"68753A44-4D6F-1226-9C60-0050E4C00067"];
        NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"DELETE" URLString:urlDeleteBooking parameters:nil error:nil];
        req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
        [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [req setValue:token forHTTPHeaderField:@"Authorization"];
        
        [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (!error) {
                [hud hideAnimated:YES];
                NSDictionary *jsonDict = (NSDictionary *) responseObject;
                NSString *status = [jsonDict objectForKey:@"status"];
                NSString *message = [jsonDict objectForKey:@"message"];
                if([status isEqualToString:@"success"]){
                    [arrBooking removeObjectAtIndex:indexPath.row];
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                }
                else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert !!!" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [alert setTag:1];
                    [alert show];
                }
            } else {
                [hud hideAnimated:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert !!!" message:@"Delete Error" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert setTag:1];
                [alert show];
            }
            
        }]resume];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // set Segue Identifier from your first viewcontroller to second viewController in stoaryboard
    [self performSegueWithIdentifier:@"show_billing_details" sender:indexPath];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"show_billing_details"]) {
//        NSIndexPath *indexPath = (NSIndexPath *)sender;
//        BookingListCell *model = arrBill[indexPath.row];
//        NSString *billID = model.billID;
//        BillingDetailsViewController *billingDetails = segue.destinationViewController;
//        [billingDetails getDetails:[NSString stringWithFormat:@"%@", billID]];
//    }
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

@end
