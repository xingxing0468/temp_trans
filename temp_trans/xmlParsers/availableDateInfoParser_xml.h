//
//  availableDateInfoParser_xml.h
//  temp_trans
//
//  Created by 张 宇洋 on 13-2-7.
//  Copyright (c) 2013年 张 宇洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "shopInfoParser_xml.h"
#import "dateInfoData.h"

@interface availableDateInfoParser_xml : NSObject
{
    NSXMLParser* availableDateInfoParser;
    NSMutableArray *availableDateList;
    dateInfoData* nowAvailableDate;
    NSString* nowElement;

    NSMutableArray *shopList;
    NSMutableArray *dateList;
    
}
-(NSMutableArray *) get_availableDates;


+(shopInfoParser_xml *) GetInstance;
@property NSMutableArray* shopList;
@end
