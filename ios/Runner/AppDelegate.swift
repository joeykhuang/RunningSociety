import UIKit
import Flutter
import WatchConnectivity

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, WCSessionDelegate{
    
    func beginWorkout(){
        print("starting workout")
        WatchKitConnection.shared.sendMessage(message: ["workoutStatus": "1"])
    }
    
    func endWorkout(){
        print("ending workout")
        WatchKitConnection.shared.sendMessage(message: ["workoutStatus": "0"])
    }
    
    @available(iOS 9.3, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?){
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {

    }

    func sessionDidDeactivate(_ session: WCSession) {

    }
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    if(WCSession.isSupported()){
        let session = WCSession.default
        session.delegate = self
        session.activate()
        print("Session activated")
    }
    
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "myWatchChannel", binaryMessenger: controller.binaryMessenger)
    let eventChannel = FlutterEventChannel(name: "heartRateStreamChannel", binaryMessenger: controller.binaryMessenger)
    
    WatchKitConnection.shared.startSession()
    
    let heartRateStreamHandler = WatchKitConnection.shared.heartRateStream
    eventChannel.setStreamHandler(heartRateStreamHandler)
    
    channel.setMethodCallHandler({
        (call: FlutterMethodCall, result: @escaping FlutterResult) ->
        Void in
        if (call.method == "beginWorkout") {
            self.beginWorkout()
        } else if (call.method == "endWorkout") {
            self.endWorkout()
        }
    })
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
