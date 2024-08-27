
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
