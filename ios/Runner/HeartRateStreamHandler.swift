//
//  HeartRateStreamHandler.swift
//  Runner
//
//  Created by Joey Huang on 2021/4/15.
//

import Foundation

class HeartRateStreamHandler: NSObject, FlutterStreamHandler {
    private var _eventSink: FlutterEventSink?

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        _eventSink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        _eventSink = nil
        return nil
    }
    
    func updateHeartRate(_ receivedHeartRate: String){
        _eventSink?(receivedHeartRate)
    }
}
