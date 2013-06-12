//
//  availableDateNearbyController.h
//  temp_trans
//
//  Created by 张 宇洋 on 13-2-8.
//  Copyright (c) 2013年 张 宇洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "userData.h"
#import "dateInfoData.h"
#import "availableDateInfoParser_xml.h"
#import <CoreLocation/CoreLocation.h>

#define CAN_ORDER_PNG_CODE          0
#define CAN_PREPAY_PNG_CODE         1
#define CAN_REFUND_PNG_CODE         2


//UI DESIGN
#define  BTN_WIDTH                  50
#define  BTN_HEIGHT                 30
#define  SELECT_BAR_HEIGHT          30
#define  EDGE_WIDTH                 10
#define  EDGE_HEIGHT                10
#define  DATE_IMAGE_WIDTH           80
#define  DATE_IMAGE_HEIGHT          60
#define  DATE_TITLE_LABEL_WIDTH     160
#define  DATE_TITLE_LABEL_HEIGHT    30
#define  SHOP_NAME_LABEL_WIDTH      160
#define  SHOP_NAME_LABEL_HEIGHT     15

#define  PAYICON_VIEW_WIDTH         20
#define  PAYICON_VIEW_HEIGHT        60

#define  PRICE_LABEL_WIDTH          130
#define  PRICE_LABEL_HEIGHT         15


#define  DATE_TITLE_FONT_SIZE       12
#define  SHOP_NAME_FONT_SIZE        10
#define  ORIGIN_PRICE_FONT_SIZE     10
#define  NOW_PRICE_FONT_SIZE        14
#define  DISTANCE_FONT_SIZE         10

#define  PAY_ICON_WIDTH             15
#define  PAY_ICON_HEIGHT            15

@interface availableDateNearbyController : UITableViewController<UITableViewDelegate, UITableViewDataSource,UINavigationBarDelegate,UINavigationControllerDelegate>
{
    userData *caller;
    UITableView *availableDateTable;
    availableDateInfoParser_xml *dateInfoParser;
    NSMutableArray *dateInfo_List;
    CLLocationManager *myLocManager;
}
@property userData *caller;
-(id) init:(userData*) inCaller;

@end
