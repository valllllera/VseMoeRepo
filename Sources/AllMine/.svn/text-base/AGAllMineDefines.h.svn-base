//
//  AGAllMineDefines.h
//  AllMine
//
//  Created by Allgoritm LLC on 31.10.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#ifndef AllMine_AGAllMineDefines_h
#define AllMine_AGAllMineDefines_h

#ifdef DEBUG
#define AGLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define AGLog(format, ...)
#endif

#define kRoot (AGRootController*)(((AGAppDelegate*)[[UIApplication sharedApplication] delegate]).rootController)
#define kUser (User*)((kRoot).currentUser)

#define kFont1  @"LucidaGrande-Bold"
#define kFont2  @"HeliosCondBlack"

#define kColorHexNavigationBar 0xcccccc

#define kColorHexBlack  0x000000
#define kColorHexWhite  0xffffff
#define kColorHexBrown  0x808082
#define kColorHexGray   0xb3b4b6
#define kColorHexDarkGray 0xa0a0a0
#define kColorHexBlue   0x4c566d
#define kColorHexGreen  0x6b7e00
#define kColorHexOrange 0xff7700
#define kColorHexMarine 0x7fc2c5
#define kColorHexMarineDark 0x09c2c5

#define kColorHexPaymentResult 0xd4e8ed

#define kColorHexHeader 0x6f929f

#define kColorHexPlotGreen  0x288e93
#define kColorHexPlotSelectGreen 0xB1D8D9
#define kColorHexPlotOrange 0xff7700

#define kColorHexPlotSegment 0xe0e0df
#define kColorHexPlotSegmentSelected 0xb5b6b5

#define kColorHexSwitchOn 0x3b7f8c

#define kColorHexPlotSegmentText 0x4c566d

#define kColorHexPaymentEditText 0xa9aebd
#define kColorHexPaymentEditTextHighlighted 0x6e6e70

#define kColorHexSettingsCurrencyMarine 0x3b7f8c

#define kSum @"sum"
#define kCategory @"category"

#define kEventAGKeyboardWillShow    @"AGKeyboardWillShow"
#define kEventAGKeyboardWillHide    @"AGKeyboardWillHide"
#define kEventUIPickerWillShow      @"UIPickerWillShow"
#define kEventUIPickerWillHide      @"UIPickerWillHide"
#define kEventUIDatePickerWillShow  @"UIDatePickerWillShow"
#define kEventUIDatePickerWillHide  @"UIDatePickerWillHide"
#define kEventSyncFinished          @"eventSyncFinished"

#define kNavigationBarVerticalOffsetStandart 6
#define kNavigationBarVerticalOffsetZero 0

#define kExceptionSyncFailed    @"SyncFailed"

#define kSlideAnimationTime 0.2f

#define kUDLastLoginDate    @"lastLoginDate"
#define kUDLastLogin        @"lastLogin"
#define kUDFirstLoad        @"firstLoad"
#define kUDSyncLastDate     @"syncLastDate"

#define kReportFieldSum     @"sum"
#define kReportFieldTitle   @"title"
#define kReportFieldObject  @"object"

#define kTableHeaderStandardHeight 30.0f
#define kTableCellStandardHeight 60.0f

#define isIphone [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone
#define isIphoneRetina4 ((isIphone)&&([[UIScreen mainScreen] bounds].size.height * [[UIScreen mainScreen] scale] >= 1136))

#define AGIphoneName(aName) \
            isIphoneRetina4 ? [NSString stringWithFormat:@"%@-568h", aName] : aName

#endif
