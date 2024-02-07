

import CoreMotion
import Foundation



protocol ExerciseMotionDelegate {
    func onChangeData(data: RunMotionDataModel)
//    func onChangeStatus(status: CLAuthorizationStatus)
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
            guard let pedometerData = pedometerData, error == nil else { return }

            self.motionDelegate?.onChangeData(data: RunMotionDataModel(distance: pedometerData.distance?.doubleValue, avgPace: pedometerData.averageActivePace?.doubleValue, steps: pedometerData.numberOfSteps.uint64Value))
        }
    }

    func stop() {
        pedometer.stopUpdates()
    }
}
