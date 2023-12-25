
import Foundation


class RoundTimer
{
    private var timer : Timer;
    private var onStep: (TimeInterval) -> Void;
    private var stepDivider: TimeInterval
    private var leftTime: TimeInterval
    private let duration: TimeInterval
    
    init(duration: TimeInterval, _stepDivider:TimeInterval ,_onStep: @escaping (TimeInterval) -> Void) {
        onStep = _onStep
        self.duration = duration
        leftTime = duration
        stepDivider = _stepDivider
        onStep(leftTime)
        timer = Timer()
    }
    
    private func roundLeftTime()
    {
        let divider: Int = Int(ceil(1/stepDivider))
        leftTime = round(leftTime * Double(divider)) / Double(divider)
    }
    
    @objc
    private func step()
    {
        leftTime -= stepDivider
        roundLeftTime()
        onStep(leftTime)
        
        if (leftTime == 0)
        {
            reset()
        }
    }
    
    func start()
    {
        self.timer = Timer.scheduledTimer(timeInterval: stepDivider, target: self, selector: #selector(step), userInfo: nil, repeats: true)
    }
    
    func reset()
    {
        timer.invalidate()
        leftTime = duration
    }
    
    func pause()
    {
        
    }
}
