//
//  availableDateInfoParser_xml.m
//  temp_trans
//
//  Created by 张 宇洋 on 13-2-7.
//  Copyright (c) 2013年 张 宇洋. All rights reserved.
//

#import "availableDateInfoParser_xml.h"

@implementation availableDateInfoParser_xml

static availableDateInfoParser_xml   * instance;
//BOOL _flag = YES;
NSString* m_strCurrentElement;
@synthesize shopList;

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

-(NSMutableArray *)get_availableDates{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"availableDate_data" ofType:@"xml"];
    NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData* data = [file readDataToEndOfFile];
    NSString *debug = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [file closeFile];
    
    availableDateInfoParser = [[NSXMLParser alloc] initWithData:data];
    shopInfoParser_xml *shopInfoParser = [[shopInfoParser_xml alloc] init];
    shopList = [shopInfoParser get_shops];
    [availableDateInfoParser setDelegate:self];
    
    
    BOOL flag = [availableDateInfoParser parse];
    if(flag)    {  NSLog(@"Available Date Info XML File Read Success!");}
    else        {  NSLog(@"Available Date Info XML File Read Failed!");}
    //[userDataParser release];         --?
    //[userDataParser dealloc];         --?
    
    return dateList;
}

-(void) parser:(NSXMLParser*)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    //_flag = YES;
    
    m_strCurrentElement = elementName;
    
    if([elementName isEqualToString:@"dates"])
    {
        
        dateList = [[NSMutableArray alloc] init];
    }
    
    if([elementName isEqualToString:@"date"])
    {
        nowAvailableDate = [[dateInfoData alloc] init];

        
        nowAvailableDate.index = [[attributeDict objectForKey:@"id"] integerValue];
        
    }
    nowElement = elementName;
    
}

-(void) parser:(NSXMLParser*)parser foundCharacters:(NSString *)string{
    if([string hasPrefix:@"\n"]) return;
    if([nowElement isEqualToString:@"dateName"])
    {
        [nowAvailableDate setDateName:string];
    }
    if([nowElement isEqualToString:@"type"])
    {
        nowAvailableDate.dateType = 0;
    }
    if([nowElement isEqualToString:@"shopID"]){
        
        [nowAvailableDate setShop:[shopList objectAtIndex:[string integerValue]]];
    }
    if([nowElement isEqualToString:@"originPrice"])   { [nowAvailableDate setOriginPrice:[string doubleValue]];}
    if([nowElement isEqualToString:@"nowPrice"])      { [nowAvailableDate setNowPrice:[string doubleValue]];}
    if([nowElement isEqualToString:@"canPrePay"])     { [nowAvailableDate setCanPrePay:[string boolValue]];}
    if([nowElement isEqualToString:@"canOrder"])      { [nowAvailableDate setCanOrder:[string boolValue]];}
    if([nowElement isEqualToString:@"canRefund"])     { [nowAvailableDate setCanRefund:[string boolValue]];}
    if([nowElement isEqualToString:@"imageName"])     { [nowAvailableDate setDateImgName:string];}
    if([nowElement isEqualToString:@"averageScore"])  { [nowAvailableDate.score setAverageScore:[string doubleValue]];}
    if([nowElement isEqualToString:@"scoreUserNum"])  { [nowAvailableDate.score setScoreUserNum:[string integerValue]];}
    if([nowElement isEqualToString:@"detailInfo"])
    {
        [nowAvailableDate setDetailInfo:string];
    }
    return;
}

-(void) parser:(NSXMLParser*)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if([elementName isEqualToString:@"date"])
    {
        //confirm conditions
        //if(..)
        [dateList addObject:nowAvailableDate];
    }
    if([elementName isEqualToString:@"dates"])
    {
        return;
    }
    
}
@end
