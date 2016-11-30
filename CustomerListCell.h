//
//  CustomerListCell.h
//  PJNails
//
//  Created by IVC on 4/28/16.
//  Copyright © 2016 LQTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTable/SWTableViewCell.h"
@interface CustomerListCell : SWTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
@property (weak, nonatomic) IBOutlet UIImageView *imgStatus;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;

@end
