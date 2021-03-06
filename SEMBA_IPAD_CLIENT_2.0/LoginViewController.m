

//
//  LoginViewController.m
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by yaodd on 13-11-11.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "LoginViewController.h"
#import "MainPageViewController.h"
#import "MenuController.h"
#import "DDMenuController.h"
#import "Dao.h"
#import "SysbsModel.h"
#import "AppDelegate.h"
#import "MRProgressOverlayView.h"




@interface LoginViewController ()
{
    BOOL isAutoLogin;
    BOOL isLogout;
    BOOL keyBoardIsAppear;
    BOOL shouldLogin;
    MRProgressOverlayView *overlayView;
    CGRect originalFrame;
}
@end

@implementation LoginViewController
@synthesize passwordTF;
@synthesize loginButton;
@synthesize accountTF;
@synthesize loginView;
@synthesize autoLoginCheck;
@synthesize forgetView;
@synthesize blurView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isLogout = YES;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:[NSNumber numberWithBool:YES] forKey:isLoginOutKey];
        if ([userDefaults objectForKey:isAutoDownloadKey] == nil) {
            [userDefaults setObject:[NSNumber numberWithBool:YES] forKey:isAutoDownloadKey];
        }
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    keyBoardIsAppear = NO;
    shouldLogin = NO;
    accountTF.delegate = self;
    passwordTF.delegate = self;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *beforeAccount = [userDefaults objectForKey:ACCOUNT_KEY];
    NSString *beforePaw = [userDefaults objectForKey:PASSWORD_KEY];
    
    UIView *accountSpaceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 7, accountTF.frame.size.height)];
    UIView *pswSpaceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 7, passwordTF.frame.size.height)];

    [accountTF setLeftView:accountSpaceView];
    [passwordTF setLeftView:pswSpaceView];
    
    [accountTF setLeftViewMode:UITextFieldViewModeAlways];
    [passwordTF setLeftViewMode:UITextFieldViewModeAlways];
    
    [accountTF setText:beforeAccount];
    [passwordTF setText:beforePaw];
    
    passwordTF.secureTextEntry = YES;
    isAutoLogin = NO;
    isAutoLogin = [(NSNumber *)[userDefaults objectForKey:isAutoLoginKey] boolValue];
    
    [autoLoginCheck setSelected:isAutoLogin];
    if (autoLoginCheck.selected == YES) {
        [autoLoginCheck setBackgroundImage:[UIImage imageNamed:@"check_box_yes"] forState:UIControlStateNormal];
    } else{
        [autoLoginCheck setBackgroundImage:[UIImage imageNamed:@"check_box"] forState:UIControlStateNormal];
    }
    
    blurView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    [blurView setBackgroundColor:[UIColor blackColor]];
    [blurView setAlpha:0.0f];
    [blurView setHidden:YES];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSelector:)];
    [blurView addGestureRecognizer:tapGesture];
    
    forgetView = [[ForgetPSWView alloc] initWithDefault:self];
    forgetView.alpha = 0.0f;
    originalFrame = self.loginView.frame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginAction:(id)sender {
    NSString *accountText = accountTF.text;
    NSString *passwordText = passwordTF.text;
    
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:accountText,@"account",passwordText,@"password", nil];
    NSThread *loginThread = [[NSThread alloc]initWithTarget:self selector:@selector(loginSelector:) object:dict];
    [loginThread start];
    overlayView = [[MRProgressOverlayView alloc]init];
    overlayView.mode = MRProgressOverlayViewModeIndeterminate;
    [self.view addSubview:overlayView];
    [overlayView show:YES];
    
}
- (void)loginSelector:(NSDictionary *)loginInfo{
    NSString *accountText = (NSString *)[loginInfo objectForKey:@"account"];
    NSString *passwordText = (NSString *)[loginInfo objectForKey:@"password"];
    
    if ([accountText length] == 0 || [passwordText length] == 0) {
        UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"出错啦"
                                                          message:@"手机号或密码不能为空，请输入！"
                                                         delegate:nil
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
        //            alertView.delegate = self;
        [alertView show];
        
        [self performSelectorOnMainThread:@selector(overViewDissmiss) withObject:nil waitUntilDone:YES];
//        [loginButton setEnabled:YES];
        return;
    }
    Dao *dao = [Dao sharedDao];
    int loginResult = [dao requestForLogin:accountText password:passwordText];
    [self performSelectorOnMainThread:@selector(overViewDissmiss) withObject:nil waitUntilDone:YES];
    if (loginResult == 1) {
        shouldLogin = YES;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:accountTF.text forKey:ACCOUNT_KEY];
        [userDefaults setObject:passwordTF.text forKey:PASSWORD_KEY];
        [userDefaults synchronize];
        NSLog(@"login success");
        
        [self performSelectorOnMainThread:@selector(jumpToMainPage) withObject:nil waitUntilDone:YES];
        SysbsModel *model = [SysbsModel getSysbsModel];
        NSLog(@"login user id %d",model.user.uid);
        //[self jumpToMainPage];
    } else if (loginResult == 0){
        UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"出错啦"
                                                          message:@"网络连接失败，是否脱机登录？"
                                                         delegate:self
                                                cancelButtonTitle:@"是"
                                                otherButtonTitles:@"否",nil];
        [alertView show];
        NSLog(@"网络连接失败！");
        
    } else if (loginResult == -1){
        UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"出错啦"
                                                          message:@"密码输入错误，请重新输入！"
                                                         delegate:nil
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
        [alertView show];
        NSLog(@"密码输入错误！");
    } else if (loginResult == -2){
        UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"出错啦"
                                                          message:@"用户不存在，请检查用户名！"
                                                         delegate:nil
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
        [alertView show];
        NSLog(@"用户不存在！");
    }
    
    
}
- (void)overViewDissmiss{
    [overlayView dismiss:YES];
}
- (void)viewDidAppear:(BOOL)animated{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    isLogout = [(NSNumber *)[userDefaults objectForKey:isLoginOutKey] boolValue];
    if (isAutoLogin && isLogout)
    {
        [self loginAction:nil];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    keyBoardIsAppear = NO;
    shouldLogin = NO;
}
- (void)jumpToMainPage{

    MainPageViewController *mainController = [[MainPageViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mainController];
    DDMenuController *hostController = [[DDMenuController alloc] initWithRootViewController:navController];
    MenuController *menuController = [[MenuController alloc] init];
    hostController.leftViewController = menuController;
    menuController.hostController = hostController;
    //[self presentViewController:navController animated:YES completion:nil];
    [self presentViewController:hostController animated:YES completion:nil];
    
}


#pragma Mark UITextFieldDelegate
// 下面两个方法是为了防止TextView让键盘挡住的方法
/*
 开始编辑UITextView的方法
 */
-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    if (keyBoardIsAppear) {
//        return;
    }
    NSLog(@"yes");
    keyBoardIsAppear = YES;
    if (self.loginView.frame.origin.y != originalFrame.origin.y) {
        return;
    }
    CGRect curFrame = self.loginView.frame;
    [UIView animateWithDuration:0.3f animations:^{
        self.loginView.frame = CGRectMake(curFrame.origin.x, curFrame.origin.y - 200, curFrame.size.width, curFrame.size.height);
    }];
    
}

/**
 结束编辑UITextView的方法，让原来的界面还原高度
 */
-(void) textFieldDidEndEditing:(UITextField *)textField
{

    NSLog(@"end");
    if (!keyBoardIsAppear) {
        if (shouldLogin) {
//            [self disappearAnimBegin];
        }
//        keyBoardIsAppear = NO;
      //  return;
    }
    if (self.loginView.frame.origin.y == originalFrame.origin.y) {
        return;
    }
    CGRect curFrame=self.loginView.frame;
    [UIView beginAnimations:@"drogDownKeyBoard" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    self.loginView.frame = CGRectMake(curFrame.origin.x, curFrame.origin.y + 200, curFrame.size.width, curFrame.size.height);
    
    [UIView commitAnimations];
    keyBoardIsAppear = NO;
    shouldLogin = NO;

}
- (IBAction)autoLoginCheckAction:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (autoLoginCheck.selected == NO) {
        [autoLoginCheck setBackgroundImage:[UIImage imageNamed:@"check_box_yes"] forState:UIControlStateNormal];
        autoLoginCheck.selected = YES;
    } else{
        [autoLoginCheck setBackgroundImage:[UIImage imageNamed:@"check_box"] forState:UIControlStateNormal];
        autoLoginCheck.selected = NO;
    }
    [userDefaults setObject:[NSNumber numberWithBool:autoLoginCheck.selected] forKey:isAutoLoginKey];
}
#pragma UIAlertViewDelegate mark -

//Event When click forget button
- (IBAction)ForgetPSWBtnPressed:(id)sender {
    [self showBlur];
    [forgetView showModifyPSWView];
}

- (void)tapSelector:(UITapGestureRecognizer *)gesture{
    [forgetView hideModifyPSWView];
    [self hideBlur];
}

- (void)showBlur{
    [self.view addSubview:blurView];
    [blurView setHidden:NO];
    [UIView animateWithDuration:0.5f animations:^{
        [blurView setAlpha:0.5f];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideBlur{
    [UIView animateWithDuration:0.5f animations:^{
        [blurView setAlpha:0.0f];
    } completion:^(BOOL finished){
        [blurView setHidden:YES];
        [blurView removeFromSuperview];
    }];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self jumpToMainPage];
    }
}
@end
