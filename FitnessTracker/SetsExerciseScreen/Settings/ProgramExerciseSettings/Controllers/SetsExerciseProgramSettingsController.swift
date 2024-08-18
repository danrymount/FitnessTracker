
import Foundation
import UIKit

class SetsExerciseProgramView: UIView {
    var repsStackView: UIStackView = {
        var hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.distribution = .equalCentering
//        hStack.alignment = .fill
        hStack.spacing = 8
        
        return hStack
    }()
    
    init() {
        super.init(frame: CGRect())
        
        let vStack = {
            let view = UIStackView()
            view.axis = .vertical
            view.translatesAutoresizingMaskIntoConstraints = false
            
            view.layer.cornerRadius = 10
            view.layer.borderColor = UIColor(.black).cgColor
            view.layer.borderWidth = 1
            
            return view
        }()
        
        addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: self.topAnchor),
            vStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            vStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
        let lbSets = {
            let view = UILabel()
            view.text = "Sets"
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        vStack.addSubview(lbSets)
        vStack.addSubview(repsStackView)
        
        NSLayoutConstraint.activate([
            lbSets.topAnchor.constraint(equalTo: vStack.topAnchor, constant: 8),
            lbSets.centerXAnchor.constraint(equalTo: vStack.centerXAnchor),
            lbSets.leadingAnchor.constraint(greaterThanOrEqualTo: vStack.leadingAnchor),
            lbSets.trailingAnchor.constraint(lessThanOrEqualTo: vStack.trailingAnchor),
            repsStackView.topAnchor.constraint(equalTo: lbSets.bottomAnchor, constant: 8),
            repsStackView.leadingAnchor.constraint(equalTo: vStack.leadingAnchor, constant: 24),
            repsStackView.trailingAnchor.constraint(equalTo: vStack.trailingAnchor, constant: -24),
            repsStackView.bottomAnchor.constraint(equalTo: vStack.bottomAnchor, constant: -8),
        ])
    }
    
    func update(reps: [UInt], timeout: TimeInterval) {
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.0, options: UIView.AnimationOptions.curveLinear, animations: { [self] in
            self.alpha = 0
        })
        
        for sub in self.repsStackView.subviews {
            self.repsStackView.removeArrangedSubview(sub)
            sub.removeFromSuperview()
        }

        for rep in reps {
            let lb = PaddingLabel(insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
            lb.translatesAutoresizingMaskIntoConstraints = false
            lb.text = String(rep)

            lb.layer.cornerRadius = 10
            lb.backgroundColor = .systemBlue
            lb.textColor = .white
            lb.layer.masksToBounds = true
            lb.sizeToFit()
            self.repsStackView.addArrangedSubview(lb)
        }
        self.layoutSubviews()
        
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.0, options: UIView.AnimationOptions.curveLinear, animations: { [self] in
            self.alpha = 1
        })
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SetsExerciseProgramSettingsController: UIViewController, SetsExerciseSettingsControllerProtocol {
    func getSettings() -> SetsExerciseSettingsProtocol {
        return settingsModel.settings
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboard is not supported")
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    var settingsModel = SetsExerciseProgramSettingsModel()
    
    var settingsProgramView = SetsExerciseProgramView()
    
    private func initViewWithSettings() {
        let levelSettingsView = {
            var view = ExerciseParamView(settingName: "Level")
            
            view.addButtonTapGesture(funcCb: {
                self.settingsModel.level.incValue()
            }, dec: false)
            view.addButtonTapGesture(funcCb: {
                self.settingsModel.level.decValue()
            }, dec: true)
            
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }()

        settingsModel.setLevelObserving {
            levelSettingsView.updateValue(s: self.settingsModel.level.toString())
            
            self.settingsProgramView.update(reps: self.settingsModel.settings.repsArr,
                                            timeout: self.settingsModel.settings.timeoutsArr[0])
        }
        
        settingsModel.resetValues()

        settingsProgramView.translatesAutoresizingMaskIntoConstraints = false

        let vStack = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.spacing = 32
            stack.alignment = .fill
            stack.distribution = .equalSpacing
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.addArrangedSubview(levelSettingsView)
            stack.addArrangedSubview(settingsProgramView)
            
            return stack
        }()
        
        view.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vStack.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor),
            vStack.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor),
        ])
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layoutSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewWithSettings()
    }
}
