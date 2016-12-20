//
//  TestViewController.h
//  ActionSheetDemo
//
//  Created by Gabriel Theodoropoulos on 23/4/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddServicePopupControllerDelegate

-(void)userDataChangedWithUsername:(NSString *)username andAgeRange:(NSString *)ageRange andGender:(NSString *)gender;

@end


@interface AddServicePopupController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) id<AddServicePopupControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerServices;

- (IBAction)done:(id)sender;

@end
