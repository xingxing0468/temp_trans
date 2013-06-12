//
//  chatWinController.h
//  temp_trans
//
//  Created by 张 宇洋 on 13-2-2.
//  Copyright (c) 2013年 张 宇洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "userData.h"
#import "availableDateNearbyController.h"

@interface chatWinController : UITableViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UINavigationBarDelegate,UINavigationControllerDelegate>{
    
    NSMutableArray		*chatViewArray;
	NSString			*chatFile;
    
	NSMutableDictionary	*currentChatInfo;
	NSMutableString		*currentString;
    BOOL				storingCharacters;
	UITableView*        chatTableView;
	BOOL				isMySpeaking;
	BOOL				loadingLog;
    userData            *caller;
    userData            *receiver;
}
@property userData* caller;
@property userData* receiver;



-(id) init:(userData*) inCaller receiver:(userData*) inReceiver;
@end
