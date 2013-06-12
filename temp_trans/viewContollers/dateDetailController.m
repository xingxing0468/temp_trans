//
//  dateDetailController.m
//  temp_trans
//
//  Created by 张 宇洋 on 13-2-16.
//  Copyright (c) 2013年 张 宇洋. All rights reserved.
//

#import "dateDetailController.h"
#import <inttypes.h>

@implementation dateDetailController
@synthesize dateState;
@synthesize caller, receiver;
@synthesize nowDate;



#define STATE_NEED_LAUNCH              0
#define STATE_NEED_ACCEPT              1
#define STATE_NEED_PAY                 2
#define STATE_DONE                     3
#define STATE_REJECTED                 4

#pragma mark
#pragma mark - UI Design size
static uint8_t EDGE_WIDTH                   = 10;
static uint8_t EDGE_HEIGHT                  = 10;
static uint8_t NOW_PRICE_FONT_SIZE          = 18;
static uint8_t ORIGIN_PRICE_FONT_SIZE       = 14;

static uint8_t DATE_IMAGE_WIDTH             = 180;
static uint8_t DATE_IMAGE_HEIGHT            = 120;
static uint8_t DIAL_IMAGE_WIDTH             = 50;
static uint8_t DIAL_IMAGE_HEIGHT            = 50;

static uint8_t PRICE_VIEW_HEIGHT            = 30;
static uint8_t ACT_BTN_WIDTH                = 80;
static uint8_t ACT_BTN_HEIGHT               = 25;
static uint8_t PAY_LABEL_HEIGHT             = 20;
static uint8_t SCORE_VIEW_HEIGHT            = 20;
static uint8_t SCORE_TITLE_WIDTH            = 50;
static uint8_t SCORE_IMAGE_WIDTH            = 20;
static uint8_t SCORE_IMAGE_HEIGHT           = 20;
static uint8_t SCORE_DETAIL_WIDTH           = 120;

static uint16_t SHOP_IMAGE_WIDTH            = 300;
static uint16_t SHOP_IMAGE_HEIGHT           = 225;
static uint8_t  SHOP_LOC_ICON_WIDTH         = 12;
static uint8_t  SHOP_LOC_ICON_HEIGHT        = 12;



static uint8_t DATE_TITLE_FONT_SIZE         = 16;
static uint8_t DATE_DETAIL_FONT_SIZE        = 12;
static uint8_t PAY_DETAIL_FONT_SIZE         = 10;
static uint8_t SCORE_FONT_SIZE              = 12;

static uint8_t SHOP_TITLE_FONT_SIZE         = 16;
static uint8_t SHOP_ADD_FONT_SIZE           = 12;
static uint8_t SHOP_LOC_FONT_SIZE           = 10;
static uint8_t SHOP_DETAIL_FONT_SIZE        = 12;


