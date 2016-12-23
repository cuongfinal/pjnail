//
//  TestViewController.h
//  ActionSheetDemo
//
//  Created by Gabriel Theodoropoulos on 23/4/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddServicePopupControllerDelegate

-(void)dataChangeServices:(NSString *)servicesItem employees:(NSString *)employees;

@end


@interface AddServicePopupController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) id<AddServicePopupControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerServices;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerEmployee;
@property (strong, nonatomic) NSString* token;

- (IBAction)done:(id)sender;

@end
