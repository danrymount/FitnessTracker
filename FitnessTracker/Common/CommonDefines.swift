
import Foundation

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
