//
//  SetupViewController.m
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by yaodd on 13-11-21.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "SetupViewController.h"
#import "ChangePswViewController.h"
#import "FeedbackViewController.h"
#import "LoginViewController.h"
#import "DownloadModel.h"
#import "AboutUsViewController.h"

#define START_X     8.0f
#define START_Y     16.0f
#define ITEM_WIDHT  387.0f
#define ITEM_HEIGHT 55.0f
#define ITEM_SPACE  16.0f
#define LABEL_X     15.0f
#define LABEL_Y     18.0f
#define TEXT_SIZE  18.0f
#define LABEL_WIDTH 100.0f
#define LABEL_HRIGHT 20.0f
#define SWITCH_X    321.0f
#define SWITCH_Y    12.0f
#define SWITCH_WIDTH    51.0f
#define SWITCH_HEIGHT   31.0f
#define ARROW_X         360.0f
#define ARROW_Y         18.0f
#define ARROW_WIDTH     12.0f
#define ARROW_HEIGHT    21.0f




NSString *itemImageName = @"setting_item_bg";
NSString *arrowImageName = @"setting_right_arrow";

//NSString *isAutoDownloadKey = @"isAutoDownLoad";
//NSString *isPushKey = @"isPush";
//NSString *isAutoLoginKey = @"isAutoLogin";
@interface SetupViewController ()

@end

@implementation SetupViewController
@synthesize isAutoDownLoad;
@synthesize isPushvar;
@synthesize isAutoLogin;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initViews];
    NSLog(@"分割线---------------------------------");
    // Do any additional setup after loading the view.
}
- (void)initViews{
    CGFloat top_y = START_Y;
    
    UIFont *textFont = [UIFont systemFontOfSize:TEXT_SIZE];
    UIColor *textColor = [UIColor colorWithRed:105.0 / 255 green:105.0 / 255 blue:105.0 / 255 alpha:1.0];
    CGRect lableRect = CGRectMake(LABEL_X, LABEL_Y, LABEL_WIDTH, LABEL_HRIGHT);
    CGRect switchRect = CGRectMake(SWITCH_X, SWITCH_Y, SWITCH_WIDTH, SWITCH_HEIGHT);
    
    UIView *downloadItem = [[UIView alloc]initWithFrame:CGRectMake(START_X, top_y, ITEM_WIDHT, ITEM_HEIGHT)];
    [downloadItem setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:itemImageName]]];
    UILabel *downloadLabel = [[UILabel alloc]initWithFrame:lableRect];
    [downloadLabel setBackgroundColor:[UIColor clearColor]];
    [downloadLabel setText:@"自动下载"];
    [downloadLabel setTextColor:textColor];
    [downloadLabel setTextAlignment:NSTextAlignmentLeft];
    [downloadLabel setFont:textFont];
    [downloadItem addSubview:downloadLabel];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    UISwitch *downloadSwitch = [[UISwitch alloc]initWithFrame:switchRect];
    downloadSwitch.on = NO;
    [downloadSwitch addTarget:self action:@selector(changeAutoDownLoad:) forControlEvents:UIControlEventValueChanged];
    [downloadItem addSubview:downloadSwitch];
    downloadSwitch.on = [(NSNumber *)[userDefault objectForKey:isAutoDownloadKey] boolValue];
//    isAutoDownLoad = downloadSwitch.on;
    [self.view addSubview:downloadItem];
    
    top_y += ITEM_HEIGHT;
    UIView *pushItem = [[UIView alloc]initWithFrame:CGRectMake(START_X, top_y, ITEM_WIDHT, ITEM_HEIGHT)];
    [pushItem setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:itemImageName]]];
    UILabel *pushLabel = [[UILabel alloc]initWithFrame:lableRect];
    [pushLabel setBackgroundColor:[UIColor clearColor]];
    [pushLabel setText:@"推送开关"];
    [pushLabel setTextColor:textColor];
    [pushLabel setTextAlignment:NSTextAlignmentLeft];
    [pushLabel setFont:textFont];
    UISwitch *pushSwitch = [[UISwitch alloc]initWithFrame:switchRect];
    pushSwitch.on = NO;
    [pushSwitch addTarget:self action:@selector(changePush:) forControlEvents:UIControlEventValueChanged];
    pushSwitch.on = [(NSNumber *)[userDefault objectForKey:isPushKey] boolValue];
