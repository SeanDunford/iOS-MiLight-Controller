//
// Created by Sean Dunford on 12/27/14.
// Copyright (c) 2014 Qgainz. All rights reserved.
//

#import <Foundation/Foundation.h>

//List: Predefinied COlors
static int COLOR_BLUE = 0x00;
static int COLOR_AQUA = 50;
static int COLOR_GREEN = 100;
static int COLOR_YELLOW = 130;
static int COLOR_ORANGE = 150;
static int COLOR_RED = 170;
static int COLOR_PINK = 180;
static int COLOR_HOT_PINK = 200;
static int COLOR_PURPLE = 225;

@interface MilIghtController : NSObject
+ (int)port;
+ (NSString *)host;
+ (void)setHost:(NSString *)host;
+ (void)turnAllLightsOff;
+ (void)turnAllLightsOn;
+ (void)turnOnGroup:(int)group;
+ (void)turnOffGroup:(int)group;
+ (void)makeAllBulbsWhite;
+ (void)setDisoMode;
+ (void)speedUpDisco;
+ (void)slowDownDisco;
+ (void)changeBrightness:(int)val;
+ (void)changeColor:(int)val;
+ (void)randomColor;
+(void)makeBulbBlue;
+(void)makeBulbWhite;
+(void)dimLight;
+(void)makeBublBright;
+(void)flashBlue; 
@end