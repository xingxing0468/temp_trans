//
//  userDataParser.m
//  temp_trans
//
//  Created by 张 宇洋 on 13-1-29.
//  Copyright (c) 2013年 张 宇洋. All rights reserved.
//

#import "userDataParser_xml.h"


@implementation userDataParser_xml

static userDataParser_xml* instance;
//BOOL _flag = YES;
NSString* m_strCurrentElement;
@synthesize selectedGender;

+(userDataParser_xml *)GetInstance{
    @synchronized(self)
    {
        if(instance ==nil)
        {
            instance = [[self alloc] init];
            
        }
    }
    return instance;
}

-(NSMutableArray *)get_userData:(NSString *)fileName{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"user_data" ofType:@"xml"];
    NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData* data = [file readDataToEndOfFile];
    [file closeFile];
    
    userDataParser = [[NSXMLParser alloc] initWithData:data];
    
    [userDataParser setDelegate:self];

    
    BOOL flag = [userDataParser parse];
    if(flag)    {  NSLog(@"User Data XML File Read Success!");}
    else        {  NSLog(@"User Data XML File Read Failed!");}
    //[userDataParser release];         --?
    //[userDataParser dealloc];         --?
    
    return userList;
}

-(void) parser:(NSXMLParser*)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    //_flag = YES;
    
    m_strCurrentElement = elementName;
    
    if([elementName isEqualToString:@"users"])
    {
        userList = [[NSMutableArray alloc] init];
    }
    
    if([elementName isEqualToString:@"user"])
    {
        nowUserNode = [userData alloc];
        nowUserNode.index = [[attributeDict objectForKey:@"id"] integerValue];
    }
    nowElement = elementName;
    
}

-(void) parser:(NSXMLParser*)parser foundCharacters:(NSString *)string{
    if([string hasPrefix:@"\n"]) return;
    if([nowElement isEqualToString:@"name"]) { nowUserNode.name = string; }
    if([nowElement isEqualToString:@"head_img"]){  nowUserNode.head_img = string;}
    if([nowElement isEqualToString:@"sex"])
    {
        if ([string isEqualToString:@"male"]) {nowUserNode.gender = USERDATA_MALE;}
        if ([string isEqualToString:@"female"]) {nowUserNode.gender = USERDATA_FEMALE;}
    }
    if([nowElement isEqualToString:@"latitude"]){  nowUserNode.latitude = [string doubleValue];}
    if([nowElement isEqualToString:@"longitude"]){  nowUserNode.longitude = [string doubleValue];}
    return;
}

-(void) parser:(NSXMLParser*)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if([elementName isEqualToString:@"user"])
    {
        if(selectedGender == USERDATA_ALL_GENDER || selectedGender == nowUserNode.gender)
        {
            [userList addObject:nowUserNode];
        }
    }
    if([elementName isEqualToString:@"users"])   { return; }
    
}



@end
