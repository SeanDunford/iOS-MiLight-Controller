//
// Created by Sean Dunford on 12/27/14.
// Copyright (c) 2014 Qgainz. All rights reserved.
//

#import "MilIghtController.h"
#import "MilightUDPSocket.h"

@implementation MilIghtController {

}
#define DEFAULT_HOST @"10.0.0.23" //This was the ip address for my miLight Controller. Yours will probably differ.
#define DEFAULT_PORT 8899 //This 'should' be the same for all miLight Controllers.

static NSString *host = DEFAULT_HOST;
static int port = DEFAULT_PORT;
static int DEFAULT_SLEEP_BETWEEN_MESSAGES = 100;
static int COMMAND_ALL_OFF = 0x41;
static int COMMAND_GROUP_1_OFF = 0x46;
static int COMMAND_GROUP_2_OFF = 0x48;
static int COMMAND_GROUP_3_OFF = 0x4A;
static int COMMAND_GROUP_4_OFF = 0x4C;
static int COMMAND_ALL_ON = 0x42;
static int COMMAND_GROUP_1_ON = 0x45;
static int COMMAND_GROUP_2_ON = 0x47;
static int COMMAND_GROUP_3_ON = 0x49;
static int COMMAND_GROUP_4_ON = 0x4B;
static int COMMAND_ALL_WHITE = 0xC2;
static int COMMAND_GROUP_1_WHITE = 0xC5;
static int COMMAND_GROUP_2_WHITE = 0xC7;
static int COMMAND_GROUP_3_WHITE = 0xC9;
static int COMMAND_GROUP_4_WHITE = 0xCB;
static int COMMAND_DISCO = 0x4D;
static int COMMAND_DISCO_FASTER = 0x44;
static int COMMAND_DISCO_SLOWER = 0x43;
static int COMMAND_COLOR = 0x40;
static int MAX_COLOR = 0xFF;
static int COMMAND_BRIGHTNESS = 0x4E;
static int MIN_BRIGHTNESS = 0x04;
static int MAX_BRIGHTNESS = 0x3B;



+ (int)port{
   return port;
}
+ (NSString *)host{
    return host;
}
+(void)setHost:(NSString *)str{
    host = str;
}
+(void)setPort:(int)i{
   port = i;
}
+(void)turnAllLightsOff{
    [self sendMsg:COMMAND_ALL_OFF];
}
+(void)turnAllLightsOn{
    [self sendMsg:COMMAND_ALL_ON];
}
+(void)turnOnGroup:(int)group{
   switch(group) {
       case 1: [self sendMsg:(COMMAND_GROUP_1_ON)]; break;
       case 2: [self sendMsg:(COMMAND_GROUP_2_ON)]; break;
       case 3: [self sendMsg:(COMMAND_GROUP_3_ON)]; break;
       default: [self sendMsg:(COMMAND_GROUP_4_ON)]; break;
   }
}
+(void)turnOffGroup:(int)group{
    switch(group) {
        case 1: [self sendMsg:(COMMAND_GROUP_1_OFF)]; break;
        case 2: [self sendMsg:(COMMAND_GROUP_2_OFF)]; break;
        case 3: [self sendMsg:(COMMAND_GROUP_3_OFF)]; break;
        default: [self sendMsg:(COMMAND_GROUP_4_OFF)]; break;
    }
}
+(void)makeAllBulbsWhite{
    NSArray *msgs = @[
        [self msgToNSData:COMMAND_ALL_ON],
        [self msgToNSData:COMMAND_ALL_WHITE]
    ];
    [self sendMessagesInSeries:msgs];
}

