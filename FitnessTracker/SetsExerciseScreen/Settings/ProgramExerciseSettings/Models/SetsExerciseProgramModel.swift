

import Foundation
import UIKit

private extension Notification.Name
{
    static let setsExerciseProgramSettingsParamProgramLevelModelDidChange = Notification.Name("ProgramLevelModelDidChange")
}

class SetsExerciseProgramSettingsModel
{
    var level = SettingsParamModel<UInt>(initialVal: 1, notifName: .setsExerciseProgramSettingsParamProgramLevelModelDidChange, min: 1, max: UInt(SetsExerciseProgramSettings.maxLevel), delta: 1, toStrFunc: { (val: UInt)->String in
        val.description
    })
    
    private var notificationCenter: NotificationCenter { .default }
    private var programLevelObservation: Any?
    
    func resetValues()
    {
        level.value = 1
    }
    
    var settings = SetsExerciseProgramSettings()
    
    func setLevelObserving(onChangeCb: @escaping ()->Void)
    {
        programLevelObservation = notificationCenter.addObserver(forName: .setsExerciseProgramSettingsParamProgramLevelModelDidChange, object: level, queue: nil)
        { _ in
            self.settings.level = Int(self.level.value)
            onChangeCb()
        }
    }
}
