/*
 Licensed Materials - Property of IBM
 
 © Copyright IBM Corporation 2014,2015. All Rights Reserved.
 
 This licensed material is sample code intended to aid the licensee in the development of software for the Apple iOS and OS X platforms . This sample code is  provided only for education purposes and any use of this sample code to develop software requires the licensee obtain and comply with the license terms for the appropriate Apple SDK (Developer or Enterprise edition).  Subject to the previous conditions, the licensee may use, copy, and modify the sample code in any form without payment to IBM for the purposes of developing software for the Apple iOS and OS X platforms.
 
 Notwithstanding anything to the contrary, IBM PROVIDES THE SAMPLE SOURCE CODE ON AN "AS IS" BASIS AND IBM DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, ANY IMPLIED WARRANTIES OR CONDITIONS OF MERCHANTABILITY, SATISFACTORY QUALITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND ANY WARRANTY OR CONDITION OF NON-INFRINGEMENT. IBM SHALL NOT BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY OR ECONOMIC CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR OPERATION OF THE SAMPLE SOURCE CODE. IBM SHALL NOT BE LIABLE FOR LOSS OF, OR DAMAGE TO, DATA, OR FOR LOST PROFITS, BUSINESS REVENUE, GOODWILL, OR ANTICIPATED SAVINGS. IBM HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS OR MODIFICATIONS TO THE SAMPLE SOURCE CODE.
 */

//
//  TopicFactory.m
//  IoTstarter
//

#import "AppDelegate.h"
#import "TopicFactory.h"
#import "Constants.h"

/** Use this if it turns out I have a decent number of topics to publish to
 * or subscribe from
 */

@implementation TopicFactory

/** Retrieve the event topic string for a specific event type.
 *  @param event The event type to get the topic string for
 *  @return topicString The event topic string for event
 */
+ (NSString *)getEventTopic:(NSString *)event
{
    NSString *topicString = [NSString stringWithFormat:IOTEventTopic, event, @"json"];
    return topicString;
}

/** Retrieve the command topic string for a specific command type.
 *  @param command The command type to get the topic string for
 *  @return topicString The command topic string for command
 */
+ (NSString *)getCommandTopic:(NSString *)command
{
    NSString *topicString = [NSString stringWithFormat:IOTCommandTopic, command, @"json"];
    return topicString;
}

/** Retrieve the event topic string for a specific event type. Use m2m demo format instead
 *  of IoT format.
 *  @param event The event type to get the topic string for
 *  @return topicString The event topic string for event
 */
+ (NSString *)getM2MEventTopic:(NSString *)event
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSString *topicString = [NSString stringWithFormat:IOTM2MEventTopic, appDelegate.deviceID, event];
    return topicString;
}

@end
