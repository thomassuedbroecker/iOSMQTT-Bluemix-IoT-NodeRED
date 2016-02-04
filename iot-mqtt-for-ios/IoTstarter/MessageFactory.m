/*
 Licensed Materials - Property of IBM
 
 © Copyright IBM Corporation 2014,2015. All Rights Reserved.
 
 This licensed material is sample code intended to aid the licensee in the development of software for the Apple iOS and OS X platforms . This sample code is  provided only for education purposes and any use of this sample code to develop software requires the licensee obtain and comply with the license terms for the appropriate Apple SDK (Developer or Enterprise edition).  Subject to the previous conditions, the licensee may use, copy, and modify the sample code in any form without payment to IBM for the purposes of developing software for the Apple iOS and OS X platforms.
 
 Notwithstanding anything to the contrary, IBM PROVIDES THE SAMPLE SOURCE CODE ON AN "AS IS" BASIS AND IBM DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, ANY IMPLIED WARRANTIES OR CONDITIONS OF MERCHANTABILITY, SATISFACTORY QUALITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND ANY WARRANTY OR CONDITION OF NON-INFRINGEMENT. IBM SHALL NOT BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY OR ECONOMIC CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR OPERATION OF THE SAMPLE SOURCE CODE. IBM SHALL NOT BE LIABLE FOR LOSS OF, OR DAMAGE TO, DATA, OR FOR LOST PROFITS, BUSINESS REVENUE, GOODWILL, OR ANTICIPATED SAVINGS. IBM HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS OR MODIFICATIONS TO THE SAMPLE SOURCE CODE.
 */

//
//  MessageFactory.m
//  IoTstarter
//

#import "AppDelegate.h"
#import "MessageFactory.h"
#import "Constants.h"

/**
 */

@implementation MessageFactory

/** 
 *  @param
 *  @return messageString
 */
+ (NSString *)createAccelMessage:(double)accel_x
                         accel_y:(double)accel_y
                         accel_z:(double)accel_z
                            roll:(double)roll
                           pitch:(double)pitch
                             yaw:(double)yaw
                             lat:(double)lat
                             lon:(double)lon
{
    NSDictionary *messageDictionary = @{
                                        @"d": @{
                                                JSON_ACCEL_X: @(accel_x),
                                                JSON_ACCEL_Y: @(accel_y),
                                                JSON_ACCEL_Z: @(accel_z),
                                                JSON_ROLL: @(roll),
                                                JSON_PITCH: @(pitch),
                                                JSON_YAW: @(yaw),
                                                JSON_LAT: @(lat),
                                                JSON_LON: @(lon)
                                                }
    };
    
    NSError *error;
    NSData *messageData = [NSJSONSerialization dataWithJSONObject:messageDictionary options:0 error:&error];
    
    NSString *messageString = [[NSString alloc] initWithData:messageData encoding:NSUTF8StringEncoding];
    return messageString;
}

+ (NSString *)createTouchmoveMessage:(double)screen_x
                            screen_y:(double)screen_y
                             delta_x:(double)delta_x
                             delta_y:(double)delta_y
                               ended:(int)ended
{
    NSDictionary *messageDictionary = @{
                                        @"d": @{
                                                JSON_SCREEN_X: @(screen_x),
                                                JSON_SCREEN_Y: @(screen_y),
                                                JSON_DELTA_X: @(delta_x),
                                                JSON_DELTA_Y: @(delta_y),
                                                JSON_ENDED: @(ended)
                                                }
                                        };
    
    NSError *error;
    NSData *messageData = [NSJSONSerialization dataWithJSONObject:messageDictionary options:0 error:&error];
    
    NSString *messageString = [[NSString alloc] initWithData:messageData encoding:NSUTF8StringEncoding];
    return messageString;
}
// ----------------------
// Build Message for IoT
// ----------------------
+ (NSString *)createTextMessage:(NSString *)text
{
    NSDictionary *messageDictionary = @{
                                        @"d": @{
                                                JSON_TEXT: text
                                                }
                                        };
    
    NSError *error;
    NSData *messageData = [NSJSONSerialization dataWithJSONObject:messageDictionary options:0 error:&error];
    
    NSString *messageString = [[NSString alloc] initWithData:messageData encoding:NSUTF8StringEncoding];
    return messageString;
}

// ----------------------
// Build Message for IoT
// Custom build message
// ----------------------
+ (NSString *)createFakeSensorMessage:(NSString *)temp :(NSString *)light :(NSString *)am_temp
{
    NSDictionary *messageDictionary = @{
                                        @"d": @{
                                                JSON_TEMP: temp,
                                                JSON_LIGHT: light,
                                                JSON_AM_TEMP: am_temp
                                                }
                                        };
    
    NSError *error;
    NSData *messageData = [NSJSONSerialization dataWithJSONObject:messageDictionary options:0 error:&error];
    NSLog(@"-->> createFakeSensorMessag --> MessageData: %@", messageData.debugDescription);

    NSString *messageString = [[NSString alloc] initWithData:messageData encoding:NSUTF8StringEncoding];
    NSLog(@"-->> createFakeSensorMessag --> messageString: %@ error: %@", messageString , error);
    
    return messageString;
}

+ (NSString *)createGamepadMessage:(NSString *)button
{
    NSDictionary *messageDictionary = @{
                                        @"d": @{
                                                JSON_BUTTON: button
                                                }
                                        };
    
    NSError *error;
    NSData *messageData = [NSJSONSerialization dataWithJSONObject:messageDictionary options:0 error:&error];
    
    NSString *messageString = [[NSString alloc] initWithData:messageData encoding:NSUTF8StringEncoding];
    return messageString;
}

+ (NSString *)createGamepadMessage:(NSString *)button
                            dpad_x:(double)dpad_x
                            dpad_y:(double)dpad_y
{
    NSDictionary *messageDictionary = @{
                                        @"d": @{
                                                JSON_BUTTON: button,
                                                JSON_DPAD_X: @(dpad_x),
                                                JSON_DPAD_Y: @(dpad_y)
                                                }
                                        };
    
    NSError *error;
    NSData *messageData = [NSJSONSerialization dataWithJSONObject:messageDictionary options:0 error:&error];
    
    NSString *messageString = [[NSString alloc] initWithData:messageData encoding:NSUTF8StringEncoding];
    return messageString;
}

@end