//
//  userData.h
//  temp_trans
//
//  Created by 张 宇洋 on 13-1-30.
//  Copyright (c) 2013年 张 宇洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#define USERDATA_MALE 2
#define USERDATA_FEMALE 1
#define USERDATA_ALL_GENDER 0
@interface userData : NSObject

{
@public
    NSInteger index;
    NSString *name;
    NSInteger gender;
    NSString *head_img;
    double latitude;       //纬度
    double longitude;     //经度
    
}
@property(atomic,readwrite) NSInteger index;
@property(atomic,retain) NSString *name;
@property(atomic,readwrite) NSInteger gender;
@property(atomic,retain) NSString *head_img;
@property(atomic,readwrite) double latitude;
@property(atomic,readwrite) double longitude;



@end
