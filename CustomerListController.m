//
//  AssignEmployeeController.m
//  PJNails
//
//  Created by IVC on 4/28/16.
//  Copyright © 2016 LQTC. All rights reserved.
//

#import "CustomerListController.h"
#import "CustomerListCell.h"
#import "SWRevealViewController.h"
#import "AFNetworking.h"
#import "DefineClass.h"
#import "AppDelegate.h"
#import "LoginController.h"
#import "CustomerModel.h"

@interface CustomerListController ()
@end

CustomerModel *model2;
NSMutableArray *arrCustomer;
NSMutableArray *arrName2;
NSMutableArray *arrPhone;

@implementation CustomerListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Customer List", nil);
    
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
    
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *token = appDelegate.token;
    [self getCustomerList:token];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)addCustomer{
   [self performSegueWithIdentifier:@"add_customer" sender:self];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    
}
-(void)getCustomerList:(NSString*)token{
    arrCustomer = [[NSMutableArray alloc] init];
    arrName2 = [[NSMutableArray alloc] init];
    arrPhone = [[NSMutableArray alloc] init];

    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]; //Intialialize AFURLSessionManager
    NSString *urlCustomerList = [NSString stringWithFormat: @"%@?udid=%@", @CustomerList, @"68753A44-4D6F-1226-9C60-0050E4C00067"];
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:urlCustomerList parameters:nil error:nil];
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setValue:token forHTTPHeaderField:@"Authorization"];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            NSDictionary *jsonDict = (NSDictionary *) responseObject;
            for (NSDictionary *groupDic in jsonDict) {
                model2 = [[CustomerModel alloc] init];
                model2.shops_id = groupDic[@"shops_id"];
                model2.first_name = groupDic[@"first_name"];
                model2.last_name = groupDic[@"last_name"];
                model2.birthday = groupDic[@"birthday"];
                model2.address = groupDic[@"address"];
                model2.telephone = groupDic[@"telephone"];
                model2.email = groupDic[@"email"];
                NSString *name = [NSString stringWithFormat:@"%@ %@", model2.first_name, model2.last_name];
                [arrName2 addObject:name];
                [arrPhone addObject:model2.telephone];
                [arrCustomer addObject:model2];
            }
            
            [self.tableView reloadData];
        } else {
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert !!!" message:@"Your username or password is incorrect" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert setTag:1];
            [alert show];
        }
        
    }]resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrCustomer.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomerListCell *cell = (CustomerListCell *)[tableView dequeueReusableCellWithIdentifier:@"CustomerCell" forIndexPath:indexPath];
    
    // Add utility buttons
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];

    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.95 green:0.61 blue:0.07 alpha:1.0]
                                                title:@"Detail"];

    cell.leftUtilityButtons = leftUtilityButtons;
    cell.rightUtilityButtons = rightUtilityButtons;
    cell.delegate = self;

    UIImage *image = [UIImage imageNamed:@"checked-icon.png"];
    cell.lblName.text = arrName2[indexPath.row];
    cell.lblPhone.text = arrPhone[indexPath.row];
//    if([arrStatus[indexPath.row]  isEqual: @"0"]){
//        image = [UIImage imageNamed:@"uncheck-icon.png"];
//    }
//    [cell.imgStatus setImage:image];
    
    return cell;
}
-(void)handleSwipeFrom:(UIGestureRecognizer *)tap{
    CGPoint touch           = [tap locationInView:self.tableView];
    NSIndexPath *indexPath  = [self.tableView indexPathForRowAtPoint:touch];
}
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            [self performSegueWithIdentifier:@"show_customer_details" sender:self];
            break;
        }
        default:
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"show_customer_details"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        CustomerDetailsController *customer = segue.destinationViewController;
        customer.arrDetails = [[NSMutableArray alloc] init];
        [customer.arrDetails addObject:[arrCustomer objectAtIndex:indexPath.row]];
        NSLog(@"%@", customer.arrDetails);
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
