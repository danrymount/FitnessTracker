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
    
    @available(*, unavailable)
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
        
        func linkModelWithView(modelSettingType: SetsExerciseCustomSettingsModel.SettingType, paramModel: SettingsParamModel<some Numeric & Comparable>, settingView: ExerciseParamView) {
            settingsModel.setObserving(forType: modelSettingType) {
                settingView.updateValue(s: paramModel.toString())
                settingView.setIncBtnEnable(!paramModel.isMaxReached)
                settingView.setDecBtnEnable(!paramModel.isMinReached)
            }
            
            settingView.addButtonTapGesture(funcCb: {
                paramModel.incValue()
            }, dec: false)
            settingView.addButtonTapGesture(funcCb: {
                paramModel.decValue()
            }, dec: true)
        }
        
        linkModelWithView(modelSettingType: .Repeats, paramModel: settingsModel.repeats, settingView: repsSettingsView)
        
        linkModelWithView(modelSettingType: .Sets, paramModel: settingsModel.sets, settingView: setsSettingsView)
        
        linkModelWithView(modelSettingType: .Timeout, paramModel: settingsModel.timeout, settingView: timeoutSettingsView)
        
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
