//
//  TestViewController.m
//  ActionSheetDemo
//
//  Created by Gabriel Theodoropoulos on 23/4/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "AddServicePopupController.h"

@interface AddServicePopupController ()

@property (nonatomic, strong) NSArray *arrAgeRanges;

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
    
    self.arrAgeRanges = [[NSArray alloc] initWithObjects:@"< 18", @"18 - 25", @"25 - 30", @"30 - 35", @"35 - 40", @">= 40", nil];
    
    self.txtName.delegate = self;
    
    self.pickerAge.delegate = self;
    self.pickerAge.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBAction method implementation

- (IBAction)done:(id)sender {
    [self.delegate userDataChangedWithUsername:self.txtName.text
                                   andAgeRange:[self.arrAgeRanges objectAtIndex:[self.pickerAge selectedRowInComponent:0]]
                                     andGender:[self.segGender titleForSegmentAtIndex:self.segGender.selectedSegmentIndex]];
}


#pragma mark - UITextField Delegate method implementation

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.txtName resignFirstResponder];
    
    return YES;
}


#pragma mark - UIPickerView method implementation

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.arrAgeRanges.count;
}


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.arrAgeRanges objectAtIndex:row];
}

@end
