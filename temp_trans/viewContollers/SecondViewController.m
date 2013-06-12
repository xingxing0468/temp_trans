//
//  FirstViewController.m
//  temp_trans
//
//  Created by 张 宇洋 on 13-1-25.
//  Copyright (c) 2013年 张 宇洋. All rights reserved.
//

#import "SecondViewController.h"


#import <CoreLocation/CoreLocation.h>



@interface SecondViewController();

@end

@implementation SecondViewController

@synthesize list=_list;
@synthesize localUser;
NSMutableArray *users;
CLLocationManager *locmanager;

NSInteger rowNum;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    
    
    
    
    
    userDataParser_xml *userXMLFile = [userDataParser_xml alloc];
    
    users = [userXMLFile get_userData:@"user_data"];
    localUser = [users objectAtIndex:0];
    
    
    //get location info, need to be optimized
    locmanager = [[CLLocationManager alloc] init];
    [locmanager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locmanager startUpdatingLocation];
    NSLog(@"current: %@",[locmanager location]);
    
    
    
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
    [cell.imageView setImage:head_image];
    
    [nowUserLoc initWithLatitude:nowUser.latitude longitude:nowUser.longitude];
    int distance = [[locmanager location] distanceFromLocation:nowUserLoc];
    
    NSString *distanceStr = [[NSString alloc] initWithFormat:@"距离：%i", distance];
    
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    rowNum = [indexPath row];
    UINavigationController *navController = [[UINavigationController alloc] init];
    
    chatWinController *chatWin = [[chatWinController alloc] init];
    //[self.tabBarController.view setHidden:YES];
    //testNav* nav = [[testNav alloc] init];
    rowNum = [indexPath row];
    UIWindow* window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [navController.view setHidden:NO];
    [navController pushViewController:chatWin animated:YES];
    //[window setBackgroundColor:[UIColor blueColor]];
    
    
    return;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [users count];
}


@end
