//
// Created by Sean Dunford on 12/26/14.
// Copyright (c) 2014 Qgainz. All rights reserved.
//

#import "MilightUDPSocket.h"
#import <Foundation/Foundation.h>
#import <sys/socket.h>

#define DEFAULT_HOST @"127.0.0.2"
#define DEFAULT_PORT 9001

@interface MilightUDPSocket ()
@end
@implementation MilightUDPSocket {
    NSMutableArray *tasks;
    NSTimer *timer;
    NSMutableArray *dataArr;
}
-(id)init{
    if((self = [super init])){
        dataArr = @[].mutableCopy;
    }
    return self;
}
-(void)dealloc{
    [timer invalidate];
}
-(void)timerTick{
    if(dataArr.count < 1){
        return;
    }
    NSData *data = [dataArr lastObject];
    [dataArr removeLastObject];

    [self sendData:data];
}
-(NSString*)host{
    if(!_host){
        _host = DEFAULT_HOST;
    }
   return _host;
}
-(int)port{
    if(!_port){
        _port = DEFAULT_PORT;
    }
    return _port;
}
-(void)sendMsg:(NSString *)str{
    if(!str || !str.length){
       str = @"yolo";
    }
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self sendData:data];
}
-(void)sendData:(NSData *)data {
    float ms = 5000;
    long tag = 1234;
    [self.socket sendData:data toHost:self.host port:self.port withTimeout:ms tag:tag];
}
-(void)sendDataInSeries:(NSMutableArray *)arr{
    float tI = 500;
    for(int i = 0; i < arr.count; i++){
        if(![arr[i] isKindOfClass:[NSData class]]){
            return [NSException raise:@"Expected NSData" format:@"Expected NSData to send in UDP socket"];
        }
        NSData* data = arr[i];
        [dataArr insertObject:data atIndex:0];
    }
    if(!timer){
        timer = [NSTimer scheduledTimerWithTimeInterval:2
                                                 target:self
                                               selector:@selector(timerTick)
                                               userInfo:nil
                                                repeats:true];
    }
}
-(AsyncUdpSocket *)socket{
    static AsyncUdpSocket *socket;
    if(!socket){
        socket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    }
    return socket;
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
    NSLog(@"did send data");
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error {
    NSLog(@"did not send data");
}

- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port {
    NSLog(@"did receive data");
    return NO;
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error {
    NSLog(@"did not receive data");
}

- (void)onUdpSocketDidClose:(AsyncUdpSocket *)sock {
    NSLog(@"socket closed");
}

@end