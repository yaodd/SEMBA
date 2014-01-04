//
//  Course.m
//  ;
//
//  Created by 王智锐 on 13-9-18.
//  Copyright (c) 2013年 王智锐. All rights reserved.
//

#import "Course.h"

@implementation Course

@synthesize courseName,courseDescription,teacherName,fileArr,cid,recommendBook,timeArr;
@synthesize startTime = _startTime;
@synthesize endTime = _endTime;
+(id)alloc{
    return [super alloc];
}

-(id)init{
    if(self = [super init]){
        cid = 0;
        fileArr = [[NSMutableArray alloc] init];
        recommendBook = [[NSMutableArray alloc] init];
        timeArr = [[NSMutableArray alloc] init];
        courseName = @"";
        courseDescription = @"";
        _startTime = @"";
        _endTime = @"";
        _location = @"";
        teacherName = @"";
        return self;
    }
    return nil;
}


@end
