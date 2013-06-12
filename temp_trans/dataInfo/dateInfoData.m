//
//  dateInfoData.m
//  temp_trans
//
//  Created by 张 宇洋 on 13-2-6.
//  Copyright (c) 2013年 张 宇洋. All rights reserved.
//

#import "dateInfoData.h"

@implementation dateInfoData
@synthesize dateName,detailInfo,dateImgName;
@synthesize originPrice, nowPrice;
@synthesize dateType;
@synthesize canPrePay,canOrder,canRefund;
@synthesize startTime,endTiem;
@synthesize shop;
@synthesize index;
@synthesize score;


-(id) init
{
    if(self = [super init])
    {
        //shop = [[shopInfoData alloc] init];
        score = [[scoreInfo alloc] init];
        //dateName = [[NSString alloc] init];
    }
    return self;
}
@end
