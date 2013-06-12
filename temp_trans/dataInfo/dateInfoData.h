//
//  dateInfoData.h
//  temp_trans
//
//  Created by 张 宇洋 on 13-2-6.
//  Copyright (c) 2013年 张 宇洋. All rights reserved.
//


#define DATETYPE_MOVIE              0
#define DATETYPE_FOOD               1
#define DATETYPE_ENTERTAINMENT      2
#define DATETYPE_HOTEL              3

#import <Foundation/Foundation.h>
#import "shopInfoData.h"
#import "scoreInfo.h"


@interface dateInfoData : NSObject{
    NSInteger index;
    NSInteger dateType;
    NSDate *startTime;
    NSDate *endTime;
    
    
    
    NSString *dateName;
    shopInfoData *shop;
    
    
    
    NSString *detailInfo;
    double originPrice;
    double nowPrice;
    
    

   
    
    NSString *dateImgName;
    scoreInfo *score; //评价，包括评分，评分人，详细评价
    
    
    BOOL canPrePay;
    BOOL canOrder;
    BOOL canRefund;
    
    
    
    
    
}
@property NSInteger dateType;
@property NSString *dateName,*detailInfo,*dateImgName;
@property double originPrice, nowPrice;
@property BOOL canPrePay,canOrder,canRefund;
@property NSDate *startTime,*endTiem;
@property shopInfoData *shop;
@property NSInteger index;
@property scoreInfo *score;

-(id) init;

@end
