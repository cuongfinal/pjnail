//
//  CustomerDetailsController.m
//  PJNails
//
//  Created by lehongphong on 12/4/16.
//  Copyright © 2016 LQTC. All rights reserved.
//

#import "CustomerDetailsController.h"
#import "SWRevealViewController.h"


@implementation CustomerDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_imgAvatar.layer setBorderWidth: 2.0];
    [_imgAvatar.layer setCornerRadius:20];
    _imgAvatar.layer.masksToBounds = YES;

    for (CustomerModel *customerModel in self.arrDetails) {
        self.lblName.text = customerModel.telephone;
        self.lblAddress.text = customerModel.address;
        self.lblBirthday.text = customerModel.birthday;
        self.lblTelephone.text = customerModel.telephone;
        self.lblEmail.text = customerModel.email;
        self.lblShopID.text = [NSString stringWithFormat:@"%@",customerModel.shops_id];
    }
    self.title = NSLocalizedString(@"Customer Details", nil);
    
}
-(void)displayDetails:(CustomerModel*)model{

}

@end
