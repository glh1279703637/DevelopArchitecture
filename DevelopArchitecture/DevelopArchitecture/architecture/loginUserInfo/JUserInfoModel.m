//
//  JUserInfoModel.m
//  DevelopArchitecture
//
//  Created by Jeffrey on 2021/4/24.
//  Copyright © 2021 Jeffrey. All rights reserved.
//

#import "JUserInfoModel.h"
#import "NSObject+YYModel.h"
#import <objc/runtime.h>

@implementation JUserInfoModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"m_account":@"account"};
}
+(NSString*)funj_modelCustomPropertyMapperPrefix{
    return @"m_";
}
- (void)encodeWithCoder:(NSCoder *)coder {
    [self modelEncodeWithCoder:coder];
}
 
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    return [self modelInitWithCoder:coder];
}
@end
/*
 {"code":0,"data":{"account":"Jeffrey","address":"","age":0,"agentId":0,"agentName":"","amountNum":"","authen":2,"authenResult":0,"authenStatus":"已认证","bankAccount":"","billBank":"","billName":"","billPhone":"","billsum":0,"birthday":"2018-01-23","booktoken":"EQ_21533","canAdd":0,"cardId":"","cityName":"","className":"asdfasdf","classroomId":"8c176f3d0a284ab885e34a9cf7e83936","cloudUsrAccount":"ee0d05723c8f443d824548bdc9ccd90e","cloudUsrId":"89f8bc524231abc2cb4f156f86df4389","collectionCount":0,"context":"","courseList":[],"coursewareCount":0,"crList":[{"classId":0,"className":"asdfasdf","createTime":"","createUserId":0,"grade":0,"gradeName":"","isEff":0,"open":0,"orgName":"","schoolId":0,"status":0,"studentCount":0,"type":0,"years":0}],"createTime":"2017-11-02 14:30:46","creditNum":0,"department":"","editionId":0,"editionName":"","email":"loooo@163.com","friendCount":0,"friendInteg":0.0,"gradeId":11,"gradeName":"高二","integ":6990,"isPlaybackInform":0,"isWXBinding":0,"lessonCount":4870,"lessonList":[],"linkName":"","loginMode":1,"loginTime":0,"loginType":2,"mizhuCoin":0.0,"mizhuFrozen":0.0,"mizhuSum":0,"mizhuTime":46605.24,"mySign":"16828","name":"我们的生活方式是什么时候回来呀","nickname":"我们的生活方式是什么时候回来呀","openId":"","orgId":295,"orgMsgList":[],"orgName":"杭州市春蕾中学","orgRelList":[],"orgType":0,"password":"123","payPassword":"123","pharseId":0,"phaseName":"","photoPath":"http://images.mizholdings.com/IOS381f19a842a34792ddf6d2e358285c22.png","privateCharge":1,"publicCharge":0,"qq":"","recommandId":0,"recommend":0,"regAddress":"","regChannel":9,"relPhone":"","roomCode":"0","sex":"F","starTeacher":0,"status":1,"studentCount":0,"studentScore":3,"subjectId":0,"subjectName":"","summary":"","taxpayerNum":"","teacherCount":0,"times":0,"token":"0CDC881A-A208-44C8-AD37-58DFA15215B9","top":0,"txtoken":"eJyrVgrxCdZLrSjILEpVsjI0sjQzMDDQAQuWpRYpWSkZ6RkoQfjFKdmJBQWZKUBlJgYGJkZmRoamEJnMlNS8ksy0TIgGQ1NjY5iWzHSgSJRHrke4WZV7Sl6gkVOZS1C2Z1Fhga*Fn0*YWXCKUURAiWdkYHG*Z2GZr4EtVGNJZi7IOWaGlkaGlhYGZrUAwI4wTA__","unionId":"","userCode":"GM5","userId":21533,"userIdentity":0,"userIdentityValue":"个人","userIds":[],"userKeep":0,"userOrgList":[],"userPhone":"15911111111","userType":3,"userTypeValue":"学生"},"msg":"查询成功","result":0}
 */
