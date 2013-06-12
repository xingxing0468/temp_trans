//
//  availableDateNearbyController.m
//  temp_trans
//
//  Created by 张 宇洋 on 13-2-8.
//  Copyright (c) 2013年 张 宇洋. All rights reserved.
//

#import "availableDateNearbyController.h"
#import "dateDetailController.h"
@implementation availableDateNearbyController
@synthesize caller;

-(UIImageView*) payIcon:(NSInteger) iconCode
{
    UIImage* canOrderIcon = [UIImage imageNamed:@"canOrder.png"];
    UIImage* canPrePayIcon = [UIImage imageNamed:@"canPrePay.png"];
    UIImage* canRefund = [UIImage imageNamed:@"canRefund.png"];
    UILabel* textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, PAY_ICON_HEIGHT, PAY_ICON_WIDTH)];
    [textLabel setFont:[UIFont systemFontOfSize:14]];
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setTextColor:[UIColor blackColor]];
    [textLabel setTextAlignment:UITextAlignmentLeft];
    UIImageView* retView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - EDGE_WIDTH-PAY_ICON_WIDTH, EDGE_HEIGHT+iconCode*PAY_ICON_HEIGHT, PAYICON_VIEW_WIDTH, PAY_ICON_HEIGHT)];
    NSString *text = @"";
    switch (iconCode) {
        case CAN_ORDER_PNG_CODE:
            [retView setImage:[canOrderIcon stretchableImageWithLeftCapWidth:0 topCapHeight:0]];
            text = @"预";
            break;
        case CAN_PREPAY_PNG_CODE:
            [retView setImage:[canPrePayIcon stretchableImageWithLeftCapWidth:0 topCapHeight:0]];
            text = @"支";
            break;
        case CAN_REFUND_PNG_CODE:
            [retView setImage:[canRefund stretchableImageWithLeftCapWidth:0 topCapHeight:0]];
            text = @"退";
            break;
    }
    [textLabel setText:text];
    [retView addSubview:textLabel];
    return retView;
}


-(UIView*) cellView:(NSInteger) nowDateIndex
{
    UIView* retView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, DATE_IMAGE_HEIGHT+2*EDGE_WIDTH)];
    [retView setBackgroundColor:[UIColor clearColor]];
    dateInfoData *nowDate = [dateInfo_List objectAtIndex:nowDateIndex];
    
    //img view set
    UIImage *dataImg = [UIImage imageNamed:[nowDate dateImgName]];
    UIImageView *dateImgView = [[UIImageView alloc] initWithImage:[dataImg stretchableImageWithLeftCapWidth:0 topCapHeight:0]];
    [dateImgView setFrame:CGRectMake(EDGE_WIDTH, EDGE_HEIGHT, DATE_IMAGE_WIDTH, DATE_IMAGE_HEIGHT)];
    [retView addSubview:dateImgView];
    
    //set date title label
    UIFont *dateTitleFont = [UIFont systemFontOfSize:DATE_TITLE_FONT_SIZE];

    UILabel *dateTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(DATE_IMAGE_WIDTH+2*EDGE_WIDTH, EDGE_HEIGHT, DATE_TITLE_LABEL_WIDTH,DATE_TITLE_LABEL_HEIGHT)];
    [dateTitleLabel setBackgroundColor:[UIColor clearColor]];
    //[dateTitleLabel setBackgroundColor:[UIColor yellowColor]];
    [dateTitleLabel setFont:dateTitleFont];
    [dateTitleLabel setText:[nowDate dateName]];
    [dateTitleLabel setLineBreakMode:UILineBreakModeCharacterWrap];
    [dateTitleLabel setNumberOfLines:0];
    [retView addSubview:dateTitleLabel];
    
    //set shop name title label
    UIFont *shopNameFont = [UIFont systemFontOfSize:SHOP_NAME_FONT_SIZE];

    UILabel *shopNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(DATE_IMAGE_WIDTH+2*EDGE_WIDTH, EDGE_HEIGHT+dateTitleLabel.bounds.size.height, SHOP_NAME_LABEL_WIDTH,SHOP_NAME_LABEL_HEIGHT)];
    [shopNameLabel setBackgroundColor:[UIColor clearColor]];
    [shopNameLabel setFont:shopNameFont];
    [shopNameLabel setLineBreakMode:UILineBreakModeCharacterWrap];
    [shopNameLabel setNumberOfLines:0];
    [shopNameLabel setTextColor:[UIColor grayColor]];
    //[shopNameLabel setBackgroundColor:[UIColor blueColor]];
    [shopNameLabel setText:[nowDate shop].shopName];
    [retView addSubview:shopNameLabel];
    
    //set price label
    UIView *priceView = [[UIView alloc] initWithFrame:CGRectMake(DATE_IMAGE_WIDTH+2*EDGE_WIDTH, EDGE_HEIGHT+dateTitleLabel.bounds.size.height + shopNameLabel.bounds.size.height, PRICE_LABEL_WIDTH, PRICE_LABEL_HEIGHT)];
    [priceView setBackgroundColor:[UIColor clearColor]];
    
    
    NSString *nowPriceStr = [NSString stringWithFormat:[NSString stringWithFormat:@"%.01f",[nowDate nowPrice]]];
    UIFont *nowPriceFont = [UIFont systemFontOfSize:NOW_PRICE_FONT_SIZE];
    UILabel *nowPriceLable = [[UILabel alloc] init];
    CGSize nowPriceSize = [nowPriceStr sizeWithFont:nowPriceFont];
    [nowPriceLable setFrame:CGRectMake(0, priceView.bounds.size.height-nowPriceSize.height, nowPriceSize.width, nowPriceSize.height)]; 
    [nowPriceLable setFont:nowPriceFont];
    [nowPriceLable setBackgroundColor:[UIColor clearColor]];
    [nowPriceLable setText:nowPriceStr];
    [nowPriceLable setTextColor:[UIColor purpleColor]];
    [priceView addSubview:nowPriceLable];
    
    UIFont *originPriceFont = [UIFont systemFontOfSize:ORIGIN_PRICE_FONT_SIZE];
    NSString* originPriceStr = [NSString stringWithFormat:@"元 %.1f元",[nowDate originPrice]];
    CGSize originPriceSize = [originPriceStr sizeWithFont:originPriceFont];
    UILabel *originPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(nowPriceLable.bounds.size.width, priceView.bounds.size.height - originPriceSize.height,originPriceSize.width,originPriceSize.height)];
    [originPriceLabel setFont:originPriceFont];
    [originPriceLabel setBackgroundColor:[UIColor clearColor]];
    [originPriceLabel setText:originPriceStr];
    [originPriceLabel setTextColor:[UIColor grayColor]];
    UIView* delLine = [[UIView alloc] initWithFrame:CGRectMake(15, originPriceLabel.bounds.size.height/2-1, originPriceLabel.bounds.size.width-20, 1)];
    [delLine setBackgroundColor:[UIColor grayColor]];
    [originPriceLabel addSubview:delLine];
    [priceView addSubview:originPriceLabel];
    
    [retView addSubview:priceView];
                    
    //add payment icon
    if(nowDate.canOrder) {[retView addSubview:[self payIcon:CAN_ORDER_PNG_CODE]];}
    if(nowDate.canPrePay){[retView addSubview:[self payIcon:CAN_PREPAY_PNG_CODE]];}
    if(nowDate.canRefund){[retView addSubview:[self payIcon:CAN_REFUND_PNG_CODE]];}
    
    
    //add distance label
    CLLocation *shopLoc = [[CLLocation alloc]initWithLatitude:[nowDate.shop latitude] longitude:[nowDate.shop longitude]];
    double distance = [[myLocManager location] distanceFromLocation: shopLoc]/1000;
    NSString *disStr = [NSString stringWithFormat:@"%.1fkm", distance];
    UIFont *disFont = [UIFont systemFontOfSize:DISTANCE_FONT_SIZE];
    CGSize disSize = [disStr sizeWithFont:disFont];
    UILabel *disLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - EDGE_WIDTH - disSize.width, retView.bounds.size.height-EDGE_HEIGHT-disSize.height, disSize.width, disSize.height)];
    [disLabel setBackgroundColor:[UIColor clearColor]];
    [disLabel setText:disStr];
    [disLabel setTextColor:[UIColor grayColor]];
    [disLabel setFont:disFont];
    [retView addSubview:disLabel];
    
    
    
    return retView;
}



