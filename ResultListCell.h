//
//  ResultListCell.h
//  PJNails
//
//  Created by lehongphong on 12/25/16.
//  Copyright © 2016 LQTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface ResultListCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;

@end