UIView* dateView;
UIView* shopView;
NSString* navTitle = @"";
NSString* actBtnTxt = @"";
NSString* btnImgName = @"";
NSInteger dateViewHeight = 0;
-(id) init:(dateInfoData *)inDate state:(NSInteger)inState
{
    if(self = [super init])
    {
        [self setDateState:inState];
        [self setNowDate:inDate];
        myLocManager = [[CLLocationManager alloc] init];
        [myLocManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [myLocManager startUpdatingLocation];
        btnImgName = @"button-blue";
        
        
        
        
        switch (dateState) {
            case STATE_NEED_LAUNCH:
                navTitle = @"未发起";
                actBtnTxt = @"立即邀请";
                break;
            case STATE_NEED_ACCEPT:
                navTitle = @"已发起";
                actBtnTxt = @"接 受";
                break;
            case STATE_NEED_PAY:
                navTitle = @"等待付款";
                actBtnTxt = @"付 款";
                break;
            case STATE_DONE:
                navTitle = @"请准时参加";
                btnImgName = @"button-white";
                actBtnTxt = @"已完成";
                break;
            case STATE_REJECTED:
                navTitle = @"已取消";
                btnImgName = @"button-white";
                actBtnTxt = @"已拒绝";
                break;
        }
        //initialize navigation bar
        [self.navigationItem setTitle:navTitle];
        [self.tableView setAllowsSelection:NO];
        
        dateView = [self dateDetailView];
        shopView = [self shopDetailView];
        
        

    }
    return self;
}

#pragma mark
#pragma mark - view editor
-(UIView*) dateDetailView
{
    NSInteger startHeight = 0;
    UIView* retView = [[UIView alloc] initWithFrame:CGRectMake(EDGE_WIDTH, EDGE_HEIGHT, [UIScreen mainScreen].bounds.size.width-2*EDGE_WIDTH, 400)];
    [retView setBackgroundColor:[UIColor whiteColor]];
    //date image

    UIImage *dateImg = [UIImage imageNamed:[nowDate dateImgName]];
    UIImageView *dateImgView = [[UIImageView alloc] initWithImage:[dateImg stretchableImageWithLeftCapWidth:0 topCapHeight:0]];
    [dateImgView setFrame:CGRectMake(0, startHeight, DATE_IMAGE_WIDTH, DATE_IMAGE_HEIGHT)];
    startHeight += dateImgView.bounds.size.height;
    
    //price
    UIView *priceView = [[UIView alloc] initWithFrame:CGRectMake(DATE_IMAGE_WIDTH+EDGE_WIDTH/2, 0,retView.bounds.size.width - DATE_IMAGE_WIDTH-EDGE_WIDTH/2, PRICE_VIEW_HEIGHT)];
    [priceView setBackgroundColor:[UIColor clearColor]];
    
    
    NSString *nowPriceStr = [NSString stringWithFormat:@"%.1f",[nowDate nowPrice]];
    UIFont *nowPriceFont = [UIFont systemFontOfSize:NOW_PRICE_FONT_SIZE];
    UILabel *nowPriceLable = [[UILabel alloc] init];
    CGSize nowPriceSize = [nowPriceStr sizeWithFont:nowPriceFont];
    [nowPriceLable setFrame:CGRectMake(0, (priceView.bounds.size.height-nowPriceSize.height)/2, nowPriceSize.width, nowPriceSize.height)];
    [nowPriceLable setFont:nowPriceFont];
    [nowPriceLable setBackgroundColor:[UIColor clearColor]];
    [nowPriceLable setText:nowPriceStr];
    [nowPriceLable setTextColor:[UIColor purpleColor]];
    [priceView addSubview:nowPriceLable];
    
    UIFont *originPriceFont = [UIFont systemFontOfSize:ORIGIN_PRICE_FONT_SIZE];
    NSString* originPriceStr = [NSString stringWithFormat:@"元 %.1f元",[nowDate originPrice]];
    CGSize originPriceSize = [originPriceStr sizeWithFont:originPriceFont];
    UILabel *originPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(nowPriceLable.bounds.size.width, (priceView.bounds.size.height + nowPriceSize.height)/2 - originPriceSize.height,originPriceSize.width,originPriceSize.height)];
    [originPriceLabel setFont:originPriceFont];
    [originPriceLabel setBackgroundColor:[UIColor clearColor]];
    [originPriceLabel setText:originPriceStr];
    [originPriceLabel setTextColor:[UIColor grayColor]];
    UIView* delLine = [[UIView alloc] initWithFrame:CGRectMake(15, originPriceLabel.bounds.size.height/2-1, originPriceLabel.bounds.size.width-20, 1)];
    [delLine setBackgroundColor:[UIColor grayColor]];
    [originPriceLabel addSubview:delLine];
    [priceView addSubview:originPriceLabel];
    
    //add button
    UIView* btnView = [[UIView alloc] initWithFrame:CGRectMake(DATE_IMAGE_WIDTH+EDGE_WIDTH, priceView.bounds.size.height, [UIScreen mainScreen].bounds.size.width - DATE_IMAGE_WIDTH-EDGE_WIDTH*3, DATE_IMAGE_HEIGHT-priceView.bounds.size.height)];
    UIImage* btnImg = [UIImage imageNamed:btnImgName];
    
    UIImageView* actBtnImg = [[UIImageView alloc] initWithImage:[btnImg stretchableImageWithLeftCapWidth:0 topCapHeight:0]];
    [actBtnImg setFrame:CGRectMake(0, 0, ACT_BTN_WIDTH, ACT_BTN_HEIGHT)];
    
    UILabel *btnText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ACT_BTN_WIDTH, ACT_BTN_HEIGHT)];
    [btnText setFont:[UIFont systemFontOfSize:14]];
    [btnText setText:actBtnTxt];
    [btnText setTextAlignment:NSTextAlignmentCenter];
    [btnText setBackgroundColor:[UIColor clearColor]];
    
    [actBtnImg addSubview:btnText];
    
    [btnView setBackgroundColor:[UIColor clearColor]];
    UIButton *actBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [actBtn setFrame:CGRectMake((btnView.bounds.size.width - ACT_BTN_WIDTH)/2, (btnView.bounds.size.height - 2*ACT_BTN_HEIGHT)/3, ACT_BTN_WIDTH, ACT_BTN_HEIGHT)];
    [actBtn addSubview:actBtnImg];
    [btnView addSubview: actBtn];
    
    if(dateState !=STATE_REJECTED || dateState != STATE_DONE)
    {
        [actBtn addTarget:self action:@selector(actBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if(dateState == STATE_NEED_ACCEPT)
    {
        UIImageView* actBtnImg_2 = [[UIImageView alloc] initWithImage:[btnImg stretchableImageWithLeftCapWidth:0 topCapHeight:0]];
        [actBtnImg_2 setFrame:CGRectMake(0,0, ACT_BTN_WIDTH, ACT_BTN_HEIGHT)];
        
        UILabel *btnText_2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ACT_BTN_WIDTH, ACT_BTN_HEIGHT)];
        [btnText_2 setFont:[UIFont systemFontOfSize:14]];
        [btnText_2 setText:@"拒 绝"];
        [btnText_2 setTextAlignment:NSTextAlignmentCenter];
        [btnText_2 setBackgroundColor:[UIColor clearColor]];
        [actBtnImg_2 addSubview:btnText_2];
        
        UIButton *actBtn_2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [actBtn_2 setFrame:CGRectMake((btnView.bounds.size.width - ACT_BTN_WIDTH)/2, (btnView.bounds.size.height - 2*ACT_BTN_HEIGHT)/3*2+ACT_BTN_HEIGHT, ACT_BTN_WIDTH, ACT_BTN_HEIGHT)];
        [actBtn_2 addSubview:actBtnImg_2];
        [btnView addSubview: actBtn_2];
        [actBtn_2 addTarget:self action:@selector(actBtnReject) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview: actBtn_2];
    }
    
    
    
    
    [retView addSubview:dateImgView];
    [retView addSubview:priceView];
    startHeight += priceView.bounds.size.height;
    [retView addSubview:btnView];
    
    
    
    //add title
    UIFont *titleFont = [UIFont systemFontOfSize:DATE_TITLE_FONT_SIZE];
    CGSize titleSize = [nowDate.dateName sizeWithFont:titleFont constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - EDGE_WIDTH*2, 100) lineBreakMode:UILineBreakModeCharacterWrap];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, startHeight, titleSize.width, titleSize.height)];
    [titleLabel setLineBreakMode:UILineBreakModeCharacterWrap];
    [titleLabel setNumberOfLines:0];
    
    [titleLabel setText:nowDate.dateName];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFont:titleFont];
    
    
    [retView addSubview:titleLabel];
    startHeight += titleLabel.bounds.size.height;
    
    //add date detail info
    UIFont *dateDetailFont = [UIFont systemFontOfSize:DATE_DETAIL_FONT_SIZE];
    CGSize dateDetailSize = [nowDate.detailInfo sizeWithFont:dateDetailFont constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - EDGE_WIDTH*2, 300) lineBreakMode:UILineBreakModeCharacterWrap];
    UILabel *dateDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,startHeight+10,dateDetailSize.width,dateDetailSize.height)];
    [dateDetailLabel setFont:dateDetailFont];
    [dateDetailLabel setBackgroundColor:[UIColor clearColor]];
    [dateDetailLabel setLineBreakMode:UILineBreakModeCharacterWrap];
    [dateDetailLabel setNumberOfLines:0];
    [dateDetailLabel setText:nowDate.detailInfo];
    [dateDetailLabel setTextColor:[UIColor grayColor]];
    
    [retView addSubview:dateDetailLabel];
    startHeight += dateDetailLabel.bounds.size.height + 10;
    
    //add pay line
    NSString *canOrderStr = @"";
    NSString *canOrderImgName = @"";
    NSString *canPrePayStr = @"";
    NSString *canPrePayImgName = @"";
    NSString *canRefundStr = @"";
    NSString *canRefundImgName = @"";
    UIFont *payFont = [UIFont systemFontOfSize:PAY_DETAIL_FONT_SIZE];
    if([nowDate canOrder]) { canOrderStr = @"支持预定"; canOrderImgName = @"YES";}
    else                   { canOrderStr = @"不支持预定";canOrderImgName = @"NO";}
    if([nowDate canPrePay]){ canPrePayStr = @"支持预先付款"; canPrePayImgName = @"YES";}
    else                   { canPrePayStr = @"不支持预先付款"; canPrePayImgName = @"NO";}
    if([nowDate canRefund]){ canRefundStr = @"支持退款"; canRefundImgName = @"YES";}
    else                   { canRefundStr = @"不支持退款"; canRefundImgName = @"NO";}
    CGSize paySize = [canPrePayStr sizeWithFont:payFont];
   
    UIView *canOrderView = [[UIView alloc] initWithFrame:CGRectMake(0,startHeight,100,PAY_LABEL_HEIGHT)];
    //[canOrderView setBackgroundColor:[UIColor blueColor]];
    UIImage *canOrderImg = [UIImage imageNamed:canOrderImgName];
    UIImageView *canOrderImgView = [[UIImageView alloc] initWithImage:[canOrderImg stretchableImageWithLeftCapWidth:0 topCapHeight:0]];
    [canOrderImgView setFrame:CGRectMake(0, 0, PAY_LABEL_HEIGHT, PAY_LABEL_HEIGHT)];
    UILabel *canOrderLabel = [[UILabel alloc] initWithFrame:CGRectMake(PAY_LABEL_HEIGHT, 0, 100-PAY_LABEL_HEIGHT, PAY_LABEL_HEIGHT)];
    [canOrderLabel setText:canOrderStr];
    [canOrderLabel setFont:payFont];
    [canOrderLabel setBackgroundColor:[UIColor clearColor]];
    [canOrderView addSubview:canOrderImgView];[canOrderView addSubview:canOrderLabel];
    
    UIView *canPrePayView = [[UIView alloc] initWithFrame:CGRectMake(100, startHeight, 100, PAY_LABEL_HEIGHT)];
    //[canPrePayView setBackgroundColor:[UIColor blueColor]];
    UIImage *canPrePayImg = [UIImage imageNamed:canPrePayImgName];
    UIImageView *canPrePayImgView = [[UIImageView alloc] initWithImage:[canPrePayImg stretchableImageWithLeftCapWidth:0 topCapHeight:0]];
    [canPrePayImgView setFrame:CGRectMake(0, 0, PAY_LABEL_HEIGHT, PAY_LABEL_HEIGHT)];
    UILabel *canPrePayLabel = [[UILabel alloc] initWithFrame:CGRectMake(PAY_LABEL_HEIGHT, 0, 100-PAY_LABEL_HEIGHT, PAY_LABEL_HEIGHT)];
    [canPrePayLabel setText:canPrePayStr];
    [canPrePayLabel setFont:payFont];
    [canPrePayLabel setBackgroundColor:[UIColor clearColor]];
    [canPrePayView addSubview:canPrePayImgView];[canPrePayView addSubview:canPrePayLabel];
    
    UIView *canRefundView = [[UIView alloc] initWithFrame:CGRectMake(200, startHeight, 100, PAY_LABEL_HEIGHT)];
    //[canRefundView setBackgroundColor:[UIColor blueColor]];
    UIImage *canRefundImg = [UIImage imageNamed:canRefundImgName];
    UIImageView *canRefundImgView = [[UIImageView alloc] initWithImage:[canRefundImg stretchableImageWithLeftCapWidth:0 topCapHeight:0]];
    [canRefundImgView setFrame:CGRectMake(0, 0, PAY_LABEL_HEIGHT, PAY_LABEL_HEIGHT)];
    UILabel *canRefundLabel = [[UILabel alloc] initWithFrame:CGRectMake(PAY_LABEL_HEIGHT, 0, 100-PAY_LABEL_HEIGHT, PAY_LABEL_HEIGHT)];
    [canRefundLabel setText:canRefundStr];
    [canRefundLabel setFont:payFont];
    [canRefundLabel setBackgroundColor:[UIColor clearColor]];
    [canRefundView addSubview:canRefundImgView];[canRefundView addSubview:canRefundLabel];
    
    [retView addSubview:canPrePayView];[retView addSubview:canOrderView];[retView addSubview:canRefundView];
    startHeight += canPrePayView.bounds.size.height;
    
    //add score view
    
    //add score title
    UIView *scoreView = [[UIView alloc] initWithFrame:CGRectMake(0, startHeight, [UIScreen mainScreen].bounds.size.width, SCORE_VIEW_HEIGHT)];
    [scoreView setBackgroundColor:[UIColor clearColor]];
    UILabel *scoreTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, SCORE_VIEW_HEIGHT)];
    [scoreTitleLabel setBackgroundColor:[UIColor clearColor]];
    [scoreTitleLabel setFont:[UIFont systemFontOfSize:SCORE_FONT_SIZE]];
    [scoreTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [scoreTitleLabel setTextColor:[UIColor blackColor]];
    [scoreTitleLabel setText:@"评  分:"];
    [scoreView addSubview:scoreTitleLabel];
    
    UIImageView *scorImageView[5];
    UIImage *starImg_YES = [[UIImage imageNamed:@"star_YES"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    UIImage *starImg_NO  = [[UIImage imageNamed:@"star_NO"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    NSInteger nowDate_score = [nowDate score].averageScore + 0.5;
    
    //add score image
    for(int i=0; i<5; i++)
    {
        if(nowDate_score >= i+1){ scorImageView[i] = [[UIImageView alloc] initWithImage:starImg_YES];}
        else                    { scorImageView[i] = [[UIImageView alloc] initWithImage:starImg_NO];}
        [scorImageView[i] setFrame:CGRectMake(SCORE_IMAGE_WIDTH*i+scoreTitleLabel.bounds.size.width, 0, SCORE_IMAGE_WIDTH, SCORE_IMAGE_HEIGHT)];
        [scoreView addSubview:scorImageView[i]];
    }
    //add score detail
    UILabel* scoreDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(6*SCORE_IMAGE_HEIGHT+scoreTitleLabel.bounds.size.width, 0, SCORE_DETAIL_WIDTH, SCORE_VIEW_HEIGHT)];
    NSString *scoreDetailString = @"";
    if([nowDate.score scoreUserNum] == 0){scoreDetailString = @"暂时无人评分";}
    else
    {
        scoreDetailString = [NSString stringWithFormat:@"%.1f  %i人评分", [nowDate.score averageScore], [nowDate.score scoreUserNum]];
    }
    [scoreDetailLabel setText:scoreDetailString];
    [scoreDetailLabel setFont:[UIFont systemFontOfSize:SCORE_FONT_SIZE]];
    [scoreDetailLabel setTextColor:[UIColor blackColor]];
    [scoreDetailLabel setBackgroundColor:[UIColor clearColor]];
    [scoreView addSubview:scoreDetailLabel];
    
    
    
    [retView addSubview:scoreView];
    startHeight += SCORE_VIEW_HEIGHT;
    [retView setFrame:CGRectMake(EDGE_WIDTH, EDGE_HEIGHT, [UIScreen mainScreen].bounds.size.width-2*EDGE_WIDTH, startHeight+15)];
                                     
    return retView;
}

-(UIView*) shopDetailView
{
    UIView *retView = [[UIView alloc] initWithFrame:CGRectMake(EDGE_WIDTH, EDGE_HEIGHT, [UIScreen mainScreen].bounds.size.width - 2*EDGE_WIDTH, 400)];
    [retView setBackgroundColor:[UIColor clearColor]];
    NSInteger startHeight = 0;
    
    //add shop image view
    UIImage *shopImg = [[UIImage imageNamed:[nowDate.shop shopImgName]] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    UIImageView *shopImgView = [[UIImageView alloc] initWithImage:shopImg];
    [shopImgView setFrame:CGRectMake(0, startHeight, SHOP_IMAGE_WIDTH, SHOP_IMAGE_HEIGHT)];
    [retView addSubview:shopImgView];
    startHeight += SHOP_IMAGE_HEIGHT;
    
    //add title
    UIFont *titleFont = [UIFont systemFontOfSize:SHOP_TITLE_FONT_SIZE];
    CGSize titleSize = [nowDate.dateName sizeWithFont:titleFont constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - EDGE_WIDTH*2 - DIAL_IMAGE_WIDTH, 100) lineBreakMode:UILineBreakModeCharacterWrap];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, startHeight+10, titleSize.width, titleSize.height)];
    [titleLabel setLineBreakMode:UILineBreakModeCharacterWrap];
    [titleLabel setNumberOfLines:0];
    [titleLabel setText:[nowDate.shop shopName]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFont:titleFont];
    [retView addSubview:titleLabel];
    
    
    //add dial image view
    UIImage *dialImg = [[UIImage imageNamed:@"Phonealt.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    UIImageView *dialImgView = [[UIImageView alloc] initWithImage:dialImg];
    [dialImgView setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 2*EDGE_WIDTH - DIAL_IMAGE_WIDTH, startHeight+10, DIAL_IMAGE_WIDTH, DIAL_IMAGE_HEIGHT)];
//    [dialImgView setUserInteractionEnabled:YES];
//    UITapGestureRecognizer *dialTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dialShop)];
//    [dialImgView addGestureRecognizer:dialTap];
//    [retView addSubview:dialImgView];
    UIButton *dialBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dialBtn setImage:dialImg forState:UIControlStateNormal];
    [dialBtn setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 2*EDGE_WIDTH - DIAL_IMAGE_WIDTH, startHeight+10, DIAL_IMAGE_WIDTH, DIAL_IMAGE_HEIGHT)];
    [dialBtn addTarget:self action:@selector(dialShop) forControlEvents:UIControlEventTouchUpInside];
    [retView addSubview:dialBtn];
    
    startHeight += titleLabel.bounds.size.height + 10;
    
    //add shop address
    UIFont *addFont = [UIFont systemFontOfSize:SHOP_ADD_FONT_SIZE];
    CGSize addSize = [nowDate.shop.address sizeWithFont:addFont constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - EDGE_WIDTH*2 - DIAL_IMAGE_WIDTH, 300) lineBreakMode:UILineBreakModeCharacterWrap];
    UILabel *addLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,startHeight,addSize.width,addSize.height)];
    [addLabel setFont:addFont];
    [addLabel setBackgroundColor:[UIColor clearColor]];
    [addLabel setLineBreakMode:UILineBreakModeCharacterWrap];
    [addLabel setNumberOfLines:0];
    [addLabel setText:nowDate.shop.address];
    [addLabel setTextColor:[UIColor grayColor]];
    
    [retView addSubview:addLabel];
    startHeight += addLabel.bounds.size.height;
    
    //add location
    UIImage* locImg = [[UIImage imageNamed:@"location.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    UIImageView *locImgView = [[UIImageView alloc] initWithImage:locImg];
    [locImgView setFrame:CGRectMake(0, startHeight, SHOP_LOC_ICON_WIDTH, SHOP_LOC_ICON_HEIGHT)];
    [retView addSubview:locImgView];
    
    CLLocation *shopLoc = [[CLLocation alloc] initWithLatitude:[nowDate.shop latitude] longitude:[nowDate.shop longitude]];
    double distance = [[myLocManager location] distanceFromLocation:shopLoc]/1000;
    NSString *disStr = [NSString stringWithFormat:@"%.1fkm", distance];
    UIFont *disFont = [UIFont systemFontOfSize:SHOP_LOC_FONT_SIZE];
    CGSize disSize = [disStr sizeWithFont:disFont constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - EDGE_WIDTH*2 - DIAL_IMAGE_WIDTH - locImgView.bounds.size.width, 300) lineBreakMode:UILineBreakModeCharacterWrap];
    UILabel *disLabel = [[UILabel alloc] initWithFrame:CGRectMake(locImgView.bounds.size.width, startHeight, disSize.width, disSize.height)];
    [disLabel setFont:disFont];
    [disLabel setBackgroundColor:[UIColor clearColor]];
    [disLabel setText:disStr];
    [disLabel setTextColor:[UIColor grayColor]];
    [retView addSubview:disLabel];
    startHeight += SHOP_LOC_ICON_HEIGHT;
    
    //add shop detail
    UIFont *shopDetailFont = [UIFont systemFontOfSize:SHOP_DETAIL_FONT_SIZE];
    CGSize shopDetailSize = [nowDate.shop.shopDetailInfo sizeWithFont:shopDetailFont constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - EDGE_WIDTH*2, 300) lineBreakMode:UILineBreakModeCharacterWrap];
    UILabel *shopDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,startHeight+10,shopDetailSize.width,shopDetailSize.height)];
    [shopDetailLabel setFont:shopDetailFont];
    [shopDetailLabel setBackgroundColor:[UIColor clearColor]];
    [shopDetailLabel setLineBreakMode:UILineBreakModeCharacterWrap];
    [shopDetailLabel setNumberOfLines:0];
    [shopDetailLabel setText:nowDate.shop.shopDetailInfo];
    [shopDetailLabel setTextColor:[UIColor grayColor]];
    
    [retView addSubview:shopDetailLabel];
    startHeight += shopDetailLabel.bounds.size.height;
    [retView setFrame:CGRectMake(EDGE_WIDTH, EDGE_HEIGHT, [UIScreen mainScreen].bounds.size.width-2*EDGE_WIDTH, startHeight+30)];
    
    
    
    

    return retView;
}

