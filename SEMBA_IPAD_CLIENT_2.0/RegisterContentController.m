//
//  RegisterContentController.m
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by 欧 展飞 on 13-11-2.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "RegisterContentController.h"
#import "RegisterHistoryController.h"

#define kIsDayForClass 1
#define kLatitudeUp 23.070
#define kLatitudeLow 23.068
#define kLongitudeUp 113.386
#define kLongitudeLow 113.384
#define kRegistered [NSString stringWithFormat:@"registered"]
#define kSuccess 0
#define kFailOverTime 1
#define kFailNotTime 5
#define kFailWifi 2
#define kFailPlace 3
#define kFailDate 4

@interface RegisterContentController ()

@end

@implementation RegisterContentController
{
    Dao *dao;
    NSThread *request;
}
@synthesize historyBtn;
@synthesize locateManager;
@synthesize activity;
@synthesize hintText;
@synthesize registerBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if(self){
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect registerFrame = CGRectMake(50, 200, 100, 50);
    registerBtn = [[UIButton alloc] initWithFrame:registerFrame];
    [registerBtn setTitle:@"签到" forState:UIControlStateNormal];
    [registerBtn setBackgroundImage:[UIImage imageNamed:@"setting_button"] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    
    historyBtn = [[UIButton alloc] initWithFrame:CGRectMake(registerFrame.origin.x + registerFrame.size.width + 10,
                                                            registerFrame.origin.y,
                                                            150,
                                                            registerFrame.size.height)];
    [historyBtn setBackgroundImage:[UIImage imageNamed:@"setting_button"] forState:UIControlStateNormal];
    [historyBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [historyBtn setTitle:@"查看签到历史" forState:UIControlStateNormal];
    [historyBtn addTarget:self action:@selector(checkHistoryBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:historyBtn];
    
    activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(120, 200, 50, 50)];
    activity.backgroundColor = [UIColor clearColor];
    [self.view addSubview:activity];
    
    //[self.navigationItem setTitle:@"签到"];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(100,0, 50, 50)];
    [title setBackgroundColor:[UIColor redColor]];
    [title setText:@"签到"];
    [title setTextColor:[UIColor blackColor]];
    [self.navigationItem setTitleView:title];
    
    hintText = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, 200, 50)];
    hintText.text = @"正在签到，请稍后";
    hintText.backgroundColor = [UIColor purpleColor];
    hintText.textColor = [UIColor blackColor];
    hintText.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:hintText];
    
    //[self startRegister];
}

- (IBAction)checkHistoryBtnPressed:(id)sender
{
    RegisterHistoryController *controller = [[RegisterHistoryController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)registerBtnPressed:(id)sender
{
    NSThread *registerThread = [[NSThread alloc] initWithTarget:self selector:@selector(startRegisterThread:) object:nil];
    
    [registerThread start];
}

- (void)startRegisterThread:(NSThread *)thread
{
    
    NSNumber *value;
    
    int state = [dao requestForCheckIn:@"69"];
    
    if (![self checkInternet]) {
        
        value = [NSNumber numberWithInt:kFailWifi];
        
    }else if(![self checkDate]){
        
        value = [NSNumber numberWithInt:kFailDate];
        
    }else if(![self checkPlace]){
        
        value = [NSNumber numberWithInt:kFailPlace];
        
    }else if(![self checkOverTime]){
        
        value = [NSNumber numberWithInt:kFailOverTime];
        
    }else if(![self checkNotTime]){
        
        value = [NSNumber numberWithInt:kFailNotTime];
    }else {
        
        value = [NSNumber numberWithInt:kSuccess];
    }
    
    [self performSelectorOnMainThread:@selector(pushResutlController:) withObject:value waitUntilDone:YES];
}

- (void)pushResutlController:(NSNumber *)returnValue
{
    RegisterResultController *resultController = [[RegisterResultController alloc] init];
    
    int value = returnValue.intValue;
    
    [resultController startRegister:value];
    
    [self.navigationController pushViewController:resultController animated:YES];
    
}


#pragma Mark - start checking location
- (void)startRegister
{
    self.locateManager = [[CLLocationManager alloc] init];
    self.locateManager.delegate = self;
    self.locateManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locateManager.distanceFilter = 1.0f;
    [self.locateManager startUpdatingLocation];
    [self.activity startAnimating];
    
    CLLocation *current = [[CLLocation alloc] initWithLatitude:self.locateManager.location.coordinate.latitude
                                                     longitude:self.locateManager.location.coordinate.longitude];
    
    
    NSDate *now = [NSDate date];
    
    //Dao *dao = [Dao sharedDao];
    //int state = [dao requestForCheckIn:@"69"];
    //Firstly check for day, Secondly check for place
    int state = 1;
    if(state == kIsDayForClass) {
        
        if(current.coordinate.latitude <= kLatitudeUp && current.coordinate.latitude >= kLatitudeLow
           && current.coordinate.longitude <= kLongitudeUp && current.coordinate.longitude > kLongitudeLow)
        {
            [self.historyBtn setTitle:@"查看签到历史" forState:UIControlStateNormal];
            [self.hintText setText:@"签到完成啦"];
            
            //TimeStamp
            long timeSp = (long)[now timeIntervalSince1970];
            timeSp = timeSp - timeSp % 86400;
            
            NSDate *d = [NSDate dateWithTimeIntervalSince1970:timeSp];
            NSLog(@"ddd%@", d);
            
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:d forKey:kRegistered];
            
        }
        else {
            [self.historyBtn setTitle:@"查看签到历史" forState:UIControlStateNormal];
            [self.hintText setText:@"不好意思，你还没到上课地点"];
        }
    }else {
        [self.hintText setText:@"今天不用上课"];
        [self.historyBtn setTitle:@"查看签到历史" forState:UIControlStateNormal];
    }
    
}

- (BOOL)checkPlace
{
    CLLocation *current = [self getCurrentLocation];
    
    if(current.coordinate.latitude <= kLatitudeUp && current.coordinate.latitude >= kLatitudeLow
       && current.coordinate.longitude <= kLongitudeUp && current.coordinate.longitude > kLongitudeLow)
        return YES;
    
    return NO;
}

- (BOOL)checkInternet
{
    Reachability *r = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            return NO;
            
        default:
            break;
    }
    return YES;
}

- (BOOL)checkOverTime
{
    return NO;
}

- (BOOL)checkNotTime
{
    return NO;
}

- (BOOL)checkDate
{
    return NO;
}

#pragma Mark-LocationManager

- (CLLocation *)getCurrentLocation
{
    self.locateManager = [[CLLocationManager alloc] init];
    self.locateManager.delegate = self;
    self.locateManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locateManager.distanceFilter = 1.0f;
    [self.locateManager startUpdatingLocation];
    
    CLLocation *current = [[CLLocation alloc] initWithLatitude:self.locateManager.location.coordinate.latitude
                                                     longitude:self.locateManager.location.coordinate.longitude];
    
    return current;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{

    [self.locateManager stopUpdatingLocation];
    [UIView animateWithDuration:10.0 animations:^{
        [self.activity setAlpha:0.1];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    // Return YES for supported orientations
    
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    
}




@end
