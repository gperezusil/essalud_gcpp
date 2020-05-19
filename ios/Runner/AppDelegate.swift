import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain

@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self);
    GMSServices.provideAPIKey("AIzaSyBm1u3k_-Df5UeTE5AB08xLQXJVKHb27iw");
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
