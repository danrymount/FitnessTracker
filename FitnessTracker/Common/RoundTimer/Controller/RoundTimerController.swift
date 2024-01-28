
import UIKit


class RoundTimerViewController: UIViewController
{
    private var label : UILabel;
    private var circleIndicator: CircleProgressView
    private let timerDuration: TimeInterval;
    private let timerResolution: TimeInterval;
    private var timer:RoundTimer;
    private var circleIndicatorUIView: UIView;
    private var onFinishCb: () -> Void
    public var background :UIColor = .clear
    
    @objc
    private func onTimer(interval : TimeInterval)
    {
        label.text = "\(interval.stringFromTimeInterval())"
        circleIndicator.animateCircle(progress: interval/timerDuration, duration: 0.01, delay: 0)
        if (interval == 0)
        {
            onFinishCb()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        
        self.label.text = "\(timerDuration.stringFromTimeInterval())"
        self.label.backgroundColor = UIColor.clear
        
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.circleIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(circleIndicator)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            circleIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            circleIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            circleIndicator.topAnchor.constraint(equalTo: view.topAnchor),
            circleIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([

            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
    }
    
    func startTimer()
    {
        timer.start()
    }
    
    func resetTimer()
    {
        timer.reset()
    }
    
    func setOnFinishCb(onFinishCb: @escaping ()->Void)
    {
        self.onFinishCb = onFinishCb
    }
    
    func finish()
    {
        resetTimer()
        self.onFinishCb()
    }
    
    
    init(duration: TimeInterval, resolution: TimeInterval) {
        label = UILabel()
        circleIndicatorUIView = UIView()
        circleIndicator = CircleProgressView(progress: 1, baseColor: .lightGray, progressColor: .systemBlue)
        timerDuration = duration
        timerResolution = resolution
        // TODO Replace with CADisplayLink
        timer = RoundTimer(duration: duration, _stepDivider: resolution, _onStep:{_ in })
        onFinishCb = {}
        super.init(nibName: nil, bundle: nil)
        timer = RoundTimer(duration: duration, _stepDivider: resolution, _onStep: onTimer)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboard is not supported")
    }
}
