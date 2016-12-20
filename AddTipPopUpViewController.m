//
//  TestViewController.m
//  ActionSheetDemo
//
//  Created by Gabriel Theodoropoulos on 23/4/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "AddTipPopUpViewController.h"

@interface AddTipPopUpViewController ()

@property (nonatomic, strong) NSArray *arrAgeRanges;

@end


@implementation AddTipPopUpViewController

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
    self.txtTip.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBAction method implementation

- (IBAction)done:(id)sender {
    [self.delegate dataChangeWithTipValue:self.txtTip.text];
}


#pragma mark - UITextField Delegate method implementation

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.txtTip resignFirstResponder];
    return YES;
}


@end
