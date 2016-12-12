//
//  BillingModel.h
//  PJNails
//
//  Created by LQTCuong on 12/12/16.
//  Copyright © 2016 LQTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServicesModel : NSObject

@property (nonatomic) NSString *service_name;
@property (nonatomic) NSString *employee_name;
@property (nonatomic) NSString *price;
@property (nonatomic) NSString *shop_fee;
@property (nonatomic) NSString *discount;
@property (nonatomic) NSString *tips;

@end

@interface BillingDetailsModel : NSObject

@property (nonatomic) NSString *payment_type;
@property (nonatomic) NSString *receive;
@property (nonatomic) NSString *note;
@property (nonatomic) NSString *done;
@property (nonatomic) NSString *billing_date;
@property (nonatomic) NSString *returns;
@property (nonatomic) NSString *customer;
@property (nonatomic) NSString *total;
@property (nonatomic) NSString *shop_fee;
@property (nonatomic) NSString *discount;
@property (nonatomic) NSString *tips;
@property (nonatomic) ServicesModel *services;

@end



