/*
 Licensed Materials - Property of IBM
 
 © Copyright IBM Corporation 2014,2015. All Rights Reserved.
 
 This licensed material is sample code intended to aid the licensee in the development of software for the Apple iOS and OS X platforms . This sample code is  provided only for education purposes and any use of this sample code to develop software requires the licensee obtain and comply with the license terms for the appropriate Apple SDK (Developer or Enterprise edition).  Subject to the previous conditions, the licensee may use, copy, and modify the sample code in any form without payment to IBM for the purposes of developing software for the Apple iOS and OS X platforms.
 
 Notwithstanding anything to the contrary, IBM PROVIDES THE SAMPLE SOURCE CODE ON AN "AS IS" BASIS AND IBM DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, ANY IMPLIED WARRANTIES OR CONDITIONS OF MERCHANTABILITY, SATISFACTORY QUALITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND ANY WARRANTY OR CONDITION OF NON-INFRINGEMENT. IBM SHALL NOT BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY OR ECONOMIC CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR OPERATION OF THE SAMPLE SOURCE CODE. IBM SHALL NOT BE LIABLE FOR LOSS OF, OR DAMAGE TO, DATA, OR FOR LOST PROFITS, BUSINESS REVENUE, GOODWILL, OR ANTICIPATED SAVINGS. IBM HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS OR MODIFICATIONS TO THE SAMPLE SOURCE CODE.
 */

//
//  AppDelegate.h
//  IoTstarter
//

#ifndef AppDelegate_h
#define AppDelegate_h

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>
#import "Constants.h"
#import "Messenger.h"
#import "IoTProfile.h"
#import "LoginViewController.h"
#import "IoTStarterViewController.h"
#import "LogTableViewController.h"
//#import "RemoteViewController.h"
#import "ProfilesTableViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
//#define USE_LOCAL_NOTIFICATIONS

// UI views
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabController;
@property (strong, nonatomic) LoginViewController *loginViewController;
@property (strong, nonatomic) IoTStarterViewController *iotViewController;
@property (strong, nonatomic) LogTableViewController *logTableViewController;
//@property (strong, nonatomic) RemoteViewController *remoteViewController;
@property (strong, nonatomic) ProfilesTableViewController *profileTableController;

@property (nonatomic) UIApplicationState appState;

@property (nonatomic) views currentView;

// IoT properties settable by user
//@property (strong, nonatomic) NSMutableDictionary *profiles;
@property (strong, nonatomic) NSMutableArray *profiles;
@property (strong, nonatomic) IoTProfile *currentProfile;
@property (strong, nonatomic) NSString *organization;
@property (strong, nonatomic) NSString *deviceID;
@property (strong, nonatomic) NSString *authToken;

@property (nonatomic) CONNECTION_TYPE connectionType;

// Device specific properties
@property (nonatomic) BOOL isConnected;

// Total number of messages the app has published and received
@property NSInteger publishCount;
@property NSInteger receiveCount;

// Accelerometer related properties
@property (nonatomic) BOOL isAccelEnabled;
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property CLLocation* latestLocation;
@property CMAcceleration latestAcceleration;
@property CMRotationRate latestRotation;
@property double latestRoll;
@property double latestPitch;
@property double latestYaw;
@property double sensorFrequency;
@property (strong, nonatomic) NSTimer* deviceTimer;

#ifdef USE_LOCAL_NOTIFICATIONS
// Background task for continuing to run application while in background
@property (nonatomic) UIBackgroundTaskIdentifier bgTask;
#endif

// Current color value
@property (strong, nonatomic) UIColor *color;

// For toggle light messages
@property (strong, nonatomic) AVCaptureSession *session;

// Store received "text" command messages for log view
@property (strong, nonatomic) NSMutableArray *messageLog;

- (void)storePropertiesToArchive;

- (void)switchToLoginView;
- (void)switchToIoTView;
- (void)switchToLogView;
//- (void)switchToRemoteView;

- (void)startMotionManager;
- (void)stopMotionManager;

- (void)publishData:(NSString *)message event:(NSString *)event;

- (void)updateViewLabelsAndButtons;

/** Callbacks for responses to events */

/** Update background color when a color command message is received */
- (void)updateColor:(UIColor *)color;

/** Turn the device torch on or off when a light command message is received */
- (void)toggleLight;

/** Add text command messages to the log view */
- (void)addLogMessage:(NSString *)textValue;

@end

#endif
