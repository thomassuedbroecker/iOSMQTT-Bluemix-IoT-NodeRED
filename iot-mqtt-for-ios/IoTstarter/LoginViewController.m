/*
 Licensed Materials - Property of IBM
 
 © Copyright IBM Corporation 2014,2015. All Rights Reserved.
 
 This licensed material is sample code intended to aid the licensee in the development of software for the Apple iOS and OS X platforms . This sample code is  provided only for education purposes and any use of this sample code to develop software requires the licensee obtain and comply with the license terms for the appropriate Apple SDK (Developer or Enterprise edition).  Subject to the previous conditions, the licensee may use, copy, and modify the sample code in any form without payment to IBM for the purposes of developing software for the Apple iOS and OS X platforms.
 
 Notwithstanding anything to the contrary, IBM PROVIDES THE SAMPLE SOURCE CODE ON AN "AS IS" BASIS AND IBM DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, ANY IMPLIED WARRANTIES OR CONDITIONS OF MERCHANTABILITY, SATISFACTORY QUALITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND ANY WARRANTY OR CONDITION OF NON-INFRINGEMENT. IBM SHALL NOT BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY OR ECONOMIC CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR OPERATION OF THE SAMPLE SOURCE CODE. IBM SHALL NOT BE LIABLE FOR LOSS OF, OR DAMAGE TO, DATA, OR FOR LOST PROFITS, BUSINESS REVENUE, GOODWILL, OR ANTICIPATED SAVINGS. IBM HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS OR MODIFICATIONS TO THE SAMPLE SOURCE CODE.
 */

//
//  LoginViewController.m
//  IoTstarter
//

#import "LoginViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@property (strong, nonatomic) IBOutlet UIButton *activateButton;

@property (strong, nonatomic) IBOutlet UILabel *connected;

@property (strong, nonatomic) IBOutlet UITextField *organizationField;
@property (strong, nonatomic) IBOutlet UITextField *authTokenField;
@property (strong, nonatomic) IBOutlet UITextField *deviceIDField;

@property (strong, nonatomic) IBOutlet UIButton *showAuthToken;

@property (strong, nonatomic) IBOutlet UISwitch *accelSwitch;

@end

@implementation LoginViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        appDelegate.loginViewController = self;
    }
    return self;
}

/*************************************************************************
 * View related methods
 *************************************************************************/

/*************************************************************************
 * DEFINE OWN LOGIN
 *************************************************************************/
