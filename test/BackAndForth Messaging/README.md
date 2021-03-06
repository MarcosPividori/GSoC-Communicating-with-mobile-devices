## Test example for Push Notifications:

This is a simple example of a Yesod server using the PushNotify api,
(Network.PushNotify) where devices can register to receive/send messages and
users can send messages through the web service. This is composed of:

* a Yesod app for registering the devices and sending push notifications.
* an Android app for registering on GCM and receiving the notifications.
* a Windows Phone app for registering on MPNS and receiving the notifications.

For APNS, Apple requires you to be an enrolled iOS Developer or something similar,
so, I couldn't add an iOS example. Nevertheless, I have added commented code lines,
on how it would be to add support for APNS on this Yesod app.


**To try the example:**
  
  + On an Android device:
     - Go to settings/applications/ allow unknown sources.
     - In the web browser go to: http://gsoc.marcospividori.com.ar/apps and download 
       the android app from the link.
     - Install it, enter a username and a password.

  + On a Windows Phone device:
     - You can download the app from Microsoft Store: [1](http://www.windowsphone.com/es-ar/store/app/gsoc_example/1e4813bf-c72d-4c18-87f8-65a418433b50)

  + If the registration succeded, when you go to: http://gsoc.marcospividori.com.ar 
    you will see your username. Now, you can start sending/receiving notifications through
    the website.

**Some ScreenShots:**

<img src="https://raw.githubusercontent.com/MarcosPividori/GSoC-Communicating-with-mobile-devices/master/test/BackAndForth%20Messaging/Img1.png" width="800px"/>

<img src="https://raw.githubusercontent.com/MarcosPividori/GSoC-Communicating-with-mobile-devices/master/test/BackAndForth%20Messaging/Img2.png" width="800px"/>

<img src="https://github.com/MarcosPividori/GSoC-Communicating-with-mobile-devices/blob/master/test/BackAndForth%20Messaging/Img3.jpg?raw=true" width="800px"/>

<img src="https://raw.githubusercontent.com/MarcosPividori/GSoC-Communicating-with-mobile-devices/master/test/BackAndForth%20Messaging/Img4.jpg" width="800px"/>


**About the Yesod App:**

Before running the Yesod app, you need to complete the "approot" and the 
"apiKey" with the proper values.

The API Key is provided by Google. You need to start a project at Google Apis
and enable the GCM service. (https://code.google.com/apis/console)

In this example, I show how to handle with the registration of devices. Also,
I provide a web service, so users can send notifications to the devices
registered.

When the server receives a post request to send a notification to
a device, it uses the General PushNotify api for sending the notifications and
handling the result in order to correctly actualize the DB. This means removing
the devices that have been unregistered, changing the regId of the devices that
have changed, and resending the notifications that weren't sent because of an
internal error in the Push Servers.


**About the Android app:**

Its very simple. When started, it connects to the GCM Service and gets its RegID.
Then, it asks you for a username and password, and sends all this information to
your server.
Once you have its regId, you can start sending notifications through GCM Servers.

NOTE: The Android app is based on some examples provided by google in the Android
developers site.


**About the Windows Phone app:**

Its also very simple. When started, it asks you for a username and password, then
it connects to the MPNS service and gets its URI and finally sends all this 
nformation to your server.
Once you have its URI, you can start sending notifications through MPNS Servers.

NOTE: The Windows Phone app is based on some examples provided by Microsoft in the
Windows Phone developers site.

For more information, you can visit the blog: http://gsoc2013cwithmobiledevices.blogspot.com.ar/