#pragma mark
#pragma mark - Actions
-(void) dialShop
{
    UIActionSheet *dialSheet = [[UIActionSheet alloc] initWithTitle:@"拨打商户电话" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: [nowDate.shop telNum_1], [nowDate.shop telNum_2],nil];
    
    [dialSheet setActionSheetStyle:UIActionSheetStyleAutomatic];
    [dialSheet showInView:[UIApplication sharedApplication].keyWindow];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *telNum = @"";
    switch (buttonIndex) {
        case 0:
            telNum = [nowDate.shop telNum_1];
            break;
        case 1:
            telNum = [nowDate.shop telNum_2];
            break;
    }
    NSString *telURL = [[NSString alloc] initWithFormat:@"tel://%@",telNum];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telURL]];
    
}



-(void) actBtnReject
{
    NSLog(@"rejecting");
    return;
}

-(void) actBtnAction
{
    switch (dateState) {
        case STATE_NEED_LAUNCH:
            NSLog(@"launching");
            break;
        case STATE_NEED_ACCEPT:
            NSLog(@"accepting");
            break;
        case STATE_NEED_PAY:
            NSLog(@"paying");
            break;
    }
    return;
}

#pragma mark
#pragma mark -tableView callback functions
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"约会详情";
            break;
        case 1:
            return @"商户信息";
            break;
    }
    return @"";
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* retCell = [[UITableViewCell alloc] init];
    if([indexPath section] == 0)
    {
        [retCell.contentView addSubview:dateView];
    }
    if([indexPath section] == 1)
    {
        [retCell.contentView addSubview:shopView];
    }
    return retCell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath section]) {
        case 0:
            return dateView.bounds.size.height;
        case 1:
            return shopView.bounds.size.height;
    }
    return 0;
}

@end
