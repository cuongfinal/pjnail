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
NSMutableArray *arrPhone3;
@implementation SearchCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.token = appDelegate.token;
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

- (IBAction)tapSearch:(id)sender {
    arrCustomer3 = [[NSMutableArray alloc] init];
    arrName3 = [[NSMutableArray alloc] init];
    arrPhone3 = [[NSMutableArray alloc] init];
    
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
            }
            [self.tbResultList reloadData];
        } else {
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert !!!" message:@"Can not get any customer info" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
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
    return arrCustomer3.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ResultListCell *cell = (ResultListCell *)[tableView dequeueReusableCellWithIdentifier:@"ResultListCell" forIndexPath:indexPath];
    
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

@end
