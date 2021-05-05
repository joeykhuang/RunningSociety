//
//  InterfaceController.swift
//  RunningSocietyWatch Extension
//
//  Created by Joey Huang on 2021/4/14.
//

import WatchKit
import HealthKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController{    
    @IBOutlet weak var heartRateLabel: WKInterfaceLabel!
    @IBOutlet weak var stepsLabel: WKInterfaceLabel!

    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        super.awake(withContext: context)
        
        WorkoutTracking.authorizeHealthKit()
        WorkoutTracking.shared.delegate = self
        WatchKitConnection.shared.delegate = self
        WatchKitConnection.shared.startSession()
        self.heartRateLabel.setText("0 BPM")
        self.stepsLabel.setText("0 STEPS")
    }
    
    override func willActivate() {
        super.willActivate()
        print("WILL ACTIVE")
        WorkoutTracking.shared.fetchStepCounts()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        print("DID DEACTIVE")
    }

}

extension InterfaceController: WorkoutTrackingDelegate {
    func didReceiveHealthKitHeartRate(_ heartRate: Double) {
        heartRateLabel.setText("\(heartRate) BPM")
        WatchKitConnection.shared.sendMessage(message: ["heartRate": "\(heartRate)" as AnyObject])
    }
    
    func didReceiveHealthKitStepCounts(_ stepCounts: Double) {
        stepsLabel.setText("\(stepCounts) STEPS")
    }
}

extension InterfaceController: WatchKitConnectionDelegate {
    func didReceiveUserName(_ userName: String) {
    }
}