-(id)init:(userData*) inCaller{
    if(self = [super init])
    {
        [self setCaller:inCaller];
        dateInfo_List = [[NSMutableArray alloc] init];
        myLocManager = [[CLLocationManager alloc] init];
        [myLocManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [myLocManager startUpdatingLocation];
        
        //initilize navigation bar
        [self.navigationItem setTitle:@"预定约会"];
        UIImage* searchBtnImg = [UIImage imageNamed:@"search.png"];
        UIButton *searchBtn = [UIButton buttonWithType:UIBarButtonItemStyleBordered];
        [self getAvailableDateNearby];
        //UIBarButtonItem *btn = [[UIBarButtonItem alloc] init];
        
        [searchBtn setFrame:CGRectMake([[UIScreen mainScreen] applicationFrame].size.width - BTN_WIDTH - 10, 10, BTN_WIDTH, BTN_HEIGHT)];
        UIImageView *searchIconView = [[UIImageView alloc] initWithImage:[searchBtnImg stretchableImageWithLeftCapWidth:0 topCapHeight:0]];
        [searchIconView setFrame:CGRectMake(BTN_WIDTH/3, (BTN_HEIGHT-BTN_WIDTH/3)/2, BTN_WIDTH/3, BTN_WIDTH/3)];
        [searchBtn addSubview:searchIconView];
        [searchBtn addTarget:self action:@selector(searchBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:searchBtn]];
        
        
        //initilize tableview
        availableDateTable = [[UITableView alloc] initWithFrame:CGRectMake(0, SELECT_BAR_HEIGHT, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
        [availableDateTable setDataSource:self];
        [availableDateTable setDelegate:self];
        
        
        [availableDateTable setBackgroundColor:[UIColor whiteColor]];
        //[self.view addSubview:availableDateTable];
        //initilize the dateInfo parser
        dateInfoParser = [[availableDateInfoParser_xml alloc] init];
        
        [self refreshTableData];

         
        
    }
    return self;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dateInfo_List count];
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return DATE_IMAGE_HEIGHT+2*EDGE_WIDTH;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    

    [cell.contentView addSubview:[self cellView:[indexPath row]]];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    dateInfoData *nowDate = [dateInfo_List objectAtIndex:[indexPath row]];
    dateDetailController *detailController = [[dateDetailController alloc] init:nowDate state:STATE_DONE];
    [self.navigationController pushViewController:detailController animated:YES];
}


-(void) refreshTableData{
    [self getAvailableDateNearby];
    [availableDateTable reloadData];
    
    //set UI changes based on the conditions
    //..

}

-(void) getAvailableDateNearby
{
    //set Conditions
    //....
    
    
    
    dateInfo_List = [dateInfoParser get_availableDates];
    

}
-(void) searchBtnClicked{

}

@end
