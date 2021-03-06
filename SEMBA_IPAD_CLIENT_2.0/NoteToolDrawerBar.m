//
//  NoteToolDrawerBar.m
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by yaodd on 13-11-8.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "NoteToolDrawerBar.h"
#import "UIColor+category.h"
#define BUTTON_X    0.0f
#define BUTTON_Y    20.0f
#define BUTTON_WIDTH_SMALL    97.0f
#define BUTTON_HEIGHT_SMALL   73.0f
#define BUTTON_WIDTH_LARGE    156.0f
#define BUTTON_HEIGHT_LARGE   88.0f
#define BUTTON_SPACE    16.0f

#define COLOR_BUTTON_TAG    111111


@implementation NoteToolDrawerBar
@synthesize isOpen;
@synthesize parentView;
@synthesize closePoint;
@synthesize openPoint;
@synthesize parentRect;
@synthesize arrowIV;
@synthesize buttonArray;
@synthesize imageNameNArray;
@synthesize imageNameHArray;

- (id)initWithFrame:(CGRect)frame parentView:(UIView *)parentview
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //初始化抽屉
        self.parentView = parentview;
        parentRect = parentView.frame;
        parentRect.size.width = parentView.frame.size.height;
        parentRect.size.height = parentView.frame.size.width;
        
        UIImageView *background = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ppt_toolbox_bg"]];
        [background setFrame:CGRectMake(0, 0, background.frame.size.width, 80 + 3 * 60 + 3 * BUTTON_SPACE + 20 * 2 + 20)];
        [self addSubview:background];
        
        UIView *touchView = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width - 40, 0, 40, frame.size.height)];
        [touchView setBackgroundColor:[UIColor clearColor]];

        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        panRecognizer.view.tag = 111111;
//        [touchView addGestureRecognizer:panRecognizer];
        [self addGestureRecognizer:panRecognizer];
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
        tapRecognizer.view.tag = 222222;
        [touchView addGestureRecognizer:tapRecognizer];
        
        [self addSubview:touchView];
        
        arrowIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, frame.size.height / 2 - 20, 40, 40)];
        [arrowIV setBackgroundColor:[UIColor clearColor]];
        [touchView addSubview:arrowIV];
        
        closePoint = CGPointMake(0 - (self.frame.size.width / 2 - 40), parentRect.size.height / 2);
        openPoint = CGPointMake(frame.size.width / 2, parentRect.size.height / 2);
        self.center = closePoint;
        
        [self initButton];
        
    }
    return self;
}

- (void)initButton{
    imageNameNArray = [[NSMutableArray alloc]initWithObjects:@"ppt_toolbox_colorpicker_bg",@"ppt_toolbox_pencil",@"ppt_toolbox_brush",@"ppt_toolbox_eraser",@"ppt_toolbox_camera",@"ppt_toolbox_recorder", nil];
    imageNameHArray = [[NSMutableArray alloc]initWithObjects:@"ppt_toolbox_colorpicker_bg_active",@"ppt_toolbox_pencil_active",@"ppt_toolbox_brush_active",@"ppt_toolbox_eraser_active",@"ppt_toolbox_camera_active",@"ppt_toolbox_recorder_active", nil];
    CGFloat topButtonY = BUTTON_Y;
    buttonArray = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < 4; i ++) {
        UIImage *image = [UIImage imageNamed:[imageNameNArray objectAtIndex:i]];
        CGFloat width = image.size.width;
        CGFloat height = image.size.height;
        
        if (i == 0) {
            image = [[UIColor blackColor] createImage];
            width = 80;
            height = 80;
        }
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(BUTTON_X, topButtonY, width, height)];
//        [button setBackgroundColor:[UIColor grayColor]];
        if (i == 0) {
            [button.layer setCornerRadius:40];
            [button.layer setBorderColor:[UIColor whiteColor].CGColor];
            [button.layer setBorderWidth:4];
            [button.layer setMasksToBounds:YES];
//            [button setTag:COLOR_BUTTON_TAG];
        }
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setTag:i + 1];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [buttonArray addObject:button];
        [self addSubview:button];
        topButtonY += (height + BUTTON_SPACE);
    }
}

- (void)setButtonColor:(UIColor *)color
{
    UIButton *button = (UIButton *)[self viewWithTag:1];
    [button setBackgroundImage:[color createImage] forState:UIControlStateNormal];
}

