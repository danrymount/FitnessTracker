
import Foundation
import UIKit

class SetsExerciseProgramSettingsController: UIViewController, SetsExerciseSettingsControllerProtocol {
    func getSettings() -> SetsExerciseSettingsProtocol {
        return settingsModel.settings
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboard is not supported")
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    var settingsModel = SetsExerciseProgramSettingsModel()
    
    func initViewWithSettings() {
        let settingsView = UIView()
        
        let levelSettingsView = ExerciseParamView(settingName: "Level")
        
        
        settingsModel.setLevelObserving {
            levelSettingsView.updateValue(s: self.settingsModel.level.toString())
        }
        
        
        levelSettingsView.addButtonTapGesture(funcCb: {
            self.settingsModel.level.incValue()
            
        }, dec: false)
        levelSettingsView.addButtonTapGesture(funcCb: {
            self.settingsModel.level.decValue()
        }, dec: true)
        
        
        settingsModel.resetValues()
        
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.spacing = 16
        vStack.alignment = .fill
        vStack.distribution = .equalSpacing
        
        
        vStack.addArrangedSubview(levelSettingsView)
        levelSettingsView.translatesAutoresizingMaskIntoConstraints = false
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
