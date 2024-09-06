
import Foundation
import UIKit

class SetsExerciseLadderSettingsController: UIViewController, SetsExerciseSettingsControllerProtocol {
    func getSettings() -> any SetsExerciseSettingsProtocol {
        return settingsModel.settings
    }
    
    @available(*, unavailable)
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
        
        func linkModelWithView(modelSettingType: SetsExerciseLadderSettingsModel.SettingType, paramModel: SettingsParamModel<some Numeric & Comparable>, settingView: ExerciseParamView) {
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
        
        linkModelWithView(modelSettingType: .from, paramModel: settingsModel.fromVal, settingView: fromSettingsView)
        
        linkModelWithView(modelSettingType: .to, paramModel: settingsModel.toVal, settingView: toSettingsView)
        
        linkModelWithView(modelSettingType: .steps, paramModel: settingsModel.stepsVal, settingView: stepsSettingsView)
        
        linkModelWithView(modelSettingType: .timeout, paramModel: settingsModel.timeoutVal, settingView: timeoutSettingsView)
        
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
