/*
 Licensed Materials - Property of IBM
 
 © Copyright IBM Corporation 2014,2015. All Rights Reserved.
 
 This licensed material is sample code intended to aid the licensee in the development of software for the Apple iOS and OS X platforms . This sample code is  provided only for education purposes and any use of this sample code to develop software requires the licensee obtain and comply with the license terms for the appropriate Apple SDK (Developer or Enterprise edition).  Subject to the previous conditions, the licensee may use, copy, and modify the sample code in any form without payment to IBM for the purposes of developing software for the Apple iOS and OS X platforms.
 
 Notwithstanding anything to the contrary, IBM PROVIDES THE SAMPLE SOURCE CODE ON AN "AS IS" BASIS AND IBM DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, ANY IMPLIED WARRANTIES OR CONDITIONS OF MERCHANTABILITY, SATISFACTORY QUALITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND ANY WARRANTY OR CONDITION OF NON-INFRINGEMENT. IBM SHALL NOT BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY OR ECONOMIC CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR OPERATION OF THE SAMPLE SOURCE CODE. IBM SHALL NOT BE LIABLE FOR LOSS OF, OR DAMAGE TO, DATA, OR FOR LOST PROFITS, BUSINESS REVENUE, GOODWILL, OR ANTICIPATED SAVINGS. IBM HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS OR MODIFICATIONS TO THE SAMPLE SOURCE CODE.
 */

//
//  AppDelegate.m
//  IoTstarter
//

#import "AppDelegate.h"

@implementation AppDelegate

/** Load persistent data from application archive file.
 *  < 1.3.0, persistent data will contain:
 *    - Organization
 *    - DeviceID
 *    - Auth Token
 *  > 1.3.0, persistent data will contain connection profiles:
 *    - NSMutableDictionary objects containing organization, deviceID, auth token, profile name
 *    - The key is the profile name
 *  @return dataDict An NSMutableDictionary object containing the retrieved properties
 */
- (NSMutableDictionary *)loadPropertiesFromArchive
{
    NSLog(@"%s:%d entered", __func__, __LINE__);
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = dirPaths[0];
    NSString *_dataFilePath = [[NSString alloc] initWithString:[docsDir stringByAppendingString:IOTArchiveFileName]];
    NSMutableDictionary *dataDict = nil;
    
    if ([filemgr fileExistsAtPath:_dataFilePath])
    {
        dataDict = [NSKeyedUnarchiver unarchiveObjectWithFile:_dataFilePath];
    }
    if ([dataDict isKindOfClass:[NSMutableArray class]])
    {
        return nil;
    }
    return dataDict;
}

/** Store persistent data to application archive file.
 *  Persistent data currently includes:
 *   Device ID
 *   Organization ID
 *   Auth Token
 */
- (void)storePropertiesToArchive
{
    NSLog(@"%s:%d entered", __func__, __LINE__);
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = dirPaths[0];
    NSString *_dataFilePath = [[NSString alloc] initWithString:[docsDir stringByAppendingString:IOTArchiveFileName]];
    
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    
    NSInteger profileCount = self.profiles.count;
    
    if (profileCount == 0)
    {
        // Create default profile with current settings if no profile exists
        IoTProfile *profile = [[IoTProfile alloc] initWithName:@"default" organization:self.organization deviceID:self.deviceID authorizationToken:self.authToken];
        self.currentProfile = profile;
        [self.profiles addObject:self.currentProfile];
        profileCount = self.profiles.count;
    }
    
    int index;
    for (index=0; index < profileCount; index++)
    {
        IoTProfile *profile = [self.profiles objectAtIndex:index];
        NSMutableDictionary *profileDictionary = [profile createDictionaryFromProfile];
        [dataDict setObject:profileDictionary forKey:profile.profileName];
    }
    
    // Store the name of the current profile so that we can reload the settings from
    // this profile automatically after restart.
    [dataDict setObject:[self.currentProfile profileName] forKey:@"iot:selectedprofile"];
    
    [NSKeyedArchiver archiveRootObject:dataDict toFile:_dataFilePath];
}

