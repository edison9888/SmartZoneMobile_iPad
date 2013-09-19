/*
 *  URL_Define.h
 *  MobileOffice2.0
 *
 *  Created by nicejin on 11. 2. 22..
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *	
 *	서비스별 Target URL을 불러 온다.
 */

#define URL_Head @"https://147.6.89.31"

#define LOGIN_PIN @"login_pin"
#define URL_iPadStock @"https://sz.kt.com/sz/stock/stock_main.jsp"


#define URL_getAppointmentList              URL_Head"/sz/appointment/AppointmentController/getAppointmentList.do" //일정 조회 메인 목록
#define URL_getAppointmentDetail            URL_Head"/sz/appointment/AppointmentController/getAppointmentDetail.do" //일정 조회 detail 조회
#define getAppointmentAttachmentInfo        URL_Head"/sz/appointment/AppointmentController/getAppointmentAttachmentInfo.do"//일정 첨부

#define URL_getSharedAppointmentList        URL_Head"/sz/appointment/AppointmentController/getSharedAppointmentList.do" //공유 일정 조회
#define URL_createAppointmentInfo           URL_Head"/sz/appointment/AppointmentController/createAppointmentInfo.do" //일정 생성
#define URL_updateAppointmentInfo           URL_Head"/sz/appointment/AppointmentController/updateAppointmentInfo.do" //일정 수정
#define URL_acceptAppointmentInfo           URL_Head"/sz/appointment/AppointmentController/acceptAppointmentInfo.do" //일정 수락
#define URL_deleteAppointmentInfo           URL_Head"/sz/appointment/AppointmentController/deleteAppointmentInfo.do" //일정 삭제
#define URL_cancelAppointmentInfo           URL_Head"/sz/appointment/AppointmentController/cancelAppointmentInfo.do" //일정 취소

#define URL_getSharedUserInfoList           URL_Head"/sz/appointment/AppointmentController/getSharedUserInfoList.do"    //공유 사용자 목록 조회
#define URL_createSharedUserInfo            URL_Head"/sz/appointment/AppointmentController/createSharedUserInfo.do"      //공유 사용자 저장
#define URL_deleteSharedUserInfo            URL_Head"/sz/appointment/AppointmentController/deleteSharedUserInfo.do"      // 공유 사용자 삭제

#define URL_getAddressList                  URL_Head"/sz/address/AddressController/getAddressList.do"		//임직원조회
#define URL_getAddressDetail                URL_Head"/sz/address/AddressController/getAddressDetail.do"	//임직원조회	
#define URL_getBadges                       URL_Head"/sz/push/PushController/getBadges.do"
#define TEST_URL                            URL_Head"/szGW/address/AddressController/getAddressList.do"				//임직원조회

#define URL_getContactInfoList              URL_Head"/sz/contact/ContactController/getContactInfoList.do"	//내연락처목록조회	
#define URL_getContactInfoDetail            URL_Head"/sz/contact/ContactController/getContactInfoDetail.do"	//내연락처상세조회	
#define URL_createContactInfo               URL_Head"/sz/contact/ContactController/createContactInfo.do"	//내연락처생성	
#define URL_updateContactInfo               URL_Head"/sz/contact/ContactController/updateContactInfo.do"	//내연락처수정	

#define URL_getOrgInfo                      URL_Head"/sz/orgnavi/OrgNaviController/getOrgInfo.do"  //조직정보조회
#define URL_getCompanyInfo                  URL_Head"/sz/orgnavi/OrgNaviController/getCompanyInfo.do" //회사정보조회
#define URL_getUserInfo                     URL_Head"/sz/orgnavi/OrgNaviController/getUserInfo.do" //임직원 정보 조회


//알려주시오
#define URL_getSOSList                      URL_Head"/sz/sos/SOSController/getSOSList.do"
#define URL_getSOSDetail                    URL_Head"/sz/sos/SOSController/getSOSDetail.do"
#define URL_insertSOSQuestion               URL_Head"/sz/sos/SOSController/insertSOSQuestion.do"
#define URL_deleteSOSQuestion               URL_Head"/sz/sos/SOSController/deleteSOSQuestion.do"
#define URL_insertSOSAnswer                 URL_Head"/sz/sos/SOSController/insertSOSAnswer.do"
#define URL_deleteSOSAnswer                 URL_Head"/sz/sos/SOSController/deleteSOSAnswer.do"
#define URL_setSOSChoice                    URL_Head"/sz/sos/SOSController/setSOSChoice.do"
#define URL_getStockInfo                    URL_Head"/sz/stock/StockController/getStockInfo.do"
#define URL_getAllBoardList                 URL_Head"/sz/bbs/BbsController/getAllBoardList.do"
#define URL_getBulletinList                 URL_Head"/sz/bbs/BbsController/getBulletinList.do"
#define URL_getBoardContent                 URL_Head"/sz/bbs/BbsController/getContent.do"
    
