//
//  DefineClass.h
//  PJNails
//
//  Created by lehongphong on 12/2/16.
//  Copyright © 2016 LQTC. All rights reserved.
//

#import <Foundation/Foundation.h>

#define URL "http://259970a7.ngrok.io/"
#define GetAccessToken URL "api/api-users/token"
#define ShopLogin URL "api/shops/login"
#define UserLogin URL "api/users/login"
#define ShopLogin URL "api/shops/login"

#define CustomerList URL "api/customers"
#define CreateCustomer URL "api/customers"
#define SearchCustomer URL "api/customers/search?keyword="

#define BillingList URL "api/billings"
#define CreateBill URL "api/billings"
#define BillingDetails URL "api/billings"
#define BillRemoveService URL "api/billings/remove-services"
#define BillingDone URL "api/billings/done"
#define BillingTip URL "api/billings/tip"
#define BillingAddServices URL "api/billings/add-services"


#define BookingList URL "api/bookings"

#define ServicesList URL "api/services"
#define EmployeeList URL "api/employees"
@interface DefineClass : NSObject

@end
