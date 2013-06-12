//
//  scoreInfo.h
//  temp_trans
//
//  Created by 张 宇洋 on 13-2-19.
//  Copyright (c) 2013年 张 宇洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface score_detail : NSObject
{
    NSString *userName;
    NSString *eva_detail;
    NSInteger score;
}
@property NSString *userName, *eva_detail;
@property NSInteger score;
@end

@interface scoreInfo : NSObject
{
    double averageScore;
    NSInteger scoreUserNum;
    NSMutableArray *scoreDetailList;
}
@property double averageScore;
@property NSInteger scoreUserNum;
@property NSMutableArray *scoreDetailList;
@end
