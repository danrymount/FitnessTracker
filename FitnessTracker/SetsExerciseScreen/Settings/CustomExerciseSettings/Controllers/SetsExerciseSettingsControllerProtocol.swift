//

import Foundation
import UIKit



protocol SetsExerciseSettingsControllerProtocol: UIViewController {
    func loadView()
    
    func viewDidLoad()
    
    func getSettings() -> SetsExerciseSettingsProtocol
}

class SesExerciseCustomSettingsController: UIViewController, SetsExerciseSettingsControllerProtocol {
    func getSettings() -> SetsExerciseSettingsProtocol {
        return settingsModel.settings
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboard is not supported")
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    var settingsModel = SetsExerciseCustomSettingsModel()
    
    func initViewWithSettings() {
        let settingsView = UIView()
        
        let setsSettingsView = ExerciseParamView(settingName: "Sets")
        let repsSettingsView = ExerciseParamView(settingName: "Repeats")
        let timeoutSettingsView = ExerciseParamView(settingName: "Timeout")
        
        settingsModel.setObserving(forType: .Repeats) {
            repsSettingsView.updateValue(s: self.settingsModel.repeats.toString())
        }
        
        settingsModel.setObserving(forType: .Sets) {
            setsSettingsView.updateValue(s: self.settingsModel.sets.toString())
        }
        
        settingsModel.setObserving(forType: .Timeout) {
            timeoutSettingsView.updateValue(s: self.settingsModel.timeout.toString())
        }
        
        setsSettingsView.addButtonTapGesture(funcCb: {
            self.settingsModel.sets.incValue()
            
        }, dec: false)
        setsSettingsView.addButtonTapGesture(funcCb: {
            self.settingsModel.sets.decValue()
        }, dec: true)
        
        repsSettingsView.addButtonTapGesture(funcCb: {
            self.settingsModel.repeats.incValue()
        }, dec: false)
        
        repsSettingsView.addButtonTapGesture(funcCb: {
            self.settingsModel.repeats.decValue()
        }, dec: true)
        
        
        timeoutSettingsView.addButtonTapGesture(funcCb: {
            self.settingsModel.timeout.incValue()
        }, dec: false)
        
        timeoutSettingsView.addButtonTapGesture(funcCb: {
            self.settingsModel.timeout.decValue()
            
        }, dec: true)
        
        settingsModel.resetValues()
        
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.spacing = 16
        vStack.alignment = .fill
        vStack.distribution = .equalSpacing
        
        
        vStack.addArrangedSubview(setsSettingsView)
        vStack.addArrangedSubview(repsSettingsView)
        vStack.addArrangedSubview(timeoutSettingsView)
        setsSettingsView.translatesAutoresizingMaskIntoConstraints = false
        repsSettingsView.translatesAutoresizingMaskIntoConstraints = false
        timeoutSettingsView.translatesAutoresizingMaskIntoConstraints = false
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        settingsView.addSubview(vStack)
        settingsView.layoutIfNeeded()
        settingsView.isUserInteractionEnabled = true
        
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: settingsView.trailingAnchor),
            vStack.topAnchor.constraint(equalTo: settingsView.topAnchor),
            vStack.bottomAnchor.constraint(lessThanOrEqualTo: settingsView.bottomAnchor),
        ])
        
        view.addSubview(settingsView)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingsView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            settingsView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor),
        ])
        
        
        vStack.isUserInteractionEnabled = true
        settingsView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewWithSettings()
    }
}
