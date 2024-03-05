
import Foundation

protocol ActivityDataModelProtocol {
    var id: Int64 { get set }
    var type: ActivityType { get }
    var datetime: Date { get }
    var duration: TimeInterval { get set }
    var username: String? { get set }
    var isCompleted: Bool { get set }
    
    init(datetime: Date)
    
    func getStartTimeStr() -> String
    func getStopTimeStr() -> String
    var summary: String { get }
}

extension ActivityDataModelProtocol {
    
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
}
