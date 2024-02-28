
import Foundation
import UIKit

protocol RunExerciseInfoViewDelegate: AnyObject {
    func startButtonPressed()
    func finishButtonPressed()
    func pauseButtonPressed()
}

enum ExerciseInfoViewState {
    case inited
    case inProgress
    case paused
}

class RunExerciseInfoView: UIView {
    var enabled = true
    var viewDelegate: RunExerciseInfoViewDelegate?
    var _state: ExerciseInfoViewState = .inited
    var state: ExerciseInfoViewState
    {
        get {
            return _state
        }
        set (newVal)
        {
            if newVal == .inProgress {
                if _state == .inited {
                    self.finishButton.isHidden = false
                    
                    UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                        
                        // Disable previous center constaints
                        for constraint in self.buttonStackView.constraints {
                            if let btn = constraint.firstItem as? UIButton {
                                if ( btn == self.startPauseButton || btn == self.finishButton )
                                    && constraint.firstAttribute == .centerX
                                {
                                    constraint.isActive = false
                                }
                            }
                        }
                        
                        NSLayoutConstraint.activate([
                            self.startPauseButton.centerXAnchor.constraint(equalTo: self.stackView.centerXAnchor, constant: -self.startPauseButton.intrinsicContentSize.width),
                            self.finishButton.centerXAnchor.constraint(equalTo: self.stackView.centerXAnchor, constant: self.finishButton.intrinsicContentSize.width),
                        ])
                        
                        self.layoutIfNeeded()
                    }, completion: nil)
                }
                
                self.startPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            }
            else
            {
                startPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            }
            
            _state = newVal
        }
    }
    
    func setEnable(enable: Bool)
    {
        startPauseButton.isEnabled = enable
        finishButton.isEnabled = enable
        
        enabled = enable
    }
    
    lazy var distanceLabel = {
        let lb = UILabel()
        lb.font = UIFont.monospacedDigitSystemFont(ofSize: 15, weight: .regular)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    lazy var durationLabel = {
        let lb = UILabel()
        lb.font = UIFont.monospacedDigitSystemFont(ofSize: 15, weight: .regular)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    lazy var stepsLabel = {
        let lb = UILabel()
        lb.font = UIFont.monospacedDigitSystemFont(ofSize: 15, weight: .regular)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    lazy var paceLabel = {
        let lb = UILabel()
        lb.font = UIFont.monospacedDigitSystemFont(ofSize: 15, weight: .regular)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    
    
    lazy var startPauseButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName:"play.fill"), for: .normal)
        btn.backgroundColor = .systemBlue
        btn.tintColor = .white
        btn.contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        btn.layer.cornerRadius = 56/2
        
        NSLayoutConstraint.activate([
            btn.widthAnchor.constraint(equalToConstant: 56),
            btn.heightAnchor.constraint(equalToConstant: 56),
        ])
        
        return btn
    }()
    
    lazy var finishButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName:"flag.fill"), for: .normal)
        btn.backgroundColor = .systemBlue
        btn.tintColor = .white
        btn.contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        btn.layer.cornerRadius = 56/2
        
        NSLayoutConstraint.activate([
            btn.widthAnchor.constraint(equalToConstant: 56),
            btn.heightAnchor.constraint(equalToConstant: 56),
        ])
        
        return btn
    }()
    
    lazy var stackView = UIStackView()
    lazy var buttonStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    
    init() {
        super.init(frame: CGRect())
        
        startPauseButton.addTapGesture(tapNumber: 1, target: self, action: #selector(onStartPauseButtonPressed))
        
        stackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.translatesAutoresizingMaskIntoConstraints = false
            
            let label = {
                let lb = UILabel()
                lb.font = .boldSystemFont(ofSize: 17)
                lb.text = "Run"
                lb.translatesAutoresizingMaskIntoConstraints = false
                return lb
            }()
            
            
            stack.addSubview(label)
            stack.addSubview(distanceLabel)
            stack.addSubview(durationLabel)
            stack.addSubview(paceLabel)
            stack.addSubview(stepsLabel)
            stack.addSubview(buttonStackView)
            buttonStackView.addSubview(startPauseButton)
            
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: stack.topAnchor),
                label.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
                
                distanceLabel.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
                distanceLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
                
                durationLabel.topAnchor.constraint(equalTo: distanceLabel.topAnchor),
                durationLabel.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
                
                stepsLabel.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 8),
                stepsLabel.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
                
                paceLabel.topAnchor.constraint(equalTo: stepsLabel.bottomAnchor, constant: 8),
                paceLabel.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
                
                buttonStackView.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
                buttonStackView.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
                buttonStackView.topAnchor.constraint(equalTo: paceLabel.bottomAnchor, constant: 40),

                startPauseButton.centerXAnchor.constraint(equalTo: buttonStackView.centerXAnchor),
                startPauseButton.bottomAnchor.constraint(equalTo: buttonStackView.bottomAnchor),
                buttonStackView.heightAnchor.constraint(equalTo: startPauseButton.heightAnchor),
                buttonStackView.bottomAnchor.constraint(equalTo: stack.bottomAnchor)
            ])
            
            // Place finish button below startPause button
            buttonStackView.insertSubview(finishButton, belowSubview: startPauseButton)
            NSLayoutConstraint.activate([
                finishButton.topAnchor.constraint(equalTo: startPauseButton.topAnchor),
                finishButton.centerXAnchor.constraint(equalTo: startPauseButton.centerXAnchor),
                
            ])
            finishButton.isHidden = true
            
            return stack
        }()
        
        distanceLabel.text = "0 m"
        durationLabel.text = "00:00"
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc func onStartPauseButtonPressed(_ sender: UITapGestureRecognizer? = nil) {
        if state == .inited || state == .paused
        {
            state = .inProgress
            viewDelegate?.startButtonPressed()
        }
        else {
            viewDelegate?.pauseButtonPressed()
            state = .paused
        }
    }
    
    func setDurationStr(str: String) {
        durationLabel.text = str
    }
    
    func setDistanceStr(str: String) {
        distanceLabel.text = str
    }
    
    func setPaceStr(str: String) {
        paceLabel.text = str
    }
    
    func setStepsStr(str: String) {
        stepsLabel.text = str
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
}
