//
//  TestViewController.m
//  CarManagement
//
//  Created by YongFeng.li on 12-6-15.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)dealloc
{
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
    
    UILabel *starttimelabel = [[[UILabel alloc] initWithFrame:CGRectMake(10,10,10,10)] autorelease];
    float distance = 20.0f;
    UILabel *EventAddresslabel=[[UILabel alloc]initWithFrame:CGRectMake(starttimelabel.frame.origin.x,starttimelabel.frame.origin.y+distance, 270, 20)];
    EventAddresslabel.backgroundColor=[UIColor redColor];
    EventAddresslabel.textColor=[UIColor whiteColor];
    EventAddresslabel.font=[UIFont systemFontOfSize:15];
    EventAddresslabel.numberOfLines =0; //this is used to determine how many lines this label will have.if =3,it means this label's text will show 3 lines.if =0 ,it means that this label's text will show the line whate it needs.no limit.
    EventAddresslabel.lineBreakMode = UILineBreakModeWordWrap;// sys will change the line by word.aslo can be by character for another value.
    EventAddresslabel.text=@"hello,lyfing,welcome this is used to determine how many lines this label will have.if =3,it means this label's text will show 3 lines.if =0 ,it means that this label's text will show the line whate it needs.no limit this is used to determine how many lines this label will have.if =3,it means this label's text will show 3 lines.if =0 ,it means that this label's text will show the line whate it needs.no limit.";
    [self.view  addSubview:EventAddresslabel];
    CGSize EventAddresslabelsize = [EventAddresslabel.text sizeWithFont:[UIFont systemFontOfSize:15]
                                                      constrainedToSize:CGSizeMake(300, [EventAddresslabel.text length]) lineBreakMode:UILineBreakModeWordWrap];
    [EventAddresslabel setFrame:CGRectMake(EventAddresslabel.frame.origin.x, EventAddresslabel.frame.origin.y,
                                           300,EventAddresslabelsize.height+10)];
    
//    UILabel *Description=[[UILabel alloc]initWithFrame:CGRectMake(5, EventAddresslabel.frame.origin.y+EventAddresslabel.frame.size.height, 320, 60)];
//    UIActivityIndicatorView *DescriptionactivityView = [[UIActivityIndicatorView alloc]
//                               initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    DescriptionactivityView.frame = CGRectMake(140.f, EventAddresslabel.frame.origin.y+30, 30.0f, 30.0f);
////    UILabel *Londinglabel_1=[[UILabel alloc]initWithFrame:CGRectMake(132, Description.frame.origin.y+30, 80, 20)];
////    int Labelflag=0;
//    Description.backgroundColor=[UIColor clearColor];
//    Description.textColor=[UIColor whiteColor];
//    Description.font=[UIFont systemFontOfSize:15];
//    Description.numberOfLines =0; 
//    Description.lineBreakMode = UILineBreakModeWordWrap;
//    [self.view addSubview:Description];
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
