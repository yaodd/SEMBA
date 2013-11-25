//
//  EvalutateController.m
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by 欧 展飞 on 13-10-30.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "EvaluateController.h"

@interface EvaluateController ()

@end

@implementation EvaluateController
@synthesize line;
@synthesize lineTop;
@synthesize scrollView;

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
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0]];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:199/255.0 green:56/255.0 blue:91/255.0 alpha:1.0];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar_bg"] forBarMetrics:UIBarMetricsDefault];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.height, self.view.frame.size.width)];
    scrollView.delegate = self;
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.height, 1000)];
    [self.view addSubview:scrollView];
    
    line = [[UIImageView alloc] initWithFrame:CGRectMake(50, 150, 800, 50)];
    line.backgroundColor = [UIColor blackColor];
    [self.scrollView addSubview:line];
    
    lineTop = [[UIImageView alloc] initWithFrame:CGRectMake(50, 70, 800, 50)];
    lineTop.backgroundColor = [UIColor blackColor];
    lineTop.hidden = YES;
    [self.view addSubview:lineTop];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.scrollView.contentOffset.y >= line.frame.origin.y){
        lineTop.hidden = NO;
        line.hidden = YES;
    }else {
        lineTop.hidden = YES;
        line.hidden = NO;
    }
}

@end