//    isPushvar = pushSwitch.on;
    [pushItem addSubview:pushSwitch];
    [pushItem addSubview:pushLabel];
    
    
    [self.view addSubview:pushItem];
    
    top_y += ITEM_HEIGHT;
    UIView *autoLoginItem = [[UIView alloc]initWithFrame:CGRectMake(START_X, top_y, ITEM_WIDHT, ITEM_HEIGHT)];
    [autoLoginItem setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:itemImageName]]];
    UILabel *autoLoginLabel = [[UILabel alloc]initWithFrame:lableRect];
    [autoLoginLabel setBackgroundColor:[UIColor clearColor]];
    [autoLoginLabel setText:@"自动登录"];
    [autoLoginLabel setTextColor:textColor];
    [autoLoginLabel setTextAlignment:NSTextAlignmentLeft];
    [autoLoginLabel setFont:textFont];
    [autoLoginItem addSubview:autoLoginLabel];
    UISwitch *autoLoginSwitch = [[UISwitch alloc]initWithFrame:switchRect];
    autoLoginSwitch.on = NO;
    [autoLoginSwitch addTarget: self action:@selector(changeAotoLogin:) forControlEvents:UIControlEventValueChanged];
    autoLoginSwitch.on = [(NSNumber *)[userDefault objectForKey:isAutoLoginKey] boolValue];