+(void)setDisoMode{
    [self sendMsg:COMMAND_DISCO];
}
+(void)speedUpDisco{
    [self sendMsg:COMMAND_DISCO_FASTER];
}
+(void)slowDownDisco{
    [self sendMsg:COMMAND_DISCO_SLOWER];
}
+(void)changeBrightness:(int)val{
    if(val < 0 || val > MAX_BRIGHTNESS) {
        val = MAX_BRIGHTNESS;
    }
    [self sendMsg1:COMMAND_BRIGHTNESS Msg2:val];
}
+(void)randomColor{
    int val = arc4random_uniform(MAX_COLOR + 1);
    [self sendMsg1:COMMAND_COLOR Msg2:val];
}
+(void)changeColor:(int)val{
    if(val < 0 || val > MAX_COLOR) {
        val = MAX_COLOR;
    }
    [self sendMsg1:COMMAND_COLOR Msg2:val];
}
+(void)makeBulbBlue{
    NSArray *msgs = @[
            [self msgToNSData:COMMAND_ALL_ON],
            [self msg1ToNSData:COMMAND_BRIGHTNESS msg2:MAX_BRIGHTNESS], 
            [self msg1ToNSData:COMMAND_COLOR msg2:COLOR_BLUE]
    ];
    [self sendMessagesInSeries:msgs];
}
+(void)flashBlue{
    NSArray *msgs = @[
        [self msgToNSData:COMMAND_ALL_ON],
        [self msg1ToNSData:COMMAND_COLOR msg2:COLOR_BLUE],
        [self msg1ToNSData:COMMAND_BRIGHTNESS msg2:MAX_BRIGHTNESS], //count 0
        [self msg1ToNSData:COMMAND_BRIGHTNESS msg2:MIN_BRIGHTNESS],
        [self msg1ToNSData:COMMAND_BRIGHTNESS msg2:(MAX_BRIGHTNESS)], //count 1
        [self msg1ToNSData:COMMAND_BRIGHTNESS msg2:MIN_BRIGHTNESS],
        [self msg1ToNSData:COMMAND_BRIGHTNESS msg2:(MAX_BRIGHTNESS)], //count 2
        [self msg1ToNSData:COMMAND_BRIGHTNESS msg2:MIN_BRIGHTNESS],
        [self msg1ToNSData:COMMAND_BRIGHTNESS msg2:(MAX_BRIGHTNESS)], //count 3
        [self msg1ToNSData:COMMAND_BRIGHTNESS msg2:MIN_BRIGHTNESS],
        [self msg1ToNSData:COMMAND_BRIGHTNESS msg2:(MAX_BRIGHTNESS)], //count 4
        [self msg1ToNSData:COMMAND_BRIGHTNESS msg2:MIN_BRIGHTNESS],
        [self msg1ToNSData:COMMAND_BRIGHTNESS msg2:(MAX_BRIGHTNESS)], //count 5
        [self msg1ToNSData:COMMAND_BRIGHTNESS msg2:MIN_BRIGHTNESS],
        [self msg1ToNSData:COMMAND_BRIGHTNESS msg2:(MAX_BRIGHTNESS)], //count 6
        [self msg1ToNSData:COMMAND_BRIGHTNESS msg2:MIN_BRIGHTNESS],
        [self msg1ToNSData:COMMAND_BRIGHTNESS msg2:(MAX_BRIGHTNESS)], //count 7
        [self msg1ToNSData:COMMAND_BRIGHTNESS msg2:MIN_BRIGHTNESS],
        [self msg1ToNSData:COMMAND_BRIGHTNESS msg2:(MAX_BRIGHTNESS)], //count 8
        [self msg1ToNSData:COMMAND_BRIGHTNESS msg2:MIN_BRIGHTNESS],
        [self msg1ToNSData:COMMAND_BRIGHTNESS msg2:(MAX_BRIGHTNESS)], //count 9
        [self msg1ToNSData:COMMAND_BRIGHTNESS msg2:MIN_BRIGHTNESS],
        [self msg1ToNSData:COMMAND_BRIGHTNESS msg2:(MAX_BRIGHTNESS)], //count 10
        [self msg1ToNSData:COMMAND_BRIGHTNESS msg2:MIN_BRIGHTNESS],
        [self msg1ToNSData:COMMAND_BRIGHTNESS msg2:(MAX_BRIGHTNESS)], //count 11
    ];
    [self sendMessagesInSeries:msgs];
}
+(void)dimLight{
    [self sendData:[self msg1ToNSData:COMMAND_BRIGHTNESS msg2:0]];
}
+(void)makeBublBright{
    [self sendData:[self msg1ToNSData:COMMAND_BRIGHTNESS msg2:(MAX_BRIGHTNESS)]];
}
+(void)makeBulbWhite{
    [self makeAllBulbsWhite];
}
+(NSData *)msgToNSData:(int)msg{
    const unsigned char array[] = {msg, 0x55 & 0x00, 0x55 & 0x55};
    return [NSData dataWithBytes:array length:sizeof(array)];
}
+(NSData *)msg1ToNSData:(int)msg1 msg2:(int)msg2{
    const unsigned char array[] = {msg1, msg2, 0x55 & 0x55};
    return [NSData dataWithBytes:array length:sizeof(array)];
}
+(void)sendMsg:(int)msg{
    [self sendData:[self msgToNSData:msg]];
}
+(void)sendMsg1:(int)msg1 Msg2:(int)msg2{
    [self sendData:[self msg1ToNSData:msg1 msg2:msg2]];
}
+(void)sendMessagesInSeries:(NSArray *)messages{
    //TODO find a way to block/ or something
    //TODO: find a way to expose this and allow cusotom message blocks to be sent
    [self.udpsocket sendDataInSeries:messages.mutableCopy];
}
+(void)sendData:(NSData *)data{
    [self.udpsocket sendData:data];
}
static MilightUDPSocket *udpsocket;
+(MilightUDPSocket *)udpsocket{
    if(!udpsocket){
        udpsocket = [[MilightUDPSocket alloc] init];
        [udpsocket setHost:host];
        [udpsocket setPort:port];
    }
   return udpsocket;
}
@end