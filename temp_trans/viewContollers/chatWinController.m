//
//  chatWinController.m
//  temp_trans
//
//  Created by 张 宇洋 on 13-2-2.
//  Copyright (c) 2013年 张 宇洋. All rights reserved.
//

#import "chatWinController.h"
#import "peopleNearby.h"
#define TEXTFIELDTAG	100
#define TOOLBARTAG		200
#define COVERVIEWTAG    300
#define TABLEVIEWTAG	400
#define LOADINGVIEWTAG	500

#define PIXELSOFWIDTHEDGE 8
#define PIXELSOFHEIGHTEDGE 8

#define HEADIMGLENGTH    30

@implementation chatWinController
@synthesize caller;
@synthesize receiver;

float tableHeight = 0;
CGPoint point;
//chat tableview
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
        
		cell.backgroundColor = [UIColor colorWithRed:0.859f green:0.886f blue:0.929f alpha:1.0f];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.contentView addSubview:[chatViewArray objectAtIndex:[indexPath row]]];
    return cell;

}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [chatViewArray count];
}




-(UIView*) bubbleView:(NSString*)text from:(BOOL)fromself{
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
    [returnView setBackgroundColor:[UIColor clearColor]];
    UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fromself?@"bubbleSelf":@"bubble" ofType:@"png"]];
    
    
    UIImageView *bubbleImgView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
    
    //set headimage
    UIImage *headImg = [UIImage alloc];
    if(fromself) { headImg = [UIImage imageNamed:caller.head_img];}
    else         { headImg = [UIImage imageNamed:receiver.head_img];}
    UIView *headImgView = [[UIImageView alloc] initWithImage:[headImg stretchableImageWithLeftCapWidth:8 topCapHeight:10]];

    
    //set font
    UIFont *font = [UIFont systemFontOfSize:15];
	CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(150, 300) lineBreakMode:UILineBreakModeCharacterWrap];
    
    UILabel *bubbleText = [[UILabel alloc] init];
    
    bubbleText.backgroundColor = [UIColor clearColor];
	bubbleText.font = font;
	bubbleText.numberOfLines = 0;
	bubbleText.lineBreakMode = UILineBreakModeCharacterWrap;
	bubbleText.text = text;
	
	
	if(fromself)
    {
        [bubbleImgView setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 5*PIXELSOFWIDTHEDGE-HEADIMGLENGTH-size.width, 0, 3*PIXELSOFWIDTHEDGE+size.width, size.height+2*PIXELSOFHEIGHTEDGE)];
        [bubbleText setFrame:CGRectMake(PIXELSOFWIDTHEDGE, PIXELSOFHEIGHTEDGE, size.width, size.height)];
    }
	else
    {
        [bubbleImgView setFrame:CGRectMake(PIXELSOFWIDTHEDGE*2+HEADIMGLENGTH, 0, PIXELSOFWIDTHEDGE*4+size.width, PIXELSOFHEIGHTEDGE*2+size.height)];
        [bubbleText setFrame:CGRectMake(PIXELSOFWIDTHEDGE*3, PIXELSOFHEIGHTEDGE, size.width, size.height)];
    }
    [bubbleImgView addSubview:bubbleText];
    [headImgView setFrame:CGRectMake(PIXELSOFWIDTHEDGE+(fromself)*([UIScreen mainScreen].bounds.size.width-2*PIXELSOFWIDTHEDGE-HEADIMGLENGTH), bubbleImgView.frame.size.height-HEADIMGLENGTH, HEADIMGLENGTH, HEADIMGLENGTH)];
    returnView.frame = CGRectMake(0.0f, PIXELSOFHEIGHTEDGE, [UIScreen mainScreen].bounds.size.width, bubbleImgView.frame.size.height+PIXELSOFHEIGHTEDGE);
	[returnView addSubview:bubbleImgView];
	
	[returnView addSubview:headImgView];

    
	return returnView;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	// return NO to disallow editing.
	
    UIToolbar *toolbar = (UIToolbar *)[self.view viewWithTag:TOOLBARTAG];
	toolbar.frame = CGRectMake(0.0f, 156.0f, 320.0f, 44.0f);
	UITableView *tableView = (UITableView *)[self.view viewWithTag:TABLEVIEWTAG];
	tableView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 156.0f);
	if([chatViewArray count])
		[tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatViewArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	
	
    //[UIView beginAnimations:@"show chatBox" context:nil];
    //[UIView setAnimationDuration:0.3f];

//    //tableView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
//	[UIView commitAnimations];

	
	return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
	
	UIToolbar *toolbar = (UIToolbar *)[self.view viewWithTag:TOOLBARTAG];
	toolbar.frame = CGRectMake(0.0f, 372.0f, 320.0f, 44.0f);
	UITableView *tableView = (UITableView *)[self.view viewWithTag:TABLEVIEWTAG];
	tableView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 372.0f);
	
    
    	if([chatViewArray count])
		[tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatViewArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	// called when 'return' key pressed. return NO to ignore.
	
	
	UIView *chatView = [self bubbleView:textField.text from:isMySpeaking];
	[chatViewArray addObject:chatView];
   // tableHeight += chatView.frame.size.height;

	isMySpeaking = !isMySpeaking;
    
    //[self.view addSubview:chatView];
	UITableView *tableView = (UITableView *)[self.view viewWithTag:TABLEVIEWTAG];

	
    [tableView reloadData];
    
	[tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[chatViewArray count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
	textField.text = @"";
	return YES;
}


- (BOOL) hideKeyboard {
	UITextField *textField = (UITextField *)[self.view viewWithTag:TEXTFIELDTAG];
    
	if(textField.editing) {
		textField.text = @"";
		[self.view endEditing:YES];
		
		return YES;
	}
	
	return NO;
}

- (void) clickOutOfTextField:(id)sender {
	[self hideKeyboard];
//    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
//    [UIView setAnimationDuration:0.3f];
//    chatTableView.center = point;
    //tableView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
	//[UIView commitAnimations];
    
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideKeyboard];
    
}

- (void) rightButtonAction {
	//[self.navigationController popViewControllerAnimated:YES];
    availableDateNearbyController *dateViewController = [[availableDateNearbyController alloc]init:caller];
    [self.navigationController pushViewController:dateViewController animated:YES];
}
//-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [self.view endEditing:YES];
//    
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	UIView *chatView = [chatViewArray objectAtIndex:[indexPath row]];
	return chatView.frame.size.height+10.0f;
}

