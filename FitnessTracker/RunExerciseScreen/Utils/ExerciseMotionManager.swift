

import CoreMotion
import Foundation


enum MotionManagerStatus {
    case ready
    case error
}

protocol ExerciseMotionDelegate {
    func onChangeData(data: RunMotionDataModel)
    func onChangeStatus(status: MotionManagerStatus)
}

protocol ExerciseMotionManagerProtocol {
    var motionDelegate: ExerciseMotionDelegate? { get set }

    func start()
    func stop()
}

class ExerciseMotionManager: ExerciseMotionManagerProtocol {
    var motionDelegate: ExerciseMotionDelegate?
    private let pedometer = CMPedometer()

    func start() {
        pedometer.startUpdates(from: Date()) { pedometerData, error in
            guard let pedometerData = pedometerData, error == nil else {
                self.motionDelegate?.onChangeStatus(status: .error)
                return
            }
            self.motionDelegate?.onChangeStatus(status: .ready)

            self.motionDelegate?.onChangeData(data: RunMotionDataModel(distance: pedometerData.distance?.doubleValue, avgPace: pedometerData.averageActivePace?.doubleValue, steps: pedometerData.numberOfSteps.uint64Value))
        }
    }

    func stop() {
        
        pedometer.stopUpdates()
    }
}
