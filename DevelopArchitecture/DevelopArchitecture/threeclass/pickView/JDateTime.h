//
//  JDateTime.h
//  TheStationAgent
//
//  Created by Jeffrey on 14-1-10.
//  Copyright (c) 2014年 Jeffrey. All rights reserved.
//

#import <Foundation/Foundation.h>
static int tfontYear;
static int tcurrentYear;
static int tendYear;

static int fontMonthDay;
static int currentMonthDay;
static  int endMonthDay;

@interface JDateTime : NSObject
//所有年列表
+(NSMutableArray *) funj_GetAllYearArray;

//所有月列表
+(NSMutableArray *) funj_GetAllMonthArray;

//获取指定年份指定月份的星期排列表
+(NSMutableArray *) funj_GetDayArrayByYear:(int)year
                     andMonth:(int) month;
+(int) funj_GetTheWeekOfDayByYear:(int) year
                 andByMonth:(int) month;
+(int) funj_GetNumberOfDayByYear:(int) year
                andByMonth:(int) month;
//获取两日期之间天数差
+ (NSInteger)funj_numberOfDaysWithFromDate:(NSString *)fromDate to:(NSString *)toDate f:(NSString*)format;
// 获取当前是星期几
+ (NSDictionary*)funj_getNowWeekday:(NSString*)dateStr;
//获取星期
+(NSArray*)funj_getWeek:(BOOL)sort;
@end
