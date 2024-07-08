

import Foundation
import UIKit

fileprivate extension Notification.Name
{
    static let SetsExerciseLadderParamStartDidChange = Notification.Name("SetsExerciseLadderParamStartDidChange")
}

class SetsExerciseLadderSettingsModel
{
    var level = SettingsParamModel<UInt>(initialVal: 1, notifName: .setsExerciseProgramSettingsParamProgramLevelModelDidChange, min: 1, max: 50, delta: 1, toStrFunc: {(val:UInt)->String in
        return val.description
    })
    
    private var notificationCenter: NotificationCenter {.default}
    private var programLevelObservation: Any?
    
    func resetValues()
    {
        level.value = 1
    }
    
    
    func setLevelObserving(onChangeCb: @escaping ()->Void)
    {
        programLevelObservation = notificationCenter.addObserver(forName: .setsExerciseProgramSettingsParamProgramLevelModelDidChange, object: level, queue: nil)
        {_ in
            
            onChangeCb()
        }
    }
}