//    isAutoLogin = autoLoginSwitch.on;
    [autoLoginItem addSubview:autoLoginSwitch];
    [self.view addSubview:autoLoginItem];
    
    top_y += (ITEM_HEIGHT + ITEM_SPACE);
    UIButton *changePswItem = [[UIButton alloc]initWithFrame:CGRectMake(START_X, top_y, ITEM_WIDHT, ITEM_HEIGHT)];
    [changePswItem addTarget:self action:@selector(changePswAction:) forControlEvents:UIControlEventTouchUpInside];
    [changePswItem setBackgroundImage:[UIImage imageNamed:itemImageName] forState:UIControlStateNormal];
    UILabel *changePswLabel = [[UILabel alloc]initWithFrame:lableRect];
    [changePswLabel setBackgroundColor:[UIColor clearColor]];
    [changePswLabel setText:@"修改密码"];
    [changePswLabel setTextColor:textColor];
    [changePswLabel setTextAlignment:NSTextAlignmentLeft];
    [changePswLabel setFont:textFont];
    [changePswItem addSubview:changePswLabel];
    UIImageView *changePswArrow = [[UIImageView alloc]initWithFrame:CGRectMake(ARROW_X, ARROW_Y, ARROW_WIDTH, ARROW_HEIGHT)];
    [changePswArrow setImage:[UIImage imageNamed:arrowImageName]];
    [changePswItem addSubview:changePswArrow];
    [self.view addSubview:changePswItem];
    
    top_y += (ITEM_HEIGHT);
    UIButton *logoutItem = [[UIButton alloc]initWithFrame:CGRectMake(START_X, top_y, ITEM_WIDHT, ITEM_HEIGHT)];
    [logoutItem setBackgroundImage:[UIImage imageNamed:itemImageName] forState:UIControlStateNormal];
    [logoutItem addTarget:self action:@selector(logoutAction:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *logoutLabel = [[UILabel alloc]initWithFrame:lableRect];
    [logoutLabel setBackgroundColor:[UIColor clearColor]];
    [logoutLabel setText:@"注销账号"];
    [logoutLabel setTextColor:textColor];
    [logoutLabel setTextAlignment:NSTextAlignmentLeft];
    [logoutLabel setFont:textFont];
    [logoutItem addSubview:logoutLabel];
    [self.view addSubview:logoutItem];
    
    top_y += (ITEM_HEIGHT + ITEM_SPACE);
    UIButton *feedbackItem = [[UIButton alloc]initWithFrame:CGRectMake(START_X, top_y, ITEM_WIDHT, ITEM_HEIGHT)];

    [feedbackItem setBackgroundImage:[UIImage imageNamed:itemImageName] forState:UIControlStateNormal];
    [feedbackItem addTarget:self action:@selector(feedbackAction:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *feedbackLabel = [[UILabel alloc]initWithFrame:lableRect];
    [feedbackLabel setBackgroundColor:[UIColor clearColor]];
    [feedbackLabel setText:@"意见反馈"];
    [feedbackLabel setTextColor:textColor];
    [feedbackLabel setTextAlignment:NSTextAlignmentLeft];
    [feedbackLabel setFont:textFont];
    [feedbackItem addSubview:feedbackLabel];
    UIImageView *feedbackArrow = [[UIImageView alloc]initWithFrame:CGRectMake(ARROW_X, ARROW_Y, ARROW_WIDTH, ARROW_HEIGHT)];
    [feedbackArrow setImage:[UIImage imageNamed:arrowImageName]];
    [feedbackItem addSubview:feedbackArrow];
    [self.view addSubview:feedbackItem];
    
    top_y += (ITEM_HEIGHT);
    UIButton *aboutUsItem = [[UIButton alloc]initWithFrame:CGRectMake(START_X, top_y, ITEM_WIDHT, ITEM_HEIGHT)];
//    [aboutUsItem setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:itemImageName]]];
    [aboutUsItem setBackgroundImage:[UIImage imageNamed:itemImageName] forState:UIControlStateNormal];
    UILabel *aboutUsLabel = [[UILabel alloc]initWithFrame:lableRect];
    [aboutUsLabel setBackgroundColor:[UIColor clearColor]];
    [aboutUsLabel setText:@"关于我们"];
    [aboutUsLabel setTextColor:textColor];
    [aboutUsLabel setTextAlignment:NSTextAlignmentLeft];
    [aboutUsLabel setFont:textFont];
    [aboutUsItem addSubview:aboutUsLabel];
    [aboutUsItem addTarget:self action:@selector(aboutUsAction:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *aboutUsArrow = [[UIImageView alloc]initWithFrame:CGRectMake(ARROW_X, ARROW_Y, ARROW_WIDTH, ARROW_HEIGHT)];
    [aboutUsArrow setImage:[UIImage imageNamed:arrowImageName]];
    [aboutUsItem addSubview:aboutUsArrow];
    [self.view addSubview:aboutUsItem];
    

}
- (void)changePswAction:(UIButton *)sender{
    NSLog(@"dddd");
    ChangePswViewController *changePswViewController = [[ChangePswViewController alloc]init];
    changePswViewController.title = @"修改密码";
    [self.navigationController pushViewController:changePswViewController animated:YES];
}
- (void)logoutAction:(UIButton *)sender{
    NSLog(@"logout");
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithBool:NO] forKey:isLoginOutKey];
    [self.delegate logoutAccount];
}
- (void) feedbackAction:(UIButton *)sender{
    FeedbackViewController *feedbackViewController = [[FeedbackViewController alloc]init];
    feedbackViewController.title = @"意见反馈";
    [self.navigationController pushViewController:feedbackViewController animated:YES];
}
- (void) aboutUsAction:(UIButton *)sender{
    AboutUsViewController *aboutUsViewController = [[AboutUsViewController alloc]init];
    aboutUsViewController.title = @"关于我们";
    [self.navigationController pushViewController:aboutUsViewController animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//使用自动下载回调的时候可能加一个alertview之类的弹窗提示会比较好。防止用户不断改变switch的值。
-(void)changeAutoDownLoad:(id)sender{
    UISwitch *mySwitch = (UISwitch *)sender;
    DownloadModel *downloadModel = [DownloadModel getDownloadModel];
    if(mySwitch.on /*&& mySwitch.on!= isAutoDownLoad*/){
        NSLog(@"自动下载开");
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        NSNumber *temp = [NSNumber numberWithBool:mySwitch.on];
        [userdefault setObject:temp forKey:isAutoDownloadKey];
        isAutoDownLoad = mySwitch.on;
        [downloadModel downloadAll];
        //打开自动下载。
        //调用自动下载机制
    }else if(!mySwitch.on/* && mySwitch.on != isAutoDownLoad*/){
        NSLog(@"自动下载关");
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        NSNumber *temp = [NSNumber numberWithBool:mySwitch.on];
        [userdefault setObject:temp forKey:isAutoDownloadKey];
        [downloadModel cancelAll];
//        isAutoDownLoad = mySwitch.on;
        //关闭自动下载
        //暂停当前下载的东西
    }
}

-(void)changePush:(id)sender{
    UISwitch *mySwitch = (UISwitch *)sender;
    if(mySwitch.on /*&& mySwitch.on != isPushvar*/){
        NSLog(@"推送开");
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        NSNumber *temp = [NSNumber numberWithBool:mySwitch.on];
        [userdefault setObject:temp forKey:isPushKey];
        isPushvar = mySwitch.on;
        //调用接受推送回调
    }else if(!mySwitch.on/* && mySwitch.on != isPushvar*/){
        NSLog(@"推送关");
        //调用关闭推送回调
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        NSNumber *temp = [NSNumber numberWithBool:mySwitch.on];
        [userdefault setObject:temp forKey:isPushKey];
//        isPushvar = mySwitch.on;
    }
}
- (void)changeAotoLogin:(id)sender{
    UISwitch *mySwitch = (UISwitch *)sender;
    if(mySwitch.on/* && mySwitch.on != isAutoLogin*/){
        NSLog(@"自动登录开");
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        NSNumber *temp = [NSNumber numberWithBool:mySwitch.on];
        [userdefault setObject:temp forKey:isAutoLoginKey];
        isAutoLogin = mySwitch.on;
        //调用接受推送回调
    }else if(!mySwitch.on/* && mySwitch.on != isAutoLogin*/){
        NSLog(@"自动登录关");
        //调用关闭推送回调
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        NSNumber *temp = [NSNumber numberWithBool:mySwitch.on];
        [userdefault setObject:temp forKey:isAutoLoginKey];
//        isAutoLogin = mySwitch.on;
    }

}


@end
