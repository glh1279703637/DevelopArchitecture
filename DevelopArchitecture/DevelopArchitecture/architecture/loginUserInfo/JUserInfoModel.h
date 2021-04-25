//
//  JUserInfoModel.h
//  DevelopArchitecture
//
//  Created by Jeffrey on 2021/4/24.
//  Copyright © 2021 Jeffrey. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JUserInfoModel : NSObject

@property( nonatomic , copy   ) NSString *m_account ;
@property( nonatomic , copy   ) NSString *m_address ;
@property( nonatomic , assign ) NSInteger m_age ;
@property( nonatomic , assign ) NSInteger m_agentId ;
@property( nonatomic , copy   ) NSString *m_agentName ;
//@property( nonatomic , copy   ) NSString *m_amountNum ;
//@property( nonatomic , assign ) NSInteger m_authen ;
//@property( nonatomic , assign ) NSInteger m_authenResult ;
//@property( nonatomic , copy   ) NSString *m_authenStatus ;
//@property( nonatomic , copy   ) NSString *m_bankAccount ;
//@property( nonatomic , copy   ) NSString *m_billBank ;
//@property( nonatomic , copy   ) NSString *m_billName ;
//@property( nonatomic , copy   ) NSString *m_billPhone ;
//@property( nonatomic , assign ) NSInteger m_billsum ;
//@property( nonatomic , copy   ) NSString *m_birthday ;
//@property( nonatomic , copy   ) NSString *m_booktoken ;
//@property( nonatomic , assign ) NSInteger m_canAdd ;
//@property( nonatomic , copy   ) NSString *m_cardId ;
//@property( nonatomic , copy   ) NSString *m_cityName ;
//@property( nonatomic , copy   ) NSString *m_className ;
//@property( nonatomic , copy   ) NSString *m_classroomId ;
//@property( nonatomic , copy   ) NSString *m_cloudUsrAccount ;
//@property( nonatomic , copy   ) NSString *m_cloudUsrId ;
//@property( nonatomic , assign ) NSInteger m_collectionCount ;
//@property( nonatomic , copy   ) NSString *m_context ;
@property( nonatomic , strong ) NSArray *m_courseList ;
//@property( nonatomic , assign ) NSInteger m_coursewareCount ;
//@property( nonatomic , strong ) NSArray *m_crList ;
//@property( nonatomic , copy   ) NSString *m_createTime ;
//@property( nonatomic , assign ) NSInteger m_creditNum ;
//@property( nonatomic , copy   ) NSString *m_department ;
//@property( nonatomic , assign ) NSInteger m_editionId ;
//@property( nonatomic , copy   ) NSString *m_editionName ;
//@property( nonatomic , copy   ) NSString *m_email ;
//@property( nonatomic , assign ) NSInteger m_friendCount ;
@property( nonatomic , assign ) double friendInteg ;
//@property( nonatomic , assign ) NSInteger m_gradeId ;
//@property( nonatomic , copy   ) NSString *m_gradeName ;
//@property( nonatomic , assign ) NSInteger m_integ ;
//@property( nonatomic , assign ) NSInteger m_isPlaybackInform ;
//@property( nonatomic , assign ) NSInteger m_isWXBinding ;
//@property( nonatomic , assign ) NSInteger m_lessonCount ;
//@property( nonatomic , strong ) NSArray *m_lessonList ;
//@property( nonatomic , copy   ) NSString *m_linkName ;
//@property( nonatomic , assign ) NSInteger m_loginMode ;
//@property( nonatomic , assign ) NSInteger m_loginTime ;
//@property( nonatomic , assign ) NSInteger m_loginType ;
//@property( nonatomic , assign ) double mizhuCoin ;
//@property( nonatomic , assign ) double mizhuFrozen ;
//@property( nonatomic , assign ) NSInteger m_mizhuSum ;
@property( nonatomic , assign ) double mizhuTime ;
//@property( nonatomic , copy   ) NSString *m_mySign ;
//@property( nonatomic , copy   ) NSString *m_name ;
//@property( nonatomic , copy   ) NSString *m_nickname ;
//@property( nonatomic , copy   ) NSString *m_openId ;
//@property( nonatomic , assign ) NSInteger m_orgId ;
//@property( nonatomic , strong ) NSArray *m_orgMsgList ;
//@property( nonatomic , copy   ) NSString *m_orgName ;
@property( nonatomic , strong ) NSArray *m_orgRelList ;
//@property( nonatomic , assign ) NSInteger m_orgType ;
//@property( nonatomic , copy   ) NSString *m_password ;
//@property( nonatomic , copy   ) NSString *m_payPassword ;
//@property( nonatomic , assign ) NSInteger m_pharseId ;
//@property( nonatomic , copy   ) NSString *m_phaseName ;
//@property( nonatomic , copy   ) NSString *m_photoPath ;
//@property( nonatomic , assign ) NSInteger m_privateCharge ;
//@property( nonatomic , assign ) NSInteger m_publicCharge ;
//@property( nonatomic , copy   ) NSString *m_qq ;
//@property( nonatomic , assign ) NSInteger m_recommandId ;
//@property( nonatomic , assign ) NSInteger m_recommend ;
//@property( nonatomic , copy   ) NSString *m_regAddress ;
//@property( nonatomic , assign ) NSInteger m_regChannel ;
//@property( nonatomic , copy   ) NSString *m_relPhone ;
//@property( nonatomic , copy   ) NSString *m_roomCode ;
//@property( nonatomic , copy   ) NSString *m_sex ;
//@property( nonatomic , assign ) NSInteger m_starTeacher ;
//@property( nonatomic , assign ) NSInteger m_status ;
//@property( nonatomic , assign ) NSInteger m_studentCount ;
//@property( nonatomic , assign ) NSInteger m_studentScore ;
//@property( nonatomic , assign ) NSInteger m_subjectId ;
//@property( nonatomic , copy   ) NSString *m_subjectName ;
//@property( nonatomic , copy   ) NSString *m_summary ;
//@property( nonatomic , copy   ) NSString *m_taxpayerNum ;
//@property( nonatomic , assign ) NSInteger m_teacherCount ;
//@property( nonatomic , assign ) NSInteger m_times ;
//@property( nonatomic , copy   ) NSString *m_token ;
//@property( nonatomic , assign ) NSInteger m_top ;
//@property( nonatomic , copy   ) NSString *m_txtoken ;
//@property( nonatomic , copy   ) NSString *m_unionId ;
//@property( nonatomic , copy   ) NSString *m_userCode ;
//@property( nonatomic , assign ) NSInteger m_userId ;
//@property( nonatomic , assign ) NSInteger m_userIdentity ;
//@property( nonatomic , copy   ) NSString *m_userIdentityValue ;
//@property( nonatomic , strong ) NSArray *m_userIds ;
//@property( nonatomic , assign ) NSInteger m_userKeep ;
//@property( nonatomic , strong ) NSArray *m_userOrgList ;
//@property( nonatomic , copy   ) NSString *m_userPhone ;
//@property( nonatomic , assign ) NSInteger m_userType ;
//@property( nonatomic , copy   ) NSString *m_userTypeValue ;

@end

NS_ASSUME_NONNULL_END

