
import Foundation
import OSLog


@objc enum ActivityType : Int
{
    case Run
    case Push_ups
    case Squats
    
    func toIconName() -> String
    {
        switch self
        {
        case .Run:
            return "figure.run"
        case .Push_ups:
            return "figure.core.training"
        case .Squats:
            return "figure.strengthtraining.functional"
        }
    }
    
    func toString() -> String
    {
        switch self
        {
        case .Run:
            return "Run"
        case .Push_ups:
            return "Push-ups"
        case .Squats:
            return "Squats"
        }
    }
}



extension Logger {
    /// Using your bundle identifier is a great way to ensure a unique identifier.
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let common = Logger(subsystem: subsystem, category: "common")
}
