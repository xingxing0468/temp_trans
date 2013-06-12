//
//  peopleNearby.h
//  temp_trans
//
//  Created by 张 宇洋 on 13-2-3.
//  Copyright (c) 2013年 张 宇洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "chatWinController.h"
#import "userDataParser_xml.h"
#import "testNav.h"
#import "AppDelegate.h"
#import "EGORefreshTableHeaderView.h"
@interface peopleNearby : UITableViewController<UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate>
{
    userData* localUser;
    
    testNav *nav;
    userDataParser_xml *userXMLFile;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}
@property (strong,nonatomic) NSArray *list;
@property userData* localUser;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
- (void) selectButtonAction;
@end