//
//  TFDefine.h
//  TFTest
//
//  Created by 닷넷나무에 사과열리다 on 11. 5. 2..
//  Copyright 2011 .NetTree. All rights reserved.
//
@class TFTestAppDelegate;

#define GET_APP_DELEGATE() (TFTestAppDelegate *)[[UIApplication sharedApplication] delegate]
#define TEST_APPLICATION 1

#define NAVIGATIONBAR_HEIGHT			44
#define NAVIGATIONBAR_HEIGHT_LANDSCAPE	32
#define TABBAR_HEIGHT					49
#define TABBAR_HEIGHT_LANDSCAPE			49

#define DegreesToRadians(theta)  (CGFloat)(theta  * M_PI / 180.0f)
#define RadiansToDegrees(radian) (CGFloat)(radian / M_PI * 180.0f)

#define TFNOTIFICATION_IMAGE_LOAD_COMPLETE	@"imageLoadComplete"
#define TFNOTIFICATION_IMAGE_SAVE_COMPLETE	@"imageSaveComplete"
#define TFNOTIFICATION_MOTION_SHAKE_ENDED	@"motionShakeEnded"

#define TFUIViewAnimationDuration	0.5

// 아래는 카루셀 용

#define NUMBER_OF_ICONS		9

#define BASE_RADIAN DegreesToRadians(270.0f)	// 첫번째 아이콘이 위치한 라디안 값

#define IMAGE_WIDTH			124					// 첫 아이콘의 넓이
#define IMAGE_HEIGHT		124					// 첫 아이콘의 높이
#define SECOND_IAMGE_RATE	0.55				// 첫 아이콘에 대비하여 두번째 아이콘의 사이즈
#define NEXT_IMAGE_RATE		0.85				// 두번재 아이콘 이후의 사이즈(현재 설정은 15%씩 줄어듬)
#define SECOND_POSITION_ANGLE 0.0				// 두번째 아이콘이 위치한 각도

#define CIRCLE_CENTER_X		160					// 원(또는 타원)의 중심점
#define CIRCLE_CENTER_Y		180					// 원(또는 타원)의 중심점
#define X_AXIS_SCALE		180.0				// 픽셀 단위 타원의 X축 크기(Y_AXIS_SCALE과 동일한 값으로 하면 원이 됨)
#define Y_AXIS_SCALE		60.0				// 픽셀 단위 타원의 Y축 크기(X_AXIS_SCALE과 동일한 값으로 하면 원이 됨)

#define COREANIMATION_DEFAULT_DURATION	0.25	