- (void)buttonAction:(UIButton *)button
{
    [self closeAllButtonExcept:button.tag];
    if (button.selected) {
        [self animationOfButtonClose:button];
    } else{
        [self animationOfButtonOpen:button];
    }
    button.selected = !button.selected;
    
    [self.delegate tappedInNoteToolDrawerBar:self toolAction:button];
}
- (void)closeAllButton{
    for (int i = 0 ; i < [buttonArray count]; i ++) {
        UIButton *otherButton = [buttonArray objectAtIndex:i];
        if (otherButton.selected) {
            [self animationOfButtonClose:otherButton];
            otherButton.selected = NO;
        }
    }
}
- (void)closeAllButtonExcept:(int)index{
    for (int i = 0 ; i < [buttonArray count]; i ++) {
        UIButton *otherButton = [buttonArray objectAtIndex:i];
        if (otherButton.selected && otherButton.tag != index) {
            [self animationOfButtonClose:otherButton];
            otherButton.selected = NO;
        }
    }
}


- (void)animationOfButtonOpen:(UIButton *)button{
    int index = button.tag - 1;
    if (button.tag == 1) {
        return;
    }
    UIImage *image = [UIImage imageNamed:[imageNameHArray objectAtIndex:index]];
    CGRect rect = button.frame;
    rect.origin.y -= ((image.size.height - rect.size.height) / 2);
    rect.origin.x = 0;
    rect.size.width = image.size.width;
    rect.size.height = image.size.height;

    [UIView animateWithDuration:0.5 animations:^{
        button.frame = rect;
        
    } completion:^(BOOL finish){
        [button setBackgroundImage:image forState:UIControlStateNormal];
    }];
}
- (void)animationOfButtonClose:(UIButton *)button{
    int index = button.tag - 1;
    if (button.tag == 1) {
        return;
    }
    UIImage *image = [UIImage imageNamed:[imageNameNArray objectAtIndex:index]];
    CGRect rect = button.frame;
    rect.origin.y += ((rect.size.height - image.size.height) / 2);
    rect.origin.x = 0;
    rect.size.height = image.size.height;
    rect.size.width = image.size.width;
    [UIView animateWithDuration:0.3 animations:^{
        button.frame = rect;
    } completion:^(BOOL finish){
        [button setBackgroundImage:image forState:UIControlStateNormal];
    }];
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer{
    NSLog(@"drawtoolhandlepan");
    CGPoint translation = [recognizer translationInView:parentView];
    if (self.center.x + translation.x < closePoint.x) {
        self.center = closePoint;
    }else if(self.center.x + translation.x > openPoint.x)
    {
        self.center = openPoint;
    }else{
        self.center = CGPointMake(self.center.x + translation.x, self.center.y);
    }
    [recognizer setTranslation:CGPointMake(0, 0) inView:parentView];
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.75 delay:0.15 options:UIViewAnimationOptionCurveEaseOut animations:^{
            if (self.center.x < openPoint.x * 1/2) {
                self.center = closePoint;
//                [self transformArrow:NO];
                [self.delegate drawerClose:self];

            }else
            {
                self.center = openPoint;
//                [self transformArrow:YES];
            }
            
        } completion:^(BOOL finish){
            if (!isOpen) {
                
                NSLog(@"open");
            } else{
//                [self.delegate drawerClose:self];
                NSLog(@"close");
            }
            isOpen = !isOpen;
        }];
        
    }
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer{
    [self openOrCloseToolBar];
}
- (void)openOrCloseToolBar{
    [UIView animateWithDuration:0.75 delay:0.15 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        if (isOpen) {
            self.center = closePoint;
//            [self transformArrow:NO];
            [self.delegate drawerClose:self];
        }else
        {
            self.center = openPoint;
//            [self transformArrow:YES];
        }
    } completion:^(BOOL finish){
        isOpen = !isOpen;
    }];
}

- (void)transformArrow:(BOOL)openOrClose{
    
    if (openOrClose) {
//        [self.delegate drawerOpen:self];
    } else{
//        [self.delegate drawerClose:self];
    }
    [UIView animateWithDuration:0.3 delay:0.35 options:UIViewAnimationOptionCurveEaseOut animations:^{
        if (openOrClose == YES){
            
            arrowIV.transform = CGAffineTransformMakeRotation(M_PI);
        }else
        {
            
            arrowIV.transform = CGAffineTransformMakeRotation(0);
        }
    } completion:^(BOOL finish){
        self.isOpen = openOrClose;
        [self closeAllButton];
    }];
    
}

- (void)hideNoteToolDrawerBar{
    if (self.hidden == NO)
	{
        NSLog(@"hide");
		[UIView animateWithDuration:0.25 delay:0.0
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^(void)
         {
             self.alpha = 0.0f;
         }
                         completion:^(BOOL finished)
         {
             self.hidden = YES;
         }
         ];
	}
    
}

- (void)showNoteToolDrawerBar{
    if (self.hidden == YES)
	{
        NSLog(@"show");
		[UIView animateWithDuration:0.25 delay:0.0
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^(void)
         {
             self.hidden = NO;
             self.alpha = 1.0f;
         }
                         completion:NULL
         ];
	}
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