/** Populate settings based on properties loaded from archive.
 *  Compatibility - Create default profile if stored properties were deviceID, org, auth token.
 */
- (void)loadProfilesFromArchive
{
    // Load stored application data.
    NSMutableDictionary *data = [self loadPropertiesFromArchive];
    if (data != nil)
    {
        // The last selected profile is stored under key "iot:selectedprofile".
        // If this key exists, profileName will be the name of the last selected
        // profile.
        NSString *profileName;
        if ((profileName = [data objectForKey:@"iot:selectedprofile"]) == nil)
        {
            profileName = @"";
        }
        
        if ([data objectForKey:IOTDeviceID] != nil)
        {
            // Data from older app version -- no profile
            NSString *deviceID = [data objectForKey:IOTDeviceID];
            NSString *organization = [data objectForKey:IOTOrganization];
            NSString *authToken = [data objectForKey:IOTAuthToken];
            self.currentProfile = [[IoTProfile alloc] initWithName:@"default" organization:organization deviceID:deviceID authorizationToken:authToken];
            [self.profiles addObject:self.currentProfile];
            [self storePropertiesToArchive];
        }
        else
        {
            // Found profile data
            NSString *key;
            NSEnumerator *keys = [data keyEnumerator];
            while ((key = [keys nextObject]) != nil)
            {
                // Skip the selectedprofile property -- its just a string, not a profile.
                if ([key isEqualToString:@"iot:selectedprofile"])
                {
                    continue;
                }
                
                // Load the stored profile
                NSMutableDictionary *profileDictionary = [data objectForKey:key];
                IoTProfile *profile = [[IoTProfile alloc] initWithName:key dictionary:profileDictionary];
                [self.profiles addObject:profile];

                // If this profile matches the "iot:selectedprofile" value,
                // then set it to the current profile.
                if ([profileName isEqualToString:[profile profileName]])
                {
                    self.currentProfile = profile;
                }
            }
        }
        
        // Set the current application properties based on the last selected profile.
        if (self.currentProfile != nil)
        {
            self.authToken = [self.currentProfile authorizationToken];
            self.organization = [self.currentProfile organization];
            self.deviceID = [self.currentProfile deviceID];
        }
    }
}

/*- (void)fillOldTestProperties
{
    NSLog(@"%s:%d entered", __func__, __LINE__);
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = dirPaths[0];
    NSString *_dataFilePath = [[NSString alloc] initWithString:[docsDir stringByAppendingString:IOTArchiveFileName]];
    
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    
    [dataDict setObject:@"" forKey:@"organization"];
    [dataDict setObject:@"AB12CD34EF56" forKey:@"deviceid"];
    [dataDict setObject:@"" forKey:@"authtoken"];

    [NSKeyedArchiver archiveRootObject:dataDict toFile:_dataFilePath];
}*/

/** Initialize the application. Load stored settings. Set the appropriate
 *  storyboard.
 *  @return YES is returned in all cases
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"%s:%d entered", __func__, __LINE__);
    // Override point for customization after application launch.
    
    [[UILabel appearance] setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17.0]];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    // Initialize some application settings
    self.isConnected = NO;
    self.publishCount = 0;
    self.receiveCount = 0;
    self.isAccelEnabled = YES;
    self.sensorFrequency = IOTSensorFreqDefault;
    
    self.messageLog = [[NSMutableArray alloc] init];
    self.color = [UIColor colorWithRed:104 green:109 blue:115 alpha:1.0];
    
    self.profiles = [[NSMutableArray alloc] init];
    self.organization = @"";
    self.deviceID = @"";
    self.authToken = @"";
    
    //[self fillOldTestProperties];
    
    [self loadProfilesFromArchive];
    
    [self loadStoryboard];
    
#ifdef USE_LOCAL_NOTIFICATIONS
    // Prompt to allow user notifications.
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound categories:nil]];
    }
#endif
        
    return YES;
}

- (void)switchToLoginView
{
    [self.tabController setSelectedIndex:0];
}

- (void)switchToIoTView
{
    [self.tabController setSelectedIndex:1];
}

- (void)switchToLogView
{
    [self.tabController setSelectedIndex:2];
}

/*- (void)switchToRemoteView
{
    [self.tabController setSelectedIndex:3];
}*/

