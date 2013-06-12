//
//  userDataParser.h
//  temp_trans
//
//  Created by 张 宇洋 on 13-1-29.
//  Copyright (c) 2013年 张 宇洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "userData.h"







@interface userDataParser_xml : NSObject
{
    NSXMLParser* userDataParser;
    NSMutableArray *userList;
    userData* nowUserNode;
    NSString* nowElement;
    NSInteger selectedGender;
    
}
-(NSMutableArray *) get_userData: (NSString*) xml_fileName;

+(userDataParser_xml *) GetInstance;
@property(atomic,readwrite) NSInteger selectedGender;


@end
