//
//  shopInfoParser_xml.m
//  temp_trans
//
//  Created by 张 宇洋 on 13-2-7.
//  Copyright (c) 2013年 张 宇洋. All rights reserved.
//

#import "shopInfoParser_xml.h"

@implementation shopInfoParser_xml
@synthesize selectID;


static shopInfoParser_xml* instance;
//BOOL _flag = YES;
BOOL parseDone_flag = NO;
NSString* m_strCurrentElement;


+(shopInfoParser_xml *)GetInstance{
    @synchronized(self)
    {
        if(instance ==nil)
        {
            instance = [[self alloc] init];
            
        }
    }
    return instance;
}

-(NSMutableArray *)get_shops{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"shop_data" ofType:@"xml"];
    NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData* data = [file readDataToEndOfFile];
    [file closeFile];
    
    shopInfoParser = [[NSXMLParser alloc] initWithData:data];
    
    [shopInfoParser setDelegate:self];
    
    
    BOOL flag = [shopInfoParser parse];
    //while(!parseDone_flag){}//wait until parse done
    if(flag)    {  NSLog(@"Shop Info XML File Read Success!");}
    else        {  NSLog(@"Shop Info XML File Read Failed!");}
    //[userDataParser release];         --?
    //[userDataParser dealloc];         --?
    
    return shopList;
}

-(void) parser:(NSXMLParser*)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    //_flag = YES;
    
    m_strCurrentElement = elementName;
    
    if([elementName isEqualToString:@"shops"])
    {
        shopList = [[NSMutableArray alloc] init];
    }
    
    if([elementName isEqualToString:@"shop"])
    {
        nowShopNode = [shopInfoData alloc];
        [nowShopNode setShopIndex:[[attributeDict objectForKey:@"id"] integerValue]];
       
    }
    nowElement = elementName;
    
}

-(void) parser:(NSXMLParser*)parser foundCharacters:(NSString *)string{
    if([string hasPrefix:@"\n"]) return;
    if([nowElement isEqualToString:@"shopName"])
    {
        [nowShopNode setShopName:string];
    }
    if([nowElement isEqualToString:@"latitude"])   { [nowShopNode setLatitude:[string doubleValue]];}
    if([nowElement isEqualToString:@"longitude"])  { [nowShopNode setLongitude:[string doubleValue]];}
    if([nowElement isEqualToString:@"inCity"])     { [nowShopNode setInCity:string];}
    if([nowElement isEqualToString:@"inDistrict"]) { [nowShopNode setInDistrict:string];}
    if([nowElement isEqualToString:@"address"])    { [nowShopNode setAddress:string];}
    if([nowElement isEqualToString:@"telNum_1"])     { [nowShopNode setTelNum_1:string];}
    if([nowElement isEqualToString:@"telNum_2"])     { [nowShopNode setTelNum_2:string];}
    if([nowElement isEqualToString:@"shopImgName"]){ [nowShopNode setShopImgName:string];}
    if([nowElement isEqualToString:@"shopDetailInfo"]){ [nowShopNode setShopDetailInfo:string];}
    return;
}

-(void) parser:(NSXMLParser*)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if([elementName isEqualToString:@"shop"])
    {
        [shopList addObject:nowShopNode];
    }
    if([elementName isEqualToString:@"shops"])   { parseDone_flag = YES; return; }
    
}


@end