/** Enable the accelerometer and motion detector on the device.
 *  Interval for updates is 0.2 seconds.
 */
- (void)startMotionManager
{
    NSLog(@"%s:%d entered", __func__, __LINE__);
    if (!self.motionManager)
    {
        self.motionManager = [[CMMotionManager alloc] init];
    }
    self.motionManager.accelerometerUpdateInterval = self.sensorFrequency;
    self.motionManager.gyroUpdateInterval = self.sensorFrequency;
    
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                             withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
                                                 [self updateAccelerationData:accelerometerData.acceleration];
                                                 if(error)
                                                 {
                                                     
                                                     NSLog(@"%@", error);
                                                 }
                                             }];
    
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]
                                            withHandler:^(CMDeviceMotion *motionData, NSError *error) {
                                                [self updateAttitudeData:motionData.attitude.roll pitch:motionData.attitude.pitch yaw:motionData.attitude.yaw];
                                            }];
    
    if (!self.locationManager)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        if (IS_OS_8_OR_LATER) {
            //[self.locationManager requestAlwaysAuthorization];
            [self.locationManager requestWhenInUseAuthorization];
        }
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        [self.locationManager startUpdatingLocation];
    }
    
    if (self.deviceTimer)
    {
        [self.deviceTimer invalidate];
    }
    
    self.deviceTimer = [NSTimer scheduledTimerWithTimeInterval:self.sensorFrequency target:self selector:@selector(accelerometerTimerCallback) userInfo:nil repeats:YES];
}

/** Disable the accelerometer and motion detector.
 */
- (void)stopMotionManager
{
    NSLog(@"%s:%d entered", __func__, __LINE__);
    [self.motionManager stopAccelerometerUpdates];
    [self.motionManager stopDeviceMotionUpdates];
    [self.locationManager stopUpdatingLocation];
    
    if (self.deviceTimer)
    {
        [self.deviceTimer invalidate];
    }
}

- (void)updateAccelerationData:(CMAcceleration)acceleration
{
    NSLog(@"%s:%d entered", __func__, __LINE__);
    self.latestAcceleration = acceleration;
}

- (void)updateAttitudeData:(double)roll pitch:(double)pitch yaw:(double)yaw
{
    NSLog(@"%s:%d entered", __func__, __LINE__);
    self.latestRoll = roll;
    self.latestPitch = pitch;
    self.latestYaw = yaw;
}

/** Publish accelerometer data.
 */
- (void)accelerometerTimerCallback
{
    //NSLog(@"%s:%d entered", __func__, __LINE__);
    // TODO: More decimal places on attitude values
    NSString *messageData = [MessageFactory createAccelMessage:self.latestAcceleration.x
                                                       accel_y:self.latestAcceleration.y
                                                       accel_z:self.latestAcceleration.z
                                                          roll:self.latestRoll
                                                         pitch:self.latestPitch
                                                           yaw:self.latestYaw
                                                           lat:self.latestLocation.coordinate.latitude
                                                           lon:self.latestLocation.coordinate.longitude];
    
    [self.iotViewController updateAccelLabels];
    [self publishData:messageData event:IOTAccelEvent];
}

/** **************************************************************
 *  Publish an MQTT Message with data message for IoT Event event
 *  @param message The data to be sent
 *  @param event The event to publish the data to
 *
 *  **************************************************************
 *  
 *  Constants defined in utils/contstants 
 *  Sample: JSON_SENSORDATAVALUE, JSON_TEMP ...
 *
 *  The Constants are used to build JSON message to send to the IoT, is defined in utils/MessageFactory
 *  The message to the IoT will be send in the views/IoTStarterViewController
 *  
 *  **************************************************************
 */
