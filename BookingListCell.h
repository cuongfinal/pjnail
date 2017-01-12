//
//  CustomerAppointmentCell.h
//  PJNails
//
//  Created by LQTCuong on 1/10/17.
//  Copyright © 2017 LQTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface BookingListCell : SWTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblNote;
@property (weak, nonatomic) IBOutlet UIImageView *imgStatus;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;

@end
