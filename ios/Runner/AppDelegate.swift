import UIKit
import Flutter
import Firebase
import GoogleTagManager
import StoreKit
import FBSDKCoreKit
import FacebookCore

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
        FirebaseApp.configure()
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions:launchOptions)
        //AppEventsLogger.log("My custom event.");
        let tracker = GAI.sharedInstance().tracker(withTrackingId: "UA-290443610-1")
         print("tracker: \(tracker!)")
         tracker!.allowIDFACollection = true;

         let udid =  UIDevice.current.identifierForVendor!.uuidString
          print("UDID: \(udid)")
          Analytics.logEvent(AnalyticsEventSelectContent, parameters: [AnalyticsParameterItemID : "appLaunch"])
          Analytics.setDefaultEventParameters(["iOS_UDID" : udid])

          SKAdNetwork.registerAppForAdNetworkAttribution()
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
