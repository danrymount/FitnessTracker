
import Foundation
import UIKit

class StopwatchService {
    private weak var displayLink: CADisplayLink?
    private var startTime: CFTimeInterval?
    private var elapsed: CFTimeInterval = 0
    private var prevElapsed: CFTimeInterval = 0
    var onTimeUpdate: ((_ time: CFTimeInterval) -> Void)?
    
    @objc private func handleStopwatchDisplayLink(_ displayLink: CADisplayLink) {
        guard let startTime = startTime else { return }
        elapsed = CACurrentMediaTime() - startTime + prevElapsed
        
        if let onTimeUpdate {
            onTimeUpdate(elapsed)
        }
    }
    
    func start() {
        startTime = CACurrentMediaTime()
        
        let displayLink = CADisplayLink(target: self, selector: #selector(handleStopwatchDisplayLink(_:)))
        displayLink.add(to: .main, forMode: .common)
        self.displayLink = displayLink
    }
    
    func pause() {
        displayLink?.invalidate()
        prevElapsed = elapsed
    }
    
    func reset() {
        prevElapsed = elapsed
    }
}
