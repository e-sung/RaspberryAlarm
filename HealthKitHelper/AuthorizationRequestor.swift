import Foundation
import HealthKit

public let HEALTH_STORE = HKHealthStore()
public protocol HealthKitAuthRequestor {
    func requestSleepAuthorization(completion: @escaping (_ authorized:Bool, _ error: Error?) -> Void)
}

public protocol SleepDataStore {
    func saveSleepAnalysis(from startDate: Date)
}

public class HealthKitHelper: HealthKitAuthRequestor, SleepDataStore{
    
    public static var shared = HealthKitHelper()

    public func requestSleepAuthorization(completion: @escaping (_ authorized:Bool, _ error: Error?) -> Void) {
        if HKHealthStore.isHealthDataAvailable() == false {
            completion(false, "Device Not Supported" as? Error)
        }
        guard let sleepAnalysisType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
            completion(false, "Couldn't set Up SleepAnalysisType" as? Error)
            return
        }
        
        HEALTH_STORE.requestAuthorization(toShare: [sleepAnalysisType],
                                         read: [sleepAnalysisType]) { authorized, error in
                                            completion(authorized, error)
        }
    }
    
    public func saveSleepAnalysis(from startDate: Date) {
        let now = Date()
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else { return }
        
        // we create our new object we want to push in Health app
        let inBedSample = HKCategorySample(type: sleepType,
                                           value: HKCategoryValueSleepAnalysis.inBed.rawValue,
                                           start: startDate, end: now)
        
        let asleepSample = HKCategorySample(type: sleepType, value: HKCategoryValueSleepAnalysis.asleep.rawValue,
                                            start: startDate, end: now)
        
        let awakeSample = HKCategorySample(type: sleepType,
                                           value: HKCategoryValueSleepAnalysis.awake.rawValue,
                                           start: startDate, end: now)
        
        HEALTH_STORE.save([inBedSample, asleepSample, awakeSample], withCompletion: { success, error in })
    }
}

