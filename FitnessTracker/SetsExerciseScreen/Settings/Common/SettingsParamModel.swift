
import Foundation

class SettingsParamModel<ValueType:Numeric & Comparable>
{
    private var notifName :Notification.Name?
    private var notificationCenter: NotificationCenter {.default}
    
    public var value : ValueType {
        didSet
        {
            guard notifName != nil else
            {
                return
            }
            notificationCenter.post(name: notifName!, object: self)
        }
    }
    private var toStr: (ValueType)->String;
    private var max : ValueType;
    private var min: ValueType;
    private var delta: ValueType;
    
    
    init(initialVal: ValueType, notifName: Notification.Name, min: ValueType, max: ValueType, delta: ValueType, toStrFunc: @escaping (ValueType)->String) {
        self.value = initialVal
        self.toStr = toStrFunc
        self.max = max
        self.min = min
        self.notifName = notifName
        self.delta = delta
    }
    
    private func updateVal(inc:Bool)
    {
        if (inc && self.value < max)
        {
            self.value += delta
        }
        else if (!inc && self.value > min)
        {
            self.value -= delta
        }
    }
    
    func incValue()
    {
        updateVal(inc: true)
    }
    
    func decValue()
    {
        updateVal(inc: false)
    }
    
    func toString() -> String
    {
        return toStr(self.value)
    }
    
    var isMaxReached: Bool {
        return self.value == max
    }
    
    var isMinReached: Bool {
        return self.value == min
    }
}
