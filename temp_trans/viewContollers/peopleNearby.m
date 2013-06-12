//
//  peopleNearby.m
//  temp_trans
//
//  Created by 张 宇洋 on 13-2-3.
//  Copyright (c) 2013年 张 宇洋. All rights reserved.
//

#import "peopleNearby.h"

#import <CoreLocation/CoreLocation.h>





@implementation peopleNearby

@synthesize list=_list;
@synthesize localUser;
NSMutableArray *users;
CLLocationManager *locmanager;
NSInteger selectGender;
NSInteger rowNum;

- (void) selectButtonAction{
    if(selectGender == 2) selectGender = 0;
    else {selectGender++;};
    

    [self performSelectorInBackground:@selector(refreshTableView) withObject:nil];
    
    //get location info, need to be optimized
    [locmanager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locmanager startUpdatingLocation];

    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view1 = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 10.0f-self.tableView.bounds.size.height, self.tableView.frame.size.width, self.view.bounds.size.height)];
        view1.delegate = self;
        [self.tableView addSubview:view1];
        _refreshHeaderView = view1;

    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
	// Do any additional setup after loading the view, typically from a nib.
    [self.tabBarController.tabBar setHidden:NO];
    
    NSString *selectButtonTitle = @" ";
    [self getSelectGender];

    
    
    self.navigationItem.leftBarButtonItem = [self.navigationItem.leftBarButtonItem initWithTitle:selectButtonTitle style:UIBarButtonItemStyleBordered target:self action:@selector(selectButtonAction)];
    
    [self getUsersFromXMLFile];
    selectGender = 0;
    [self performSelectorInBackground:@selector(refreshTableView) withObject:nil];
    
    
    
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.list = nil;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *TableSampleIdentifier = @"tableSampleIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:TableSampleIdentifier];
    }
    
    
    
    NSUInteger row = [indexPath row];
    CLLocation *nowUserLoc = [CLLocation alloc];
    
    //CGRect bounds = cell.bounds;
    
    
    userData *nowUser = [users objectAtIndex:row];

    [cell.textLabel setText:nowUser.name];
    UIImage *head_image = [UIImage imageNamed:nowUser.head_img];
    [cell.imageView setImage:[head_image stretchableImageWithLeftCapWidth:0 topCapHeight:0]];
    [cell.imageView setContentMode:UIViewContentModeScaleToFill];

    [nowUserLoc initWithLatitude:nowUser.latitude longitude:nowUser.longitude];
    double distance = [[locmanager location] distanceFromLocation:nowUserLoc]/1000;
    
    NSString *distanceStr = [[NSString alloc] initWithFormat:@"距离：%.1fkm", distance];
    
    [cell.detailTextLabel setText:distanceStr];
    NSLog(@"%@  :%@",nowUser.name,nowUserLoc);
    
    //NSLog((@"nowUser name: %@; location: %@",nowUser.name, nowUserLoc));
    
    
    
    //cell.textLabel.text = [users objectAtIndex:row];
    
    
    
    //    UILabel *detailLabel_1 = [[UILabel alloc] initWithFrame:CGRectMake(bounds.size.width/2,bounds.size.height/2,bounds.size.width/2, bounds.size.height/4)];
    //    UILabel *detailLabel_2 = [[UILabel alloc] initWithFrame:CGRectMake(bounds.size.width/2,bounds.size.height*3/4,bounds.size.width/2, bounds.size.height/4)];
    //
    //    UIImageView *rightImg = [[UIImageView alloc] initWithFrame:CGRectMake(bounds.size.width-45,0,40, bounds.size.height)];
    //    [rightImg setImage: [UIImage imageNamed:@"ZHUSHENG.jpg"]];
    //
    //
    //
    //    [detailLabel_1 setText:@"xxxxxxxx"];
    //    [detailLabel_2 setText:@"vvvvvvvv"];
    //
    //    [detailLabel_1 setFont:[UIFont fontWithName:@"Arial-BoldItalicMT" size:12]];
    //    [detailLabel_2 setFont:[UIFont fontWithName:@"Arial-BoldItalicMT" size:12]];
    //
    //    [cell.contentView addSubview:detailLabel_1];
    //    [cell.contentView addSubview:detailLabel_2];
    //    [cell.contentView addSubview:rightImg];
    
    
    //    //change layout
    //    CGRect bounds = cell.bounds;
    //    [cell.imageView setFrame:CGRectMake(bounds.size.width*3/4,0, bounds.size.width/4, bounds.               size.height)];
    //    [cell.textLabel setFrame:CGRectMake(0,0, bounds.size.width*3/4, bounds.size.height/2)];
    //    [cell.detailTextLabel setFrame:CGRectMake(0,bounds.size.height/2, bounds.size.width*3/4,
    //                                              bounds.size.height/2)];
    
    
    
    
    return cell;
    
}

