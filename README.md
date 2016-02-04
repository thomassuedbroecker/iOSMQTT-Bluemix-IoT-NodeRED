# "Just a Fake" is IoT Cloud, iOS and Bluemix sample

This sample will be a combination, reuse and customization of part from the existing "IoT Starter for iOS" and "TempTracker_IoTBluemixMFPSample".

* [IoT Starter for iOS](https://github.com/Aiguo/iot-starter-for-ios)
* [TempTracker_IoTBluemixMFPSample](https://github.com/thomassuedbroecker/TempTracker_IoTBluemixMFPSample)

***
## 1. Introduction

The objective is to help to understand how the integration technical works between:

  1. Using the Mobile iOS Device as Sensor for input (Objective-C), to create fake Temperature data.
  2. Using a own IBM IoT Cloud as a Service in Bluemix
  4. Using the in Bluemix Cloundant, IoT Cloud and Watson

## 2. Setup the Fake sample

  1. Get a Bluemix Account (https://console.ng.bluemix.net)
  2. Instantiate the **IoT Foundation Starter** (https://console.ng.bluemix.net/catalog/starters/internet-of-things-foundation-starter/)
  3. Give it a name **<<your app name>>**
  4. After your application is running – click **ADD A SERVICE OR API**
  5. Select **Internet of Things Foundation** from the Catalog
  6. If the service is running click on the Service in your Bluemix application

### 2.1 Configure the Internet of Things Foundation Service

Now you have to define a DeviceType. This device type information, will be used be the iOS app to connect to the right device in the cloud.
After the creation of the Type you create a concrete Device this information is also used Hardcoded in iOS app.

### 2.1 Define DeviceType for the Internet of Things Foundation Service

  1. Click under **Connect your devices** on the Button **Launch Dashboard**
  2. On the Dashboard you can see or **"Organization ID: XXXX"**
  3. Click on **Devices** at the tab on the Dashboard
  4. Now select  **"DEVICE TYPE"** in the new available tabs
  5. Click on **Create Type**
  6. Click on **Create Device Type**
  7. Give it the Name: **Sample** NOTE: _This name is used Hardcoded in the iOS Application._ and click Next.

  NOTE: Code in Constants.m

     `// IoT API Constants`
     `// NSString * const IOTDeviceType        = @"iPhone";`
     `//   *****************************************`
     `//   Custom IoT Device Type`
     `//   Depends what you have defined in your IoT`
     `//   *****************************************`
     `NSString * const IOTDeviceType        = @"Sample"; `

  8. _Optional:_ Here you can select additional information for your Device Type. Click **Next**
  9. Not insert any _Optional_ Metadata and click **Create**.

### 2.3 Define Device for the Internet of Things Foundation Service
