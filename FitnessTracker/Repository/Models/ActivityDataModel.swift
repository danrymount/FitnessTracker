
import Foundation


class ActivityDataModel : Identifiable {
    var id: Int64 = 0
    var type: ActivityType = .Push_ups
    var datetime: Date = Date.now
    var duration: TimeInterval = 0
    var username: String?
    var isCompleted: Bool = false
    
    init(datetime: Date) {
        self.datetime = datetime
    }
    
    func getStartTimeStr() -> String {
        let startTime = datetime
        let dateformat = DateFormatter()
        dateformat.dateFormat = "HH:mm:ss"
        return dateformat.string(from: startTime)
    }
    
    func getStopTimeStr() -> String {
        let stopTime = datetime + duration
        let dateformat = DateFormatter()
        dateformat.dateFormat = "HH:mm:ss"
        return dateformat.string(from: stopTime)
    }
    
    var summary: String {
        "Nothing summary"
    }
    
        func getDate() -> String
        {
            var resStr = ""
    
            if datetime.timeIntervalSinceNow > Date(timeIntervalSinceNow: -TimeInterval(24 * 60 * 60)).timeIntervalSinceNow
            {
                var sinceTime = abs(Int(datetime.timeIntervalSinceNow.rounded()))
                if sinceTime/3600 > 0
                {
                    resStr.append("\(sinceTime/3600) hours ")
                    sinceTime = sinceTime % 3600
                }
                else if sinceTime/60 > 0
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
                dateformat.dateFormat = "yyyy-MM-dd"
                return dateformat.string(from: datetime)
            }
    
            return resStr
        }
    
    
        func getDurationStr() -> String
        {
            return duration.stringFromTimeInterval()
        }
}


extension TimeInterval
{
    func stringFromTimeInterval() -> String
    {
        let time = NSInteger(self)
        
        let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
        let seconds = time % 60
        let minutes = (time/60) % 60
        
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
