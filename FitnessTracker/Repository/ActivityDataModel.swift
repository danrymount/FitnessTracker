
import Foundation

public struct ActivityDataModel : Identifiable
{
    public var id: Int
    var performedAmount: Double
    var duration: TimeInterval
    var type: ActivityType
    var datetime: Date
    
    func getDurationStr() -> String
    {
        return duration.stringFromTimeInterval()
    }
    
    func getPerformedInfo() -> String
    {
        switch (type)
        {
        case .Push_ups, .Squats:
            return "\(UInt(performedAmount)) reps."
        case .Run:
            return "\(performedAmount) km"
        default:
            return "UNDEF!"
        }
        
    }
    
    func getTime()->String
    {
        var resStr : String = ""
        
        if datetime.timeIntervalSinceNow > Date(timeIntervalSinceNow: -TimeInterval(24*60*60)).timeIntervalSinceNow
        {
            var sinceTime = abs(Int(datetime.timeIntervalSinceNow.rounded()))
            if sinceTime/3600 > 0
            {
                resStr.append("\(sinceTime/3600) hours ")
                sinceTime = sinceTime % 3600
            }
            
            if sinceTime/60 > 0
            {
                resStr.append("\(sinceTime/60) minutes ")
                sinceTime = sinceTime % 60
            }
            
            
            if resStr.count == 0
            {
                resStr = "just now"
            }
            else
            {
                resStr.append("ago")
            }
        }
        else
        {
            let dateformat = DateFormatter()
            dateformat.dateFormat = "yyyy-MM-dd HH:mm"
            return dateformat.string(from: datetime)
        }
        
        return resStr
    }
}

extension TimeInterval {
    
    func stringFromTimeInterval() -> String {
        
        let time = NSInteger(self)
        
        let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        
        return String(format: "%0.2d:%0.2d", minutes, seconds)
        
    }
}

extension Date
{
    func toString() -> String
    {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd"
        return dateformat.string(from: self)
    }
}
