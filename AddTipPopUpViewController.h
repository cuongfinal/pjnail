//
//  TestViewController.h
//  ActionSheetDemo
//
//  Created by Gabriel Theodoropoulos on 23/4/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddTipPopUpViewControllerDelegate

-(void)dataChangeWithTipValue:(NSString *)tipValue;

@end


@interface AddTipPopUpViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) id<AddTipPopUpViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *txtTip;
- (IBAction)done:(id)sender;

@end
