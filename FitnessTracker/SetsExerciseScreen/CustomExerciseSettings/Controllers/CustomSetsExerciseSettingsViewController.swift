

import Foundation
import UIKit

//
//class CustomSetsExerciseSettingsViewController: UIViewController {
//    private var settings: ExerciseSettings
//    
//    init() {
//        settings = ExerciseSettings()
//
//        super.init(nibName: nil, bundle: nil)
//        
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func initViewWithSettings() {
//        let settingsView = UIView()
//        
//        var settingsScreen = view
//        
//        let setsSettingsView = ExerciseParamView(settingName: "Sets")
//        let repsSettingsView = ExerciseParamView(settingName: "Repeats")
//        let timeoutSettingsView = ExerciseParamView(settingName: "Timeout")
//        
//        settings.setObserving(forType: .Repeats) {
//            repsSettingsView.updateValue(s: self.settings.repeats.toString())
//        }
//        
//        settings.setObserving(forType: .Sets) {
//            setsSettingsView.updateValue(s: self.settings.sets.toString())
//        }
//        
//        settings.setObserving(forType: .Timeout) {
//            timeoutSettingsView.updateValue(s: self.settings.timeout.toString())
//        }
//        
//        setsSettingsView.addButtonTapGesture(funcCb: {
//            self.settings.sets.incValue()
//            
//        }, dec: false)
//        setsSettingsView.addButtonTapGesture(funcCb: {
//            self.settings.sets.decValue()
//        }, dec: true)
//        
//        repsSettingsView.addButtonTapGesture(funcCb: {
//            self.settings.repeats.incValue()
//        }, dec: false)
//        
//        repsSettingsView.addButtonTapGesture(funcCb: {
//            self.settings.repeats.decValue()
//        }, dec: true)
//        
//        
//        timeoutSettingsView.addButtonTapGesture(funcCb: {
//            self.settings.timeout.incValue()
//        }, dec: false)
//        
//        timeoutSettingsView.addButtonTapGesture(funcCb: {
//            self.settings.timeout.decValue()
//            
//        }, dec: true)
//        
//        settings.resetValues()
//        
//        let vStack = UIStackView()
//        vStack.axis = .vertical
//        vStack.spacing = 16
//        vStack.alignment = .fill
//        vStack.distribution = .equalSpacing
//        
//        
//        vStack.addArrangedSubview(setsSettingsView)
//        vStack.addArrangedSubview(repsSettingsView)
//        vStack.addArrangedSubview(timeoutSettingsView)
//        setsSettingsView.translatesAutoresizingMaskIntoConstraints = false
//        repsSettingsView.translatesAutoresizingMaskIntoConstraints = false
//        timeoutSettingsView.translatesAutoresizingMaskIntoConstraints = false
//        vStack.translatesAutoresizingMaskIntoConstraints = false
//        
//        settingsView.addSubview(vStack)
//        settingsView.layoutIfNeeded()
//        settingsView.isUserInteractionEnabled = true
//        
//        NSLayoutConstraint.activate([
//            vStack.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor),
//            vStack.trailingAnchor.constraint(equalTo: settingsView.trailingAnchor),
//            vStack.topAnchor.constraint(equalTo: settingsView.topAnchor),
//            vStack.bottomAnchor.constraint(lessThanOrEqualTo: settingsView.bottomAnchor),
//        ])
//        
//        settingsScreen?.addSubview(settingsView)
//        settingsScreen?.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            settingsView.leadingAnchor.constraint(equalTo: settingsScreen!.leadingAnchor, constant: 96),
//            settingsView.trailingAnchor.constraint(equalTo: settingsScreen!.trailingAnchor, constant: -96),
//            settingsView.centerYAnchor.constraint(equalTo: settingsScreen!.centerYAnchor),
//            settingsView.bottomAnchor.constraint(lessThanOrEqualTo: settingsScreen!.bottomAnchor),
//        ])
//        
//        
//        vStack.isUserInteractionEnabled = true
//        settingsView.translatesAutoresizingMaskIntoConstraints = false
//    }
//}
