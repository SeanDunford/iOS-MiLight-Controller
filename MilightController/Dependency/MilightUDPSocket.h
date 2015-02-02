//
// Created by Sean Dunford on 12/26/14.
// Copyright (c) 2014 Qgainz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncUdpSocket.h"

@interface MilightUDPSocket : NSObject <AsyncUdpSocketDelegate>
@property(nonatomic, strong) NSString *host;
@property(nonatomic, assign) int port;
-(void)sendMsg:(NSString *)str;
-(void)sendData:(NSData *)data;
-(void)sendDataInSeries:(NSMutableArray *)arr;
@end