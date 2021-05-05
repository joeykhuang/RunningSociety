//
//  WorkoutTracking.swift
//  Runner
//
//  Created by Joey Huang on 2021/4/14.
//

import HealthKit

protocol WorkoutTrackingProtocol {
    func authorizeHealthKit()
    func observerHeartRateSamples()
}

class WorkoutTracking {
    static let shared = WorkoutTracking()
    let healthStore = HKHealthStore()
    var observerQuery: HKObserverQuery!
    var heartRate = 0.0
    init() {
    }
}

extension WorkoutTracking: WorkoutTrackingProtocol {
    
    func authorizeHealthKit() {
        if HKHealthStore.isHealthDataAvailable() {
            let infoToRead = Set([
                HKSampleType.quantityType(forIdentifier: .stepCount)!,
                HKSampleType.quantityType(forIdentifier: .heartRate)!,
                HKSampleType.workoutType()
                ])
            
            let infoToShare = Set([
                HKSampleType.quantityType(forIdentifier: .stepCount)!,
                HKSampleType.quantityType(forIdentifier: .heartRate)!,
                HKSampleType.workoutType()
                ])
            
            healthStore.requestAuthorization(toShare: infoToShare, read: infoToRead) { (success, error) in
                if success {
                    print("Authorization healthkit success")
                } else if let error = error {
                    print(error)
                }
            }
        } else {
            print("HealthKit not avaiable")
        }
    }
    
    func observerHeartRateSamples() {
        guard let heartRateSampleType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            return
        }
        
        if let observerQuery = observerQuery {
            healthStore.stop(observerQuery)
        }
        
        observerQuery = HKObserverQuery(sampleType: heartRateSampleType, predicate: nil) { [unowned self] (_, _, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            self.fetchLatestHeartRateSample { (sample) in
                guard let sample = sample else {
                    return
                }
                
                DispatchQueue.main.async {
                    let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                    self.heartRate = sample.quantity.doubleValue(for: heartRateUnit)
                    print("Heart Rate Sample: \(heartRate)")
                }
            }
        }
        
        healthStore.execute(observerQuery)
        healthStore.enableBackgroundDelivery(for: heartRateSampleType, frequency: .immediate) { (success, error) in
            print(success)
            if let error = error {
                print(error)
            }
        }
    }
}

extension WorkoutTracking {
    private func fetchLatestHeartRateSample(completionHandler: @escaping (_ sample: HKQuantitySample?) -> Void) {
        guard let sampleType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) else {
            completionHandler(nil)
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: sampleType,
                                  predicate: predicate,
                                  limit: Int(HKObjectQueryNoLimit),
                                  sortDescriptors: [sortDescriptor]) { (_, results, error) in
                                    if let error = error {
                                        print("Error: \(error.localizedDescription)")
                                        return
                                    }
                                    
                                    completionHandler(results?[0] as? HKQuantitySample)
        }
        
        healthStore.execute(query)
    }
}
