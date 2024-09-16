//
//import Foundation
//import UIKit
//
//extension Notification.Name
//{
//    static let exerciseParamSetsModelDidChange = Notification.Name("SetsModelDidChange")
//    static let exerciseParamRepeatsModelDidChange = Notification.Name("RepeatsModelDidChange")
//    static let exerciseParamTimeoutModelDidChange = Notification.Name("TimeoutModelDidChange")
//}
//
//class ExerciseParamModel<ValueType:Numeric & Comparable>
//{
//    private var notifName :Notification.Name?
//    private var notificationCenter: NotificationCenter {.default}
//    
//    public var value : ValueType {
//        didSet
//        {
//            guard notifName != nil else
//            {
//                return
//            }
//            notificationCenter.post(name: notifName!, object: self)
//        }
//    }
//    private var toStr: (ValueType)->String;
//    private var max : ValueType;
//    private var min: ValueType;
//    private var delta: ValueType;
//    
//    
//    init(initialVal: ValueType, notifName: Notification.Name, min: ValueType, max: ValueType, delta: ValueType, toStrFunc: @escaping (ValueType)->String) {
//        self.value = initialVal
//        self.toStr = toStrFunc
//        self.max = max
//        self.min = min
//        self.notifName = notifName
//        self.delta = delta
//    }
//    
//    private func updateVal(inc:Bool)
//    {
//        if (inc && self.value < max)
//        {
//            self.value += delta
//        }
//        else if (!inc && self.value > min)
//        {
//            self.value -= delta
//        }
//    }
//    
//    func incValue()
//    {
//        updateVal(inc: true)
//    }
//    
//    func decValue()
//    {
//        updateVal(inc: false)
//    }
//    
//    func toString() -> String
//    {
//        return toStr(self.value)
//    }
//}
//
//class ExerciseSettings
//{
//    enum SettingType: UInt
//    {
//        case Repeats
//        case Sets
//        case Timeout
//    }
//    private var notificationCenter: NotificationCenter {.default}
//    
//    var repeats = ExerciseParamModel<UInt>(initialVal: 1, notifName: .exerciseParamRepeatsModelDidChange, min: 1, max: 50, delta: 1, toStrFunc: {(val:UInt)->String in
//        return val.description
//    })
//    var sets = ExerciseParamModel<UInt>(initialVal: 1, notifName: .exerciseParamSetsModelDidChange, min: 1, max: 10, delta: 1, toStrFunc: {(val:UInt)->String in
//        return val.description
//    })
//    var timeout = ExerciseParamModel<TimeInterval>(initialVal: 10, notifName: .exerciseParamTimeoutModelDidChange, min: 10, max: 60*5, delta: 10, toStrFunc: {(val:TimeInterval)->String in
//        return val.stringFromTimeInterval()
//    })
//    
//    private var repeatsObservation: Any?
//    private var setsObservation: Any?
//    private var timeoutObservation: Any?
//    
//    
//    func resetValues()
//    {
//        repeats.value = 1
//        sets.value = 1
//        timeout.value = 10
//    }
//    
//    
//    func setObserving(forType: SettingType, onChangeCb: @escaping ()->Void)
//    {
//        switch forType
//        {
//        case .Repeats :
//            repeatsObservation = notificationCenter.addObserver(forName: .exerciseParamRepeatsModelDidChange, object: repeats, queue: nil)
//            {_ in
//                onChangeCb()
//            }
//        case .Sets:
//            setsObservation = notificationCenter.addObserver(forName: .exerciseParamSetsModelDidChange, object: sets, queue: nil)
//            {_ in
//                onChangeCb()
//            }
//        case .Timeout:
//            timeoutObservation = notificationCenter.addObserver(forName: .exerciseParamTimeoutModelDidChange, object: timeout, queue: nil)
//            {_ in
//                onChangeCb()
//            }
//        }
//    }
//}