- (id)init:(userData*) inCaller receiver:(userData *)inReceiver{
    //isMySpeaking = NO;
	if(self = [super init]) {
        [self setCaller:inCaller];[self setReceiver:inReceiver];
        self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
		[self.view setBackgroundColor:[UIColor colorWithRed:219.0f/255.0f green:226.0f/255.0f blue:237.0f/255.0f alpha:1]];
		[self.navigationItem setTitle:receiver.name];
        
		chatViewArray = [[NSMutableArray alloc] initWithCapacity:0];
		isMySpeaking = YES;
		loadingLog = NO;
		

        
		currentString = [[NSMutableString alloc] initWithCapacity:0];
		currentChatInfo = [[NSMutableDictionary alloc] initWithCapacity:3];
        
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发起约会" style:UIBarButtonItemStyleBordered target:self action:@selector(rightButtonAction)];
        
//		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(leftButtonAction)];
//		CGSize winSize = [UIScreen mainScreen].bounds.size;
		chatViewArray = [[NSMutableArray alloc] initWithCapacity:0];
		UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 31.0f)];
		textfield.tag = TEXTFIELDTAG;
		textfield.delegate = self;
		textfield.autocorrectionType = UITextAutocorrectionTypeNo;
		textfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
		textfield.enablesReturnKeyAutomatically = YES;
		textfield.borderStyle = UITextBorderStyleRoundedRect;
		textfield.returnKeyType = UIReturnKeySend;
		textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
		UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 372.0f, 320.0f, 44.0f)];
		toolBar.tag = TOOLBARTAG;
		NSMutableArray* allitems = [[NSMutableArray alloc] init];
		[allitems addObject:[[UIBarButtonItem alloc] initWithCustomView:textfield]];
		[toolBar setItems:allitems];

		[self.view addSubview:toolBar];

		//tableview?
		UITableView *chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f,372.0f) style:UITableViewStylePlain];
		chatTableView.delegate = self;
		chatTableView.dataSource = self;
		chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //chatTableView.backgroundColor=[UIColor blackColor];
		chatTableView.backgroundColor = [UIColor colorWithRed:0.859f green:0.886f blue:0.929f alpha:1.0f];
		chatTableView.tag = TABLEVIEWTAG;
		[self.view addSubview:chatTableView];
		
        
        //set cover view for touch hide keyboard
        UIView *coverView = [[UIView alloc] initWithFrame:chatTableView.frame];
        coverView.backgroundColor = [UIColor clearColor];
        coverView.tag = COVERVIEWTAG;
        [self.view addSubview:coverView];
 
		
		UIView *loadingView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 372.0f)];
		loadingView.backgroundColor = [UIColor darkGrayColor];
		UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		activityView.center = CGPointMake(loadingView.frame.size.width/2, loadingView.frame.size.height/2);
		[activityView startAnimating];
		[loadingView addSubview:activityView];
		
		loadingView.hidden = YES;
		loadingView.tag = LOADINGVIEWTAG;
		[self.view addSubview:loadingView];
		
	}
	
	return self;
}
@end
