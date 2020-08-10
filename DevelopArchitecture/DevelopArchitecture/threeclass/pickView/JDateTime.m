//
//  JDateTime.m
//  TheStationAgent
//
//  Created by Jeffrey on 14-1-10.
//  Copyright (c) 2014年 Jeffrey. All rights reserved.
//

#import "JDateTime.h"

@implementation JDateTime

//所有年列表
+(NSMutableArray *) funj_GetAllYearArray{
    NSMutableArray * yearArray = [[NSMutableArray alloc]init];
    for (int i = 2000; i<2100; i++) {
        NSString * days = [[NSString alloc]initWithFormat:@"%d",i];
        [yearArray addObject:days];
    }
    return yearArray;
}
//所有月列表
+(NSMutableArray *) funj_GetAllMonthArray{
    return [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12", nil];
}
//以YYYY年MM月dd日格式输出年月日
+(NSString*) funj_getDateTime{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:[NSString stringWithFormat:@"yyyy%@",NSLocalizedString(@"Year", nil)]];
    NSString* date = [[NSString alloc]initWithString:[formatter stringFromDate:[NSDate date]]];
     return date;
}
//以YYYY年MM月dd日格式输出年月日
+(NSString*) funj_getDateTimedate{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:[NSString stringWithFormat:@"MM%@",NSLocalizedString(@"Month", nil)]];
    NSString* date = [[NSString alloc]initWithString:[formatter stringFromDate:[NSDate date]]];
     return date;
}
//获取指定年份指定月份的星期排列表
+(NSMutableArray *) funj_GetDayArrayByYear:(int) year andMonth:(int) month{
    NSMutableArray * dayArray = [[NSMutableArray alloc]init];
    fontMonthDay=-1;
    endMonthDay=-1;
    currentMonthDay=month;
    for (int i = 1; i<=42; i++) {
        if ([self funj_GetTheWeekOfDayByYear:year andByMonth:month]==1) {
            fontMonthDay = month;
        }
        if (i <=[self funj_GetTheWeekOfDayByYear:year andByMonth:month]) {
     /*
            int upyears,upmonths;
            month==1?(upyears=year-1,upmonths=13) :(upmonths=month,upyears=year) funj_;
            int t=  [self GetNumberOfDayByYear:upyears andByMonth:upmonths-1]-[self funj_GetTheWeekOfDayByYear:upyears andByMonth:upmonths]+i+1;
            if(upmonths==13) t=t+1;
            [dayArray addObject:[NSString stringWithFormat:@"%d",t]];
  
            fontMonthDay=upmonths-1;
            tfontYear=upyears;*/
            [dayArray addObject:@"-1"];
            
        }else if ((i>[self funj_GetTheWeekOfDayByYear:year andByMonth:month]) &&(i<[self funj_GetTheWeekOfDayByYear:year andByMonth:month]+[self  funj_GetNumberOfDayByYear:year andByMonth:month]+1) ) {

            NSString * days;
            if((i - [self funj_GetTheWeekOfDayByYear:year andByMonth:month] )< 10)
                days = [NSString stringWithFormat:@"%d",i-[self funj_GetTheWeekOfDayByYear:year andByMonth:month]];
            else days = [NSString stringWithFormat:@"%d",i-[self funj_GetTheWeekOfDayByYear:year andByMonth:month]];
            [dayArray addObject:days];
            currentMonthDay=month;
            tcurrentYear=year;
          
        }else {
    
           /* NSString * days;
            int upyears,upmonths;
            month==12?(upyears=year+1,upmonths=1) :(upmonths=month+1,upyears=year) funj_;
            if((i - [self funj_GetTheWeekOfDayByYear:year andByMonth:month] +1) funj_< 10) funj_
                days = [NSString stringWithFormat:@"%d",(i-[self funj_GetTheWeekOfDayByYear:year andByMonth:month]+1) %([self GetNumberOfDayByYear:year andByMonth:month]) funj_];
            else days = [NSString stringWithFormat:@"%d",(i-[self funj_GetTheWeekOfDayByYear:year andByMonth:month]+1) %([self GetNumberOfDayByYear:year andByMonth:month]) funj_];
            [dayArray addObject:days];
            endMonthDay=upmonths;
            tendYear=upyears;*/
            if(i % 7 == 1)break;
             [dayArray addObject:@"-1"];
            if(i % 7 == 0) break;
         }
    }
    return dayArray;
}
//计算year年month月第一天是星期几，周日则为0
+(int) funj_GetTheWeekOfDayByYear:(int) year
                 andByMonth:(int) month{
    int numWeek = ((year-1)+ (year-1) /4-(year-1)/100+(year-1) /400+1) %7;//numWeek为years年的第一天是星期几
 
    int ar[12] = {0,31,59,90,120,151,181,212,243,273,304,334};
    int numdays = (((year%4==0&&year%100!=0) ||(year%400==0)) &&(month>2) ) ?(ar[month-1]+1) :(ar[month-1]);//numdays为month月years年的第一天是这一年的第几天

    int dayweek = (numdays%7 + numWeek) %7;//month月第一天是星期几，周日则为0
    return dayweek;
}
//判断year年month月有多少天
+(int) funj_GetNumberOfDayByYear:(int) year
                andByMonth:(int) month{
    int dayWithMonth[]={31,28,31,30,31,30,31,31,30,31,30,31};
    if (((year%4==0&&year%100!=0) ||(year%400==0)) &&month==2){
        return 29;
    }
    return dayWithMonth[month-1];
}
//计算两日期之差
+ (NSInteger)funj_numberOfDaysWithFromDate:(NSString *)fromDate to:(NSString *)toDate f:(NSString*)format{
    NSDateFormatter *dateFor =[[NSDateFormatter alloc]init];
    dateFor.dateFormat =format ? format : @"yyyy-MM-dd";
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents * comp = [calendar components:NSCalendarUnitDay
                                          fromDate:[dateFor dateFromString:fromDate]
                                            toDate:[dateFor dateFromString:toDate]
                                           options:NSCalendarWrapComponents];
    return comp.day;
}
// 获取当前是星期几
+ (NSDictionary*)funj_getNowWeekday:(NSString*)dateStr {
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = nil;
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    NSDateFormatter *dateFor =[[NSDateFormatter alloc]init];
    dateFor.dateFormat = @"yyyy-MM-dd";
    
    // 话说在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    comps = [calendar components:unitFlags fromDate:[dateFor dateFromString:dateStr]];
    NSArray *nameArr = [JDateTime funj_getWeek:NO];
    NSInteger weekDay[7]={7,1,2,3,4,5,6};
    
    return @{@"repeatDay":[NSString stringWithFormat:@"%zd",weekDay[[comps weekday]-1]],@"repeatDayName":nameArr[[comps weekday]-1]};
}
+(NSArray*)funj_getWeek:(BOOL)sort{
    if(sort)return @[@"一",@"二",@"三",@"四",@"五",@"六",@"日"];
    else return @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
}
@end
