//
//  CustomerRegisterController.m
//  PJNails
//
//  Created by IVC on 5/5/16.
//  Copyright © 2016 LQTC. All rights reserved.
//

#import "CustomerRegisterController.h"

@interface CustomerRegisterController ()
{
    NSArray *_pickerData;
}
@end

@implementation CustomerRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Init data
    _pickerData = @[@"Nails",@"Washing",@"Eyes",@"Body"];
    
    //Connect data
    self.pickerServices.dataSource = self;
    self.pickerServices.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//picker comlumn
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//picker row
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _pickerData.count;
}
//data return
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row];
}
- (IBAction)clickRegister:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Register Successfull" message:@"Successfully" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert setTag:1];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        [self performSegueWithIdentifier:@"customer_register_success" sender:self];
    }
}
@end
