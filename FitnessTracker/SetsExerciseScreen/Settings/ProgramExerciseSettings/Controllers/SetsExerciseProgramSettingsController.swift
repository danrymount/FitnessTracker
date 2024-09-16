
import Foundation
import UIKit

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
    
    var settingsProgramView = SetsExerciseInfoPreviewView()
    
    private func initViewWithSettings() {
        let levelSettingsView = {
            var view = ExerciseParamView(settingName: "Level")

            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }()
        
        func linkModelWithView(paramModel: SettingsParamModel<some Numeric & Comparable>, settingView: ExerciseParamView) {
            settingsModel.setLevelObserving {
                settingView.updateValue(s: paramModel.toString())
                settingView.setIncBtnEnable(!paramModel.isMaxReached)
                settingView.setDecBtnEnable(!paramModel.isMinReached)
                
                // TODO: maybe move as additional cb for func
                self.settingsProgramView.update(reps: self.settingsModel.settings.repsArr,
                                                timeout: self.settingsModel.settings.timeoutsArr[0])
            }
            
            settingView.addButtonTapGesture(funcCb: {
                paramModel.incValue()
            }, dec: false)
            settingView.addButtonTapGesture(funcCb: {
                paramModel.decValue()
            }, dec: true)
        }

        linkModelWithView(paramModel: settingsModel.level, settingView: levelSettingsView)
        
        settingsModel.resetValues()

        settingsProgramView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(levelSettingsView)
        view.addSubview(settingsProgramView)
        
        NSLayoutConstraint.activate([
            levelSettingsView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            levelSettingsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            levelSettingsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            levelSettingsView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor),
            levelSettingsView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor),
            settingsProgramView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingsProgramView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingsProgramView.topAnchor.constraint(greaterThanOrEqualTo: levelSettingsView.bottomAnchor),
            settingsProgramView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
        ])
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layoutSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewWithSettings()
    }
}
