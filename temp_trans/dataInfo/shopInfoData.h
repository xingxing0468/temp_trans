//
//  shopInfoData.h
//  temp_trans
//
//  Created by 张 宇洋 on 13-2-6.
//  Copyright (c) 2013年 张 宇洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface shopInfoData : NSObject
{
    NSString* shopName;
    double latitude;       //纬度
    double longitude;     //经度
    NSString* inCity;
    NSString* inDistrict;
    NSString* address;
    NSString* telNum_1;
    NSString* telNum_2;

    
    NSString* shopDetailInfo;
    NSString* shopImgName;
    NSInteger shopIndex;
    

}

@property NSString *shopName, *inCity, *inDistrict, *shopDetailInfo, *shopImgName,*address,*telNum_1,*telNum_2;
@property double latitude,longitude;
@property NSInteger shopIndex;

@end
