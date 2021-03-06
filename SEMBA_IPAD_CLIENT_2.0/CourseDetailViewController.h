//
//  CourseDetailViewController.h
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by 王智锐 on 12/31/13.
//  Copyright (c) 2013 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseDetailViewController : UIViewController

@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *dateLabel;
@property (nonatomic,strong)UILabel *peopleNumLabel;
@property (nonatomic,strong)UITextView *contentTextView;
@property (nonatomic,strong)UIButton *selectButton;
@property (nonatomic,strong)UILabel *courseShortViewTitle;
@property (nonatomic,strong)UITextView *courseShortViewContent;
@property (nonatomic,strong)UILabel *teacherShortViewTitle;
@property (nonatomic,strong) UITextView *teacherShortViewContent;
@property (nonatomic,strong)UIScrollView *scrollView;
//获取图片的线程类。
@property (nonatomic,retain)NSOperationQueue *requestImageQuque;
//存放获取资源
@property(nonatomic,strong)NSMutableArray *originalIndexArray;
@property(nonatomic,strong)NSMutableDictionary *originalOperationDic;


-(void)displayProductImage;

-(void)displayImageByIndex:(NSInteger)index ByImageURL:(NSURL*)url;

-(void)imageDidReceive:(UIImageView*)imageView;



-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil courseid:(int)course_index ;
@end
