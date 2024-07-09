
import Foundation
import UIKit

class SetsExerciseLadderSettingsController: UIViewController, SetsExerciseSettingsControllerProtocol {
    func getSettings() -> any SetsExerciseSettingsProtocol {
        return settingsModel.settings
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboard is not supported")
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    var settingsModel = SetsExerciseLadderSettingsModel()
    
    func initViewWithSettings() {
        let settingsView = UIView()
        
        let fromSettingsView = ExerciseParamView(settingName: "From")
        let toSettingsView = ExerciseParamView(settingName: "To")
        let stepsSettingsView = ExerciseParamView(settingName: "Steps")
        let timeoutSettingsView = ExerciseParamView(settingName: "Timeout")
        
        settingsModel.setObserving(forType: .from) {
            fromSettingsView.updateValue(s: self.settingsModel.fromVal.toString())
        }
        
        settingsModel.setObserving(forType: .to) {
            toSettingsView.updateValue(s: self.settingsModel.toVal.toString())
        }
        
        settingsModel.setObserving(forType: .steps) {
            stepsSettingsView.updateValue(s: self.settingsModel.stepsVal.toString())
        }
        
        settingsModel.setObserving(forType: .timeout) {
            timeoutSettingsView.updateValue(s: self.settingsModel.timeoutVal.toString())
        }
        
       
        fromSettingsView.addButtonTapGesture(funcCb: {
            self.settingsModel.fromVal.incValue()
        }, dec: false)
        fromSettingsView.addButtonTapGesture(funcCb: {
            self.settingsModel.fromVal.decValue()
        }, dec: true)
        
        toSettingsView.addButtonTapGesture(funcCb: {
            self.settingsModel.toVal.incValue()
        }, dec: false)
        toSettingsView.addButtonTapGesture(funcCb: {
            self.settingsModel.toVal.decValue()
        }, dec: true)
        
        
        stepsSettingsView.addButtonTapGesture(funcCb: {
            self.settingsModel.stepsVal.incValue()
        }, dec: false)
        stepsSettingsView.addButtonTapGesture(funcCb: {
            self.settingsModel.stepsVal.decValue()
        }, dec: true)
        
        timeoutSettingsView.addButtonTapGesture(funcCb: {
            self.settingsModel.timeoutVal.incValue()
        }, dec: false)
        timeoutSettingsView.addButtonTapGesture(funcCb: {
            self.settingsModel.timeoutVal.decValue()
        }, dec: true)
        
        settingsModel.resetValues()
        
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.spacing = 16
        vStack.alignment = .fill
        vStack.distribution = .equalSpacing
        
        
        vStack.addArrangedSubview(fromSettingsView)
        vStack.addArrangedSubview(toSettingsView)
        vStack.addArrangedSubview(stepsSettingsView)
        vStack.addArrangedSubview(timeoutSettingsView)
        fromSettingsView.translatesAutoresizingMaskIntoConstraints = false
        toSettingsView.translatesAutoresizingMaskIntoConstraints = false
        stepsSettingsView.translatesAutoresizingMaskIntoConstraints = false
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
