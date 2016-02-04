# "Just a Fake" is a IoT Cloud, iOS and Bluemix sample

This sample will be a combination, reuse and customization of part from the existing "IoT Starter for iOS" and "TempTracker_IoTBluemixMFPSample".

* [IoT Starter for iOS](https://github.com/Aiguo/iot-starter-for-ios)
* [TempTracker_IoTBluemixMFPSample](https://github.com/thomassuedbroecker/TempTracker_IoTBluemixMFPSample)

**Table of content of the readme.md**

  1. Introduction
  2. Setup the Fake sample

***
## 1. Introduction

The objective is to help to understand how the integration technical works between:

  1. Using the Mobile iOS Device as Sensor for input (Objective-C), to create fake Temperature data.
  2. Using a own IBM IoT Cloud as a Service in Bluemix
  4. Using the in Bluemix Cloundant, IoT Cloud and Watson

## 2. Setup the Fake sample

This is defined in the Bluemix related tasks and iOS related tasks.

## 2.1 Bluemix related tasks

### 2.1.1 Setup the Bluemix App
  1. Get a Bluemix Account (https://console.ng.bluemix.net)
  2. Instantiate the **IoT Foundation Starter** (https://console.ng.bluemix.net/catalog/starters/internet-of-things-foundation-starter/)
  3. Give it a name **<<your app name>>**
  4. After your application is running – click **ADD A SERVICE OR API**
  5. Select **Internet of Things Foundation** from the Catalog
  6. If the service is running click on the Service in your Bluemix application

### 2.1.2 Configure the Internet of Things Foundation Service

Now you have to define a DeviceType. This device type information, will be used be the iOS app to connect to the right device in the cloud.
After the creation of the Type you create a concrete Device this information is also used Hardcoded in iOS app.

### 2.1.3 Define DeviceType for the Internet of Things Foundation Service

  1. Click under **Connect your devices** on the Button **Launch Dashboard**
  2. On the Dashboard you can see or **"Organization ID: XXXX"**
  3. Click on **Devices** at the tabs on the Dashboard
  4. Now select  **"DEVICE TYPE"** in the new available tabs
  5. Click on **Create Type**
  6. Click on **Create Device Type**
  7. Give it the Name: **Sample** NOTE: _This name is used Hardcoded in the iOS Application._ and click Next.

  NOTE: Code in **Constants.m**

     `// IoT API Constants
      // NSString * const IOTDeviceType        = @"iPhone";
      //   *****************************************
      //   Custom IoT Device Type
      //   Depends what you have defined in your IoT
      //   *****************************************
      NSString * const IOTDeviceType        = @"Sample";`

  8. _Optional:_ Here you can select additional information for your Device Type. Click **Next**
  9. Not insert any _Optional_ Metadata and click **Create**.

### 2.1.4 Define Device for the Internet of Things Foundation Service

   1. Click on **Device** at the tabs on the Dashboard
   2. Press Button **Add Device**
   3. In the dialog **Add Device** choose the your create DeviceType Name _**Sample**_ and click **Next**
   4. Enter the Device ID **12345689**  and press **Next** _Note: This value is Hardcoded in the iOS App_
   5. Select **Next** NOTE: Don't add additional Metadata
   6. Enter your own value **Provide a token (optional):** with **"MyIoT2016"** and click **Next**
   and press **Next**
   _Note: This value is Hardcoded in the iOS App_

   NOTE: Code in **LoginViewController.m**

     `- (void)viewDidLoad
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
     }`

    _NOTE: Now you have prepared your IoT Cloud with your own Device Type and Device with a ID and Security Validation information._

## 2.2 iOS related tasks