- (void)viewWillAppear:(BOOL)animated
{
    [self updateViewLabels];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.currentView = LOGIN;
    
    self.authTokenField.secureTextEntry = YES;
    self.authTokenField.delegate = self;
    self.deviceIDField.delegate = self;
    self.organizationField.delegate = self;
    
    self.organizationField.placeholder = @"ff6cyz";
    // IOTOrgPlaceholder;
    self.deviceIDField.placeholder = @"123456789";
    // IOTDevicePlaceholder;
    self.authTokenField.placeholder = @"MyIoT2016";
    // IOTAuthPlaceholder;
    
    if (![appDelegate.organization isEqualToString:@""])
    {
        self.organizationField.text = @"ff6cyz";
        appDelegate.organization;
    }
    if (![appDelegate.deviceID isEqualToString:@""])
    {
        self.deviceIDField.text = @"123456789";
        appDelegate.deviceID;
    }
    if (![appDelegate.authToken isEqualToString:@""])
    {
        self.authTokenField.text = @"MyIoT2016";
        appDelegate.authToken;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.authTokenField.secureTextEntry = YES;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    self.organizationField.text = @"ff6cyz";
    appDelegate.organization;
    self.deviceIDField.text  = @"123456789";
    appDelegate.deviceID;
    self.authTokenField.text = @"MyIoT2016";
    appDelegate.authToken;
}

- (void)updateViewLabels
{
    NSLog(@"%s:%d entered", __func__, __LINE__);
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [self.activateButton setEnabled:YES];
    
    if (appDelegate.isConnected)
    {
        // If device is connected, then it is already registered and all values were
        // already set.
        [self.activateButton setTitle:IOTDeactivateLabel forState:UIControlStateNormal];
        self.connected.text = YES_STRING;
    }
    else
    {
        // If device is not connected, it may or may not be registered.
        [self.activateButton setTitle:IOTActivateLabel forState:UIControlStateNormal];
        self.connected.text = NO_STRING;
    }
    [self.showAuthToken setTitle:IOTShowTokenLabel forState:UIControlStateNormal];
}

/*************************************************************************
 * IBAction methods
 *************************************************************************/

- (IBAction)showAuthToken:(id)sender
{
    NSLog(@"%s:%d entered", __func__, __LINE__);
    if ([self.showAuthToken.currentTitle isEqualToString:IOTShowTokenLabel])
    {
        self.authTokenField.secureTextEntry = NO;
        [self.showAuthToken setTitle:IOTHideTokenLabel forState:UIControlStateNormal];
    }
    else
    {
        self.authTokenField.secureTextEntry = YES;
        [self.showAuthToken setTitle:IOTShowTokenLabel forState:UIControlStateNormal];
    }
}

- (IBAction)activateSensor:(id)sender
{
    NSLog(@"%s:%d entered", __func__, __LINE__);
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [self.activateButton setEnabled:NO];
    [appDelegate storePropertiesToArchive];
    
    if ([self.activateButton.titleLabel.text isEqualToString:IOTActivateLabel])
    {
        // Start MQTT logic
        Messenger *messenger = [Messenger sharedMessenger];
        NSString *serverAddress;
        NSString *clientID;
        
        appDelegate.organization = [NSString stringWithFormat:@"%@", self.organizationField.text];
        appDelegate.deviceID = [NSString stringWithFormat:@"%@", self.deviceIDField.text];
        appDelegate.authToken = [NSString stringWithFormat:@"%@", self.authTokenField.text];
        
        if ([appDelegate.organization isEqualToString:IOTQuickStartOrgID])
        {
            appDelegate.connectionType = QUICKSTART;
            appDelegate.sensorFrequency = IOTSensorFreqDefault;
            serverAddress = IOTQuickStartServer;
            clientID = [NSString stringWithFormat:IOTClientID, appDelegate.organization, IOTDeviceType, appDelegate.deviceID];
        }
        else if ([appDelegate.organization isEqualToString:IOTM2MOrgID])
        {
            appDelegate.connectionType = M2M;
            appDelegate.sensorFrequency = IOTSensorFreqFast;
            serverAddress = IOTM2MDemosServer;
            clientID = [NSString stringWithFormat:IOTM2MClientID, appDelegate.deviceID];
        }
        else {
            appDelegate.connectionType = IOTF;
            appDelegate.sensorFrequency = IOTSensorFreqDefault;
            serverAddress = [NSString stringWithFormat:IOTServerAddress, appDelegate.organization];
            clientID = [NSString stringWithFormat:IOTClientID, appDelegate.organization, IOTDeviceType, appDelegate.deviceID];
        }
        
#ifdef USE_LOCAL_NOTIFICATIONS
        // Run the MQTT Connection in a background task so that it continues processing messages
        // while the application is running in the background.
        appDelegate.bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithName:@"iotbgtask" expirationHandler:^{
            [[UIApplication sharedApplication] endBackgroundTask:appDelegate.bgTask];
            appDelegate.bgTask = UIBackgroundTaskInvalid;
        }];
#endif
        [messenger connectWithHost:serverAddress port:IOTServerPort clientId:clientID];
    }
    else if ([self.activateButton.titleLabel.text isEqualToString:IOTDeactivateLabel])
    {
        // Stop MQTT logic
        Messenger *messenger = [Messenger sharedMessenger];
        
        [messenger disconnect];
    }
}

- (IBAction)rightViewChangePressed:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate switchToIoTView];
}

- (IBAction)leftViewChangePressed:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    //[appDelegate switchToRemoteView];
    [appDelegate switchToLogView];
}

- (IBAction)toggleAccel:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.isAccelEnabled = [self.accelSwitch isOn];
    if (appDelegate.isConnected && appDelegate.isAccelEnabled)
    {
        [appDelegate startMotionManager];
    }
    else if (appDelegate.isConnected && !appDelegate.isAccelEnabled)
    {
        [appDelegate stopMotionManager];
    }
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)text
{
    [text resignFirstResponder];
    return YES;
}

/*************************************************************************
 * Other standard iOS methods
 *************************************************************************/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ProfilesTableViewController *tableView = [segue destinationViewController];
    tableView.currentOrganization = [NSString stringWithString:self.organizationField.text];
    tableView.currentDeviceID = [NSString stringWithString:self.deviceIDField.text];
    tableView.currentAuthToken = [NSString stringWithString:self.authTokenField.text];
}

@end
