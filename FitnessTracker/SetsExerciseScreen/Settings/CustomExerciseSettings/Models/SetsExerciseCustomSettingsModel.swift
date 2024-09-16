
import Foundation
import UIKit

fileprivate extension Notification.Name
{
    static let setsExerciseProgramSettingsParamSetsModelDidChange = Notification.Name("SetsModelDidChange")
    static let setsExerciseProgramSettingsParamRepeatsModelDidChange = Notification.Name("RepeatsModelDidChange")
    static let setsExerciseProgramSettingsParamTimeoutModelDidChange = Notification.Name("TimeoutModelDidChange")
}

class SetsExerciseCustomSettingsModel
{
    enum SettingType: UInt
    {
        case Repeats
        case Sets
        case Timeout
    }
    private var notificationCenter: NotificationCenter {.default}
    
    var repeats = SettingsParamModel<UInt>(initialVal: 1, notifName: .setsExerciseProgramSettingsParamRepeatsModelDidChange, min: 1, max: 50, delta: 1, toStrFunc: {(val:UInt)->String in
        return val.description
    })
    var sets = SettingsParamModel<UInt>(initialVal: 1, notifName: .setsExerciseProgramSettingsParamSetsModelDidChange, min: 1, max: 10, delta: 1, toStrFunc: {(val:UInt)->String in
        return val.description
    })
    var timeout = SettingsParamModel<TimeInterval>(initialVal: 10, notifName: .setsExerciseProgramSettingsParamTimeoutModelDidChange, min: 10, max: 60*5, delta: 10, toStrFunc: {(val:TimeInterval)->String in
        return val.stringFromTimeInterval()
    })
    
    var settings = SetsExerciseCustomSettings()
    
    private var repeatsObservation: Any?
    private var setsObservation: Any?
    private var timeoutObservation: Any?
    
    
    func resetValues()
    {
        repeats.value = 1
        sets.value = 1
        timeout.value = 10
    }
    
    
    func setObserving(forType: SettingType, onChangeCb: @escaping ()->Void)
    {
        switch forType
        {
        case .Repeats :
            repeatsObservation = notificationCenter.addObserver(forName: .setsExerciseProgramSettingsParamRepeatsModelDidChange, object: repeats, queue: nil)
            {_ in
                self.settings.reps = Int(self.repeats.value)
                onChangeCb()
            }
        case .Sets:
            setsObservation = notificationCenter.addObserver(forName: .setsExerciseProgramSettingsParamSetsModelDidChange, object: sets, queue: nil)
            {_ in
                self.settings.sets = Int(self.sets.value)
                onChangeCb()
            }
        case .Timeout:
            timeoutObservation = notificationCenter.addObserver(forName: .setsExerciseProgramSettingsParamTimeoutModelDidChange, object: timeout, queue: nil)
            {_ in
                self.settings.timeout = self.timeout.value
                onChangeCb()
            }
        }
    }
}
