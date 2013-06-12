//
//  shopInfoParser_xml.h
//  temp_trans
//
//  Created by 张 宇洋 on 13-2-7.
//  Copyright (c) 2013年 张 宇洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "shopInfoData.h"

@interface shopInfoParser_xml : NSObject
{
    NSXMLParser* shopInfoParser;
    NSMutableArray *shopList;
    shopInfoData* nowShopNode;
    NSString* nowElement;
    NSInteger selectID;
    
}
-(NSMutableArray *) get_shops;
-(shopInfoData*) getShopByID:(NSInteger) shopID;

+(shopInfoParser_xml *) GetInstance;
@property(atomic,readwrite) NSInteger selectID;


@end
