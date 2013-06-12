//
//  dateDetailController.h
//  temp_trans
//
//  Created by 张 宇洋 on 13-2-16.
//  Copyright (c) 2013年 张 宇洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "userData.h"
#import "dateInfoData.h"
#import <CoreLocation/CoreLocation.h>

#define STATE_NEED_LAUNCH              0
#define STATE_NEED_ACCEPT              1
#define STATE_NEED_PAY                 2
#define STATE_DONE                     3
#define STATE_REJECTED                 4


@interface dateDetailController : UITableViewController<UITableViewDataSource,UITableViewDelegate,UINavigationBarDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

{
    NSInteger dateState;
    userData *caller;
    userData *receiver;
    dateInfoData *nowDate;
    CLLocationManager *myLocManager;
    //UITableView *dateDetailTable;
    
}
@property NSInteger dateState;
@property userData* caller;
@property userData* receiver;
@property dateInfoData* nowDate;



-(id) init: (dateInfoData*)inDate state:(NSInteger) inState;
@end