#define URL_LogInService                    URL_Head"/sz/auth/AuthController/getAuth.do" //로그인
#define URL_AuthService                     URL_Head"/sz/auth/AuthController/initSync.do" //로그인 (초기정보)

#define URL_getPing                         URL_Head"/sz/auth/AuthController/ping.do" //wake-on세션 체크용

//--- approval by kakadais ---//
#define URL_getApprovalInfo                 URL_Head"/sz/approval/ApprovalController/getApprovalInfo.do" //결재함 개수
#define URL_getApprovalListInfo             URL_Head"/sz/approval/ApprovalController/getApprovalListInfo.do" //특정 결재 항목 목록
#define URL_getApprovalDocInfo              URL_Head"/sz/approval/ApprovalController/getApprovalDocInfo.do" //결재 문서 상세
#define URL_getApprovalLineListInfo         URL_Head"/sz/approval/ApprovalController/getApprovalLineListInfo.do" //결재선 목록
#define URL_getOpinionListInfo              URL_Head"/sz/approval/ApprovalController/getOpinionListInfo.do" //결재 의견 목록
#define URL_getApprovalDecisionInfo         URL_Head"/sz/approval/ApprovalController/getApprovalDecisionInfo.do" //결재 처리
#define URL_PaymentBadgeInfo                URL_Head"/sz/approval/ApprovalController/getApprovalBadgeInfo.do"  //결재 배지 
#define URL_getAprFileDownload              URL_Head"/sz/approval/ApprovalController/getAprFileDownload.do" //결재문서 다운로드
#define URL_getsettingHelp                  URL_Head"/szweb/guide/useGuide.jsp" // 이용안내



#define URL_getEmailFolerInfo               URL_Head"/sz/email/EmailController/getEmailFolerInfo.do" //메일폴더 조회 서비스
#define URL_getEmailInfoList                URL_Head"/sz/email/EmailController/getEmailInfoList.do" //메일리스트 조회 서비스
#define URL_getEmailInfo                    URL_Head"/sz/email/EmailController/getEmailInfo.do" //메일리스트 조회 서비스
#define URL_sendEmailInfo                   URL_Head"/sz/email/EmailController/sendEmailInfo.do"
#define URL_deleteEmailInfo                 URL_Head"/sz/email/EmailController/deleteEmailInfo.do"

#define URL_updateUnreadEmailInfo           URL_Head"/sz/email/EmailController/updateUnreadEmailInfo.do"
#define URL_createDraftEmailInfo            URL_Head"/sz/email/EmailController/createDraftEmailInfo.do"
#define URL_getBadgeCountInfo               URL_Head"/sz/email/EmailController/getBadgeCountInfo.do"
#define getEmailAttachmentInfo              URL_Head"/sz/email/EmailController/getEmailAttachmentInfo.do"//첨부메일 조회
#define forwardEmailInfo                    URL_Head"/sz/email/EmailController/forwardEmailInfo.do"//포워딩 메일 첨부
#define moveEmailInfo                       URL_Head"/sz/email/EmailController/moveEmailInfo.do"//포워딩 메일 첨부

#define getBoardListCollection              URL_Head"/sz/tong/TongController/getBoardListCollection.do"//	사용가능 게시판 조회
#define getBoardList                        URL_Head"/sz/tong/TongController/getBoardList.do"//게시판 목록조회
#define getBoardDetail                      URL_Head"/sz/tong/TongController/getBoardDetail.do"//게시물조회
#define getBoardDetailAttachedFileURL       URL_Head"/sz/tong/TongController/getBoardDetailAttachedFileURL.do"//포워딩 메일 첨부


// 새로 추가되는 서비스 (smartzone미사용)
#define URL_getPushUser                     URL_Head"/sz/auth/AuthController/getPushUser.do" // 푸시 설정 서비스
#define URL_getFAQAllBoardListEx            URL_Head"/sz/know/KnowController/getAllBoardList.do"
#define URL_getFAQBulletinsEx               URL_Head"/sz/know/KnowController/getBulletinsEx.do"
#define URL_getFAQBullFromBoardEx           URL_Head"/sz/know/KnowController/getBullFromBoardEx.do"
#define URL_insertFAQBull                   URL_Head"/sz/know/KnowController/insertBull.do"
#define URL_insertFAQBullReply              URL_Head"/sz/know/KnowController/insertBullReply.do"

#define URL_insertBullVote                  URL_Head"/sz/know/KnowController/insertBullVote.do"
#define URL_insertBullComment               URL_Head"/sz/know/KnowController/insertBullComment.do"
#define URL_deleteBullComment               URL_Head"/sz/know/KnowController/deleteBullComment.do"
#define URL_deleteBull                      URL_Head"/sz/know/KnowController/deleteBull.do"
#define URL_checkPass                       URL_Head"/sz/know/KnowController/checkPass.do"


