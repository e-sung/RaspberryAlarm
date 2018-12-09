import Foundation
import HealthKit

let HEALTH_STORE = HKHealthStore()
class AuthRequestor {
    

    func request(completion: @escaping (_ authorized:Bool, _ error: Error?) -> Void) {
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
}

