# iOS app version 1.0.0 published to the App Store 3/19/23
## Functionality
* Login to a website on iOS device (i.e. Mobile Safari) using Connect-with-Mee. 
* No password is required and your login event is not tracked by a third-party (e.g. Apple, Google, Facebook, etc).
* Uses iOS FaceID (or TouchID) for user authentication.
## Issues and bugs
* No built-in backup capability. We rely on the user backing up their iOS device.
* If the user deletes the Mee app and reinstalls it then the user will end up logging back into a site/app with a new/different OpenID identifier.
* The user is not able to initiate the Connect-with-Mee flow from the Mee app. To walk through the Connect-with-Mee flow, it is necessary to install the app, type a real partner website address (https://mee.foundation) or a demo partner website address (https://oldeyorktimes.com) in a mobile browser, click the Connect-with-Mee button on any of the mentioned websites. 
* http->https redirect for the demo partner website doesn’t work. It is necessary to type https://oldeyorktimes.com in a mobile browser search bar to ensure that the Connect-with-Mee flow will go smoothly.
* Cross-device user flow is not available.
* Redirect to restore the context of OIDC request is disabled.
* UI bugs on the Consent Screen (low priority for now).
* No wizard screens to guide the user through the flow.   
# iOS app version 1.0.1 published to the App Store 3/24/23
## Functionality
* Login to a website on iOS device (i.e. Mobile Safari) using Connect-with-Mee.
* No password is required and your login event is not tracked by a third-party (e.g. Apple, Google, Facebook, etc).
* Uses iOS FaceID (or TouchID) for user authentication.
## Issues and bugs
* No built-in backup capability. We rely on the user backing up their iOS device.
* If the user deletes the Mee app and reinstalls it then the user will end up logging back into a site/app with a new/different OpenID identifier.
* http->https redirect for the demo partner website doesn’t work. It is necessary to type in https://oldeyorktimes.com in a mobile browser search bar to ensure that the Connect-with-Mee flow will go smoothly (in case the user starts the flow not from the Mee app).
* Cross-device user flow is not available.
* Redirect to restore the context of OIDC request is disabled.
* Wizard is in place but it will be updated to ensure better UI/UX.
* Some low-priority UI bugs are not fixed (including Consent Screen Required section overlap).
# iOS app versions 1.1.1 and 1.2.1 published to the App Store 6/9-20/23
## Functionality
* Login to a website on iOS device (i.e. Mobile Safari) using Connect-with-Mee.
* No password is required and your login event is not tracked by a third-party (e.g. Apple, Google, Facebook, etc).
* Uses iOS FaceID (or TouchID) for user authentication.
* Safari extension added with option to send a “Do Not Sell My Personal Information” signal to websites.
* Cross-device user flow is available.
* Redirect to restore the context of OIDC request is available.
* Wizard is updated to ensure better UI/UX.
*  UI bugs are are fixed (including Consent Screen Required section overlap)
*  http->https redirect for the demo partner website works properly (in case the user starts the flow not from the Mee app).
## Issues and bugs
* No built-in backup capability. We rely on the user backing up their iOS device.
* If the user deletes the Mee app and reinstalls it then the user will end up logging back into a site/app with a new/different OpenID identifier.
# iOS app versions 1.3.0 and 1.3.1 published to the App Store 8/3-17/23
## Functionality
* Login to a website on iOS device (i.e. Mobile Safari) using Connect-with-Mee.
* No password is required and your login event is not tracked by a third-party (e.g. Apple, Google, Facebook, etc).
* Uses iOS FaceID (or TouchID) for user authentication.
* Safari extension added with option to send a “Do Not Sell My Personal Information” signal to websites.
* Cross-device user flow is available.
* Redirect to restore the context of OIDC request is available.
* Wizard is updated to ensure better UI/UX.
* UI bugs are are fixed (including Consent Screen Required section overlap)
* http->https redirect for the demo partner website works properly (in case the user starts the flow not from the Mee app).
* Goggle Account intergation is avaliable.
* Mee app is renamed to the Mee Smartwallet app.
## Issues and bugs
* No built-in backup capability. We rely on the user backing up their iOS device.
* If the user deletes the Mee app and reinstalls it then the user will end up logging back into a site/app with a new/different OpenID identifier.