-(void) getUsersFromXMLFile{
    
    userDataParser_xml *userXMLFile = [userDataParser_xml alloc];
    userXMLFile.selectedGender = selectGender;
    users = [userXMLFile get_userData:@"user_data"];
    localUser = [users objectAtIndex:0];
    
    
    //get location info, need to be optimized
    locmanager = [[CLLocationManager alloc] init];
    [locmanager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locmanager startUpdatingLocation];
    NSLog(@"current: %@",[locmanager location]);

}


//get last time selectGender
-(void) getSelectGender{
    selectGender = 0;
}

-(void) refreshTableView
{
    [self getUsers_lock];
    [self.tableView reloadData];
    NSString *navTitle = @"";
    NSString *selectButtonTitle = @"";
    switch (selectGender) {
        case ALL_GENDER:
            selectButtonTitle = @"筛选（全部）";
            navTitle = @"附近的好友";
            break;
        case FEMALE:
            selectButtonTitle = @"筛选（妹子）";
            navTitle = @"附近的妹子";
            break;
        case MALE:
            selectButtonTitle = @"筛选（基友）";
            navTitle = @"附近的基友";
            break;
    }
    [self.navigationItem.leftBarButtonItem setTitle:selectButtonTitle];
    [self.navigationItem setTitle:navTitle];
}

-(void) getUsers_lock{
    long i =0;
   // while(i<400000000){i++;}
    userDataParser_xml *userXMLFile = [userDataParser_xml alloc];
    userXMLFile.selectedGender = selectGender;
    users = [userXMLFile get_userData:@"user_data"];
    localUser = [users objectAtIndex:0];
    
    
    //get location info, need to be optimized
    locmanager = [[CLLocationManager alloc] init];
    [locmanager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locmanager startUpdatingLocation];
    NSLog(@"current: %@",[locmanager location]);
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    userData* caller = [users objectAtIndex:(0)];
    userData* receiver = [users objectAtIndex:[indexPath row]];
    
    
    chatWinController *chatWin = [[chatWinController alloc] init:caller receiver:receiver];


    
    [self.tabBarController.tabBar setHidden:YES];
    //testNav* nav = [[testNav alloc] init];
    rowNum = [indexPath row];
    
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:chatWin animated:YES];
    //[self.navigationController pushViewController:chatWin animated:YES];
    //[self performSelectorOnMainThread:@selector(pushNewView) withObject:nil waitUntilDone:YES];
   
    [self setHidesBottomBarWhenPushed:NO];
    
    return;
}

-(void) pushNewView
{
    userData* caller = [users objectAtIndex:(0)];
    userData* receiver = [users objectAtIndex:2];
    chatWinController *chatWin = [[chatWinController alloc] init];
    [chatWin setCaller:caller];[chatWin setReceiver:receiver];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [users count];
}

#pragma mark –
#pragma mark Data Source Loading / Reloading Methods  
- (void)reloadTableViewDataSource{
    NSLog(@"==开始加载数据");
    userXMLFile.selectedGender = selectGender;
    [self getUsersFromXMLFile];
    [self.tableView reloadData];
   _reloading = YES;
    [self doneLoadingTableViewData];
}
- (void)doneLoadingTableViewData{
    NSLog(@"===加载完数据");
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}
#pragma mark –
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}
#pragma mark –
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    [self reloadTableViewDataSource];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    return _reloading;
}
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    return [NSDate date];
}

@end