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
    
    self.pickerServices.delegate = self;
    self.pickerServices.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBAction method implementation

- (IBAction)done:(id)sender {
    [self.delegate dataChangeServices:[self.arrAgeRanges objectAtIndex:[self.pickerServices selectedRowInComponent:0]]];
}

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
