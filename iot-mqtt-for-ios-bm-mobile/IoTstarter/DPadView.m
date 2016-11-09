/*
 Licensed Materials - Property of IBM
 
 © Copyright IBM Corporation 2014,2015. All Rights Reserved.
 
 This licensed material is sample code intended to aid the licensee in the development of software for the Apple iOS and OS X platforms . This sample code is  provided only for education purposes and any use of this sample code to develop software requires the licensee obtain and comply with the license terms for the appropriate Apple SDK (Developer or Enterprise edition).  Subject to the previous conditions, the licensee may use, copy, and modify the sample code in any form without payment to IBM for the purposes of developing software for the Apple iOS and OS X platforms.
 
 Notwithstanding anything to the contrary, IBM PROVIDES THE SAMPLE SOURCE CODE ON AN "AS IS" BASIS AND IBM DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, ANY IMPLIED WARRANTIES OR CONDITIONS OF MERCHANTABILITY, SATISFACTORY QUALITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND ANY WARRANTY OR CONDITION OF NON-INFRINGEMENT. IBM SHALL NOT BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY OR ECONOMIC CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR OPERATION OF THE SAMPLE SOURCE CODE. IBM SHALL NOT BE LIABLE FOR LOSS OF, OR DAMAGE TO, DATA, OR FOR LOST PROFITS, BUSINESS REVENUE, GOODWILL, OR ANTICIPATED SAVINGS. IBM HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS OR MODIFICATIONS TO THE SAMPLE SOURCE CODE.
 */

//
//  DPadView.m
//  IoTstarter
//

#import "DPadView.h"
#import "Messenger.h"

@interface DPadView ()
@end

@implementation DPadView
{
    UIBezierPath *path;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // Initialization code
        path = [UIBezierPath bezierPath];
        [path setLineWidth:2.0];
        //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        //[appDelegate.remoteViewController setDpad:self];
    }
    return self;
}

/** Respond to the initial event for a user touching the screen.
 *  This does not send a message, but initializes the previous X and Y values
 *  to be used in touchesMoved.
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s:%d entered", __func__, __LINE__);
    UITouch *touch = [touches anyObject];
    [path moveToPoint:[touch locationInView:self]];
    //NSLog(@"start x: %f, start y: %f", self.previousX, self.previousY);
}

/** Respond to incoming events as a user is touching the screen.
 *  Publish a message for each event.
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self publishTouchMove:touches ended:NO];
}

/** Respond to the final event for a user touching the screen.
 *  Publish a message with the ended flag set to true indicating
 *  the final message of the touch.
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s:%d entered", __func__, __LINE__);
    [self publishTouchMove:touches ended:YES];
    [path removeAllPoints];
}

/** Publish the touchmove message. The message contains the current x,y coordinates,
 *  as well as the delta values between the current and previous coordinates.
 *  @param touches The set of touch events so far.
 *  @param ended Indicates whether this is the final message of the touch.
 */
- (void)publishTouchMove:(NSSet *)touches ended:(BOOL)ended
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    Messenger *messenger = [Messenger sharedMessenger];
    if (messenger.client.isConnected == NO)
    {
        NSLog(@"Mqtt Client not connected. Swipes will be ignored");
        return;
    }
    
    UITouch *touch = [touches anyObject];
    [path addLineToPoint:[touch locationInView:self]];
    [self setNeedsDisplay];
    float endX = [touch locationInView:self].x;
    float endY = [touch locationInView:self].y;
    
    CGRect frame = self.frame;
    float leftX = frame.size.width / 2;
    float topY = frame.size.height / 2;
    
    CGPoint center = CGPointMake(leftX, topY);
    CGPoint location = CGPointMake(endX, endY);
    
    float deltaX = fabsf((location.x - center.x)/center.x);
    float deltaY = fabsf((location.y - center.y)/center.y);
    
    NSString *directionString;
    float angleInDegrees = atan2f(deltaY, deltaX) * 180 / M_PI;
    NSLog(@"angle: %f", angleInDegrees);
    
    if (endX < leftX && endY < topY)
    {
        NSLog(@"D-L"); // (-90) - (-180)
        directionString = @"DOWN-LEFT";
    }
    else if (endX > leftX && endY < topY)
    {
        NSLog(@"U-L"); // 0 - (-90)
        directionString = @"UP-LEFT";
    }
    else if (endX < leftX && endY > topY)
    {
        NSLog(@"D-R"); // 90 - 180
        directionString = @"DOWN-RIGHT";
    }
    else if (endX > leftX && endY > topY)
    {
        NSLog(@"U-R"); // 0 - 90
        directionString = @"UP-RIGHT";
    }
    
    NSString *messageData = [MessageFactory createGamepadMessage:directionString
                                                          dpad_x:deltaX
                                                          dpad_y:deltaY];
    
    [appDelegate publishData:messageData event:IOTGamepadEvent];
}

/** Respond to the event of a touch being cancelled.
 */
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s:%d entered", __func__, __LINE__);
}

@end