- (void)publishData:(NSString *)message event:(NSString *)event
{
    NSLog(@"%s:%d entered", __func__, __LINE__);
    Messenger *messenger = [Messenger sharedMessenger];
    if (messenger.client.isConnected == NO)
    {
        NSLog(@"Mqtt Client not connected. Swipes will be ignored");
        return;
    }
    
    if (self.connectionType == QUICKSTART)
    {
        if ([event isEqualToString:IOTAccelEvent])
        {
            // Publish accel message as status event
            self.publishCount++;
            [self.iotViewController updateMessageCounts];
            [messenger publish:[TopicFactory getEventTopic:IOTStatusEvent] payload:message qos:0 retained:NO];
        }
        else
        {
            // If quickstart, only allow accel events to be published.
            return;
        }
    }
    else
    {
        // Publish the message on the desired event
        self.publishCount++;
        [self.iotViewController updateMessageCounts];
        if (self.connectionType == M2M)
        {
            [messenger publish:[TopicFactory getM2MEventTopic:event] payload:message qos:0 retained:NO];
        }
        else
        {
            [messenger publish:[TopicFactory getEventTopic:event] payload:message qos:0 retained:NO];
        }
    }
}

- (void)updateViewLabelsAndButtons
{
    NSLog(@"%s:%d entered", __func__, __LINE__);
    if (self.loginViewController != nil) {
        [self.loginViewController updateViewLabels];
    }
    if (self.iotViewController != nil) {
        [self.iotViewController updateViewLabels];
    }
}

/** Update the background color of the IoT view.
 *  @param color The color to update to.
 */
- (void)updateColor:(UIColor *)color
{
    NSLog(@"%s:%d entered", __func__, __LINE__);
    self.color = color;
    [self.iotViewController updateBackgroundColor:self.color];
}

/** Turn the device torch on or off. If no torch is present, display an alert saying so.
 */
- (void)toggleLight
{
    NSLog(@"%s:%d entered", __func__, __LINE__);
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device isTorchAvailable] == NO)
    {
        NSLog(@"Torch not available");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Torch not available" message:@"This feature is not supported on this device." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert setAlertViewStyle:UIAlertViewStyleDefault];
        [alert show];
        return;
    }
    if (device.torchMode == AVCaptureTorchModeOff)
    {
        self.session = [[AVCaptureSession alloc] init];
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        [self.session addInput:input];
        AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
        [self.session addOutput:output];
        [self.session beginConfiguration];
        [device lockForConfiguration:nil];
        [device setTorchMode:AVCaptureTorchModeOn];
        [device unlockForConfiguration];
        [self.session commitConfiguration];
        [self.session startRunning];
    }
    else
    {
        [self.session stopRunning];
        self.session = nil;
    }
}

/** Add received text messages to the log view table. Update the tab bar badge for the log
 *  view to indicate a new unread message has arrived.
 *  @param textValue The content of the text message
 */
- (void)addLogMessage:(NSString *)textValue
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.messageLog addObject:textValue];
        if (self.currentView != LOG)
        {
            NSInteger badgeValue = [[[self.tabController.viewControllers objectAtIndex:2] tabBarItem].badgeValue integerValue];
            [[self.tabController.viewControllers objectAtIndex:2] tabBarItem].badgeValue = [NSString stringWithFormat:@"%ld", badgeValue+1];
        }
        [self.logTableViewController reloadData];
    });
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self storePropertiesToArchive];
    self.appState = UIApplicationStateBackground;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    self.appState = UIApplicationStateActive;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    // Store application data to be saved.
    [self storePropertiesToArchive];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"received notification.");
}

/* Load the appropriate storyboard file based on device type.
 *   iPad         - iPad.storyboard
 *   3.5in iPhone - iPhone.storyboard
 *   4.0in iPhone - Main.storyboard
 */
- (void)loadStoryboard
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    UIStoryboard *storyboard = nil;
    if (screenSize.height == 568)
    {
        // Main.storyboard - 4in iPhone
        storyboard = [UIStoryboard storyboardWithName:@"Second_iPhone" bundle:nil];
    }
    else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        // iPad.storyboard - iPad
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    }
    else
    {
        // iPhone.storyboard - 3.5in iPhone
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    }
    
    self.tabController = [storyboard instantiateInitialViewController];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.tabController;
    [self.window makeKeyAndVisible];
}

#pragma mark CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    self.latestLocation = newLocation;
}

@end
