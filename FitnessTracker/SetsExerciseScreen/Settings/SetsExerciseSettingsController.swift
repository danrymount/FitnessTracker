//

import Foundation
import UIKit



class SetsExerciseSettingsController: UIViewController {
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboard is not supported")
    }
    
    var onUpdateSettings: ((SetsExerciseSettingsProtocol) -> ())? = nil
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    var setsSettingsTypeSelectionView = ExerciseParamView(settingName: "Type")
    var exerciseSettingsController: SetsExerciseSettingsControllerProtocol?
    var exerciseTypeId: SetsExerciseType = .custom {
        didSet {
            setsSettingsTypeSelectionView.updateValue(s: exerciseTypeId.rawValue)
            updateSettingsView()
        }
    }
    
    
    
    var settingsView = UIView()
    
    func updateSettingsView() {
        for s in settingsView.subviews {
            s.removeFromSuperview()
        }
        
        settingsView.alpha = 0
        
        exerciseSettingsController?.removeFromParent()
        
        exerciseSettingsController = {
            switch exerciseTypeId {
                case .ladder:
                    return SesExerciseCustomSettingsController()
                case .program:
                    return SetsExerciseProgramSettingsController()
                case .custom:
                    return SesExerciseCustomSettingsController()
            }
            
        }()
        
        
        if let exController = exerciseSettingsController,
           let subcontrollerView = exController.view {
            
            onUpdateSettings?(exController.getSettings())
            
            add(exController)
            settingsView.translatesAutoresizingMaskIntoConstraints = false
            settingsView.addSubview(subcontrollerView)
            
            
            NSLayoutConstraint.activate([
                subcontrollerView.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor),
                subcontrollerView.trailingAnchor.constraint(equalTo: settingsView.trailingAnchor),
                subcontrollerView.bottomAnchor.constraint(equalTo: settingsView.bottomAnchor),
                subcontrollerView.topAnchor.constraint(equalTo: settingsView.topAnchor),
            ])
        }
        
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.0, options: UIView.AnimationOptions.curveLinear, animations: { [self] in
            settingsView.alpha = 1
        })
    }
    
    private func setupNavBar() {
        var handle: (UIAction) -> () = { action in
            
        }
        
        var menuHandler: UIActionHandler = { action in
            print(action)
            handle(action)
            
        }
        
        let actions: [UIAction:SetsExerciseType] =
        [
            UIAction(title: NSLocalizedString("Program", comment: ""), handler: menuHandler): .program,
            UIAction(title: NSLocalizedString("Ladder", comment: ""), handler: menuHandler): .ladder,
            UIAction(title: NSLocalizedString("Custom", comment: ""), handler: menuHandler): .custom,
        ]
        
        handle = { action in
            self.exerciseTypeId = actions[action] ?? .program
            self.parent?.navigationItem.rightBarButtonItem?.title = self.exerciseTypeId.rawValue
        }
        
        let barButtonMenu = UIMenu(title: "", children: Array(actions.keys))

        self.parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Type", image: nil, primaryAction: nil, menu: barButtonMenu)
    }
    
    override func removeFromParent() {
        self.parent?.navigationItem.rightBarButtonItem = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        
        
        view.addSubview(settingsView)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            settingsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            settingsView.topAnchor.constraint(equalTo: view.topAnchor),
        ])
        
        
        updateSettingsView()
        
    }
}

extension CaseIterable where Self: Equatable {
    
    func previous() -> Self {
        let all = Self.allCases
        var idx = all.firstIndex(of: self)!
        if idx == all.startIndex {
            let lastIndex = all.index(all.endIndex, offsetBy: -1)
            return all[lastIndex]
        } else {
            all.formIndex(&idx, offsetBy: -1)
            return all[idx]
        }
    }

    func next() -> Self {
        let all = Self.allCases
        let idx = all.firstIndex(of: self)!
        let next = all.index(after: idx)
        return all[next == all.endIndex ? all.startIndex : next]
    }
    
}
