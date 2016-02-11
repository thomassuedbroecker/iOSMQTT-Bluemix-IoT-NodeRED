# "Just a Fake" is a IoT Cloud, iOS and Bluemix sample

This sample will be a combination, reuse and customization of part from the existing "IoT Starter for iOS" and "TempTracker_IoTBluemixMFPSample".

* [IoT Starter for iOS](https://github.com/Aiguo/iot-starter-for-ios)
* [TempTracker_IoTBluemixMFPSample](https://github.com/thomassuedbroecker/TempTracker_IoTBluemixMFPSample)

**Table of content of the readme.md**

  1. Introduction
  2. Setup the "Just a Fake" sample
  3. Source Folder content description

***
## 1. Introduction

The objective is to help to understand how the integration technical works between own IoT Cloud, iOS App and Bluemix:

  1. Using the Mobile iOS Device as Sensor for input (Objective-C), to create fake Temperature data.
  2. Using a own IBM IoT Cloud as a Service in Bluemix
  4. Using the in Bluemix Cloundant, IoT Cloud and Watson

***
## 2. Setup the "Just a Fake" sample

This is the description of **Bluemix** related tasks and **iOS** related tasks.

***
## 2.1 Bluemix related tasks

These tasks are
  * Setup a account
  * Create a Bluemix application
  * Configure the Bluemix services
  * Edit the Node-RED application

***
### 2.1.1 Setup the Bluemix App
  1. Get a Bluemix Account (https://console.ng.bluemix.net)
  2. Instantiate the **IoT Foundation Starter** (https://console.ng.bluemix.net/catalog/starters/internet-of-things-foundation-starter/)
  3. Give it a name **<<your app name>>**
  4. After your application is running – click **ADD A SERVICE OR API**
  5. Select Text to Speech from the Catalog
  6. Search for entering “Text to “ in the Search field and click the icon
  7. Create your Text To Speech service instance
  8. Click CREATE
  9. Restage the application
 10. After your application is running – click **ADD A SERVICE OR API**
 11. Select **Internet of Things Foundation** from the Catalog
 12. If the service is running click on the **Internet of Things Foundation** Service in your Bluemix application

***
### 2.1.2 Configure the Internet of Things Foundation Service

Now you have to define a DeviceType. This device type information, will be used be the iOS app to connect to the right device in the cloud.
After the creation of the Type you create a concrete Device this information is also used Hardcoded in iOS app.

***
### 2.1.3 Define DeviceType for the Internet of Things Foundation Service

  1. Click under **Connect your devices** on the Button **Launch Dashboard**
  2. On the Dashboard you can see or **"Organization ID: XXXX"**
  3. Click on **Devices** at the tabs on the Dashboard
  4. Now select  **"DEVICE TYPE"** in the new available tabs
  5. Click on **Create Type**
  6. Click on **Create Device Type**
  7. Give it the Name: **Sample** NOTE: _This name is used Hardcoded in the iOS Application._ and click Next.

  NOTE: Code in **Constants.m**

      ` // IoT API Constants
       // NSString * const IOTDeviceType        = @"iPhone";
       //   *****************************************
       //   Custom IoT Device Type
       //   Depends what you have defined in your IoT
       //   *****************************************
       NSString * const IOTDeviceType        = @"Sample"; `

  8. _Optional:_ Here you can select additional information for your Device Type. Click **Next**
  9. Not insert any _Optional_ Metadata and click **Create**.

***
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

      ` (void)viewDidLoad
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
       } `

  _NOTE: Now you have prepared your IoT Cloud with your own Device Type and Device with a ID and Security Validation information._

### 2.1.5 CloudantDB setup

  1. In your Bluemix Appliction, click the Cloudant service from your application
  2. Open the dashboard of your Cloudant service by clicking LAUNCH
  3. Click Create Database
  4. Create a new database named “my_demo_iot_db” This will simplify your usage of the provided code
  5. Create new Search Index  - use the documentation in ..\TempTracker_IoTBluemixMFPSample-master\tempTrackCloudantConfiguration or (http://bit.ly/1TnfJFv) to do that

***
### 2.1.6 Node-RED Configuration

  1. On Bluemix, go to your application and click on the url to open your Node-RED
  2. Delete the content of the default created sheet by selecting all and DEL
  3. Copy the ClipboardNodeRed-containsAllNodes.txt content into the Clipboard Either you have it cloned with git or you can get it from git.hub here:(http://bit.ly/20bqIC8)
  4. Import from Clipboard
  5. Make changes in yours in the lines marked with CHANGE as comment in code.
  * NODE NAME: "_**(Show Geo WebSite with Sensor Cloudant Data)**_"

    `<!-- *****     CHANGES  ***** -->`
    `<!-- Insert YOUR BLUEMIX URL  -->`
    `<div id="header">`
    `<p>Hello this is the Cloudant Sensor Geo Data Site ... </p> <a href="http://YOUR BLUEMIX URL/cloudant">Go to Senosor Data Page</a>`
    `</div>`

  * NODE NAME: "_**(Show Sensor Cloudant Data on WebSite)**_"

    `<!-- *****     CHANGES  ***** -->`
    `<!-- Insert YOUR BLUEMIX URL  -->`
    `<div id="header">`
    `<p>Hello this is the Cloudant Sensor Data Site ... </p> <a href="http://YOUR BLUEMIX URLt/map">Go to Senosor Data Page</a>`
    `</div>`
  6. Change the Text2Speech node to match your Text2Speech service
  7. Change the url in **http response Node** for _audio_, _map_ and _cloudant_ nodes to match your nodeRed http address. _NOTE:_ This is for you that you can easily copy and past the URL later in your browser.

***
### 2.2 iOS related tasks

These tasks are
  * Configure xCode Project
  * Run the the sample App

***
### 2.2.1  Setup the xCode Project
  1. Open the xCode Project in **_iOSMQTT-Bluemix-IoT-NodeRED/iot-mqtt-for-ios/IoTstarter.xcodeproj_**

  2. Relevant classes which are different to the _ios-starter-for-ios project_

     * _IoTStarterViewController.m_
     * _LoginViewController.m_
     * _MessageFactory.h_
     * _MessageFactory.m_
     * _Constants.h_
     * _Constants.m_
     * _Main_iPHone.storyboard (changed)_

  3. Change in LoginViewController.m the values of **organization** in operations _viewWillAppear_ and _viewDidLoad_

  4. **_Optional:_** If you have defined own values you must change **deviceID** and **authToken** in _LoginViewController.m_ in operations _viewWillAppear_ and _viewDidLoad_

  5. Run the project on a real iOS iPhone or in the iOS Simulator
  6. When you press **send Message** _Fake_ sensor data, will be send to your IoT cloud.

***
# 3. Source Folder content description

***
## 3.1 Basic UML Documentation

* _**iOSMQTT-Bluemix-IoT-NodeRED/iot-mqtt-for-ios-Documentation**_

This folder contains a basic documentation with a UML Model including some diagrams.

***
## 3.2 Bluemix - Node-RED Implementation

* _**iOSMQTT-Bluemix-IoT-NodeRED/iot-mqtt-for-ios-NodeREDImplemtations**_

This folder contains the Node-Red implementation.
The file _ClipboardNodeRed-containsAllNodes.txt_ includes the the whole **Node-RED** implementation you can import to your Node-Red in Bluemix.

The other folders _"templates and functions"_ do contain the "pure" code for some nodes. Just to provide a **more readable** format for you.

***
## 3.3 Bluemix - Cloudant configuration

* _**iOSMQTT-Bluemix-IoT-NodeRED/iot-mqtt-for-ios-CloudantConfiguration**_

This folder contains the needed code and information to build the search index which will be used by the MobileApp TempTracker to search for Device ID, Status, Date and Temperature.

***
## 3.4 iOS App Implementation

*  _**iOSMQTT-Bluemix-IoT-NodeRED/iot-mqtt-for-ios**_

This folder contains a xCode Project with the MobileApp based on _"Objective-C"_.
