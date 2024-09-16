

import Foundation
import UIKit

private extension Notification.Name
{
    static let SetsExerciseLadderParamFromDidChange = Notification.Name("SetsExerciseLadderParamFromDidChange")
    static let SetsExerciseLadderParamToDidChange = Notification.Name("SetsExerciseLadderParamToDidChange")
    static let SetsExerciseLadderParamStepsDidChange = Notification.Name("SetsExerciseLadderParamStepsDidChange")
    static let SetsExerciseLadderParamTimeoutDidChange = Notification.Name("SetsExerciseLadderParamTimeoutDidChange")
}

class SetsExerciseLadderSettingsModel
{
    enum SettingType: UInt
    {
        case from
        case to
        case steps
        case timeout
    }
    
    var fromVal = SettingsParamModel<UInt>(initialVal: 1, notifName: .SetsExerciseLadderParamFromDidChange, min: 1, max: 50, delta: 1, toStrFunc: { (val: UInt)->String in
        val.description
    })
    
    var toVal = SettingsParamModel<UInt>(initialVal: 1, notifName: .SetsExerciseLadderParamToDidChange, min: 1, max: 50, delta: 1, toStrFunc: { (val: UInt)->String in
        val.description
    })
    
    var stepsVal = SettingsParamModel<UInt>(initialVal: 1, notifName: .SetsExerciseLadderParamStepsDidChange, min: 1, max: 50, delta: 1, toStrFunc: { (val: UInt)->String in
        val.description
    })
    
    var timeoutVal = SettingsParamModel<TimeInterval>(initialVal: 1, notifName: .SetsExerciseLadderParamTimeoutDidChange, min: 10, max: 60 * 5, delta: 10, toStrFunc: { (val: TimeInterval)->String in
        val.stringFromTimeInterval()
    })
    
    private var notificationCenter: NotificationCenter { .default }
    private var fromValObservation: Any?
    private var toValObservation: Any?
    private var stepsValObservation: Any?
    private var timeoutValObservation: Any?
    
    var settings = SetsExerciseLadderSettings()
    
    func resetValues()
    {
        fromVal.value = 1
        toVal.value = 1
        stepsVal.value = 1
        timeoutVal.value = 10
    }
    
    func setObserving(forType: SettingType, onChangeCb: @escaping ()->Void)
    {
        switch forType
        {
        case .from:
            fromValObservation = notificationCenter.addObserver(forName: .SetsExerciseLadderParamFromDidChange, object: fromVal, queue: nil)
            { _ in
                self.settings.from = self.fromVal.value
                onChangeCb()
            }
        case .to:
            fromValObservation = notificationCenter.addObserver(forName: .SetsExerciseLadderParamToDidChange, object: toVal, queue: nil)
            { _ in
                self.settings.to = self.toVal.value
                onChangeCb()
            }
        case .steps:
            fromValObservation = notificationCenter.addObserver(forName: .SetsExerciseLadderParamStepsDidChange, object: stepsVal, queue: nil)
            { _ in
                self.settings.steps = self.stepsVal.value
                onChangeCb()
            }
        case .timeout:
            fromValObservation = notificationCenter.addObserver(forName: .SetsExerciseLadderParamTimeoutDidChange, object: timeoutVal, queue: nil)
            { _ in
                self.settings.timeout = self.timeoutVal.value
                onChangeCb()
            }
        }
    }
}
