//
//  SecondViewController.h
//  temp_trans
//
//  Created by 张 宇洋 on 13-1-25.
//  Copyright (c) 2013年 张 宇洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "chatWinController.h"
#import "userDataParser_xml.h"
#import "testNav.h"
#import "AppDelegate.h"

@interface SecondViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    userData* localUser;
    chatWinController *chatWin;
    testNav *nav;
}
@property (strong,nonatomic) NSArray *list;
@property userData* localUser;




@end
