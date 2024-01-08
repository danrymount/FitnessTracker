import Foundation
import UIKit


struct ExerciseInfo {
    var completedSets: UInt
    var timeStart: Date
}


class SetsExerciseViewController: UIViewController, PopUpModalDelegate {
    enum ExerciseState {
        case initial
        case inProgress
        case timeout
        case paused
        case finished
    }
    
    private var RoundTimerVC: RoundTimerViewController?
    
    private var state: ExerciseState
    private var settings: ExerciseSettings
    
    private var settingsScreen: UIView?
    private var actionButton: UIButton?
    private var mainActionView: UIView?
    private var setsInfoView: SetsInfoView?
    private var repeatsLabelView: UILabel?
    private var exerciseInfo: ExerciseInfo
    private var activityType: ActivityType
    
    
    init(activityType: ActivityType) {
        settings = ExerciseSettings()
        state = .initial
        exerciseInfo = ExerciseInfo(completedSets: 0, timeStart: Date.init(timeIntervalSinceNow: TimeInterval()))
        self.activityType = activityType
        super.init(nibName: nil, bundle: nil)
        
        self.view.backgroundColor = UIColor.white
        self.title = self.activityType.toString()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboard is not supported")
    }
    
    override func loadView() {
        super.loadView()
        initScreen()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showViewState()
    }
    
    @objc func backButtonCb(sender: AnyObject) {
        if state != .initial
        {
            self.state = .finished
            changeState()
        }
        else
        {
            _ = navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func initScreen() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(backButtonCb(sender:)))
        
        var mainActionView = UIView()
        var actButton = UIButton()
        
        actButton.backgroundColor = .systemBlue
        view.addSubview(actButton)
        actButton.translatesAutoresizingMaskIntoConstraints = false
        actButton.layer.cornerRadius = 10
        NSLayoutConstraint.activate([
            actButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 54),
            actButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -54),
            actButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            actButton.heightAnchor.constraint(equalToConstant: 36)
        ])
        actButton.addTapGesture(tapNumber: 1, target: self, action: #selector(changeState(_:)))
        
        actionButton = actButton
        
        mainActionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainActionView)
        
        NSLayoutConstraint.activate([
            mainActionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainActionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainActionView.bottomAnchor.constraint(equalTo: actButton.safeAreaLayoutGuide.topAnchor, constant: -16),
            mainActionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        
        self.mainActionView = mainActionView
    }
    
    func configureActionButton(forState: ExerciseState) {
        let buttonLabel: String =
        {
            switch forState {
            case .initial:
                return "Start"
            case .inProgress:
                if exerciseInfo.completedSets == settings.sets.value {
                    return "Finish"
                } else {
                    return "Next"
                }
            case .timeout:
                return "Skip"
            case .finished:
                return "Finish"
            default:
                return "Undef"
            }
        }()
        
        actionButton?.setTitle(buttonLabel, for: .normal)
    }
    
    func showViewState() {
        switch self.state {
        case .initial:
            if settingsScreen == nil {
                initViewWithSettings()
            }
            self.mainActionView?.addSubview(settingsScreen!)
            
            NSLayoutConstraint.activate([
                settingsScreen!.leadingAnchor.constraint(equalTo: mainActionView!.leadingAnchor),
                settingsScreen!.trailingAnchor.constraint(equalTo: mainActionView!.trailingAnchor),
                settingsScreen!.topAnchor.constraint(equalTo: mainActionView!.topAnchor),
                settingsScreen!.bottomAnchor.constraint(equalTo: mainActionView!.bottomAnchor)
            ])
            self.settings.resetValues()
        case .inProgress:
            showInProgressView()
        case .timeout:
            showTimeoutView()
        case .finished:
            let view = PopUpModalViewController(delegate: self)
            view.delegate = self
            view.modalPresentationStyle = .overFullScreen
            view.modalTransitionStyle = .coverVertical
            self.present(view, animated: true)
        default:
            break
        }
        
        configureActionButton(forState: self.state)
        
    }
    
    func showInProgressView() {
        self.RoundTimerVC?.resetTimer()
        self.RoundTimerVC?.view.isHidden = true
        
        if setsInfoView == nil {
            for v in mainActionView!.subviews {
                v.removeFromSuperview()
            }
            setsInfoView = SetsInfoView(sets: (0..<settings.sets.value).map { _ in
                settings.repeats.value
            })
            setsInfoView?.translatesAutoresizingMaskIntoConstraints = false
            mainActionView?.addSubview(setsInfoView!)
            NSLayoutConstraint.activate([
                setsInfoView!.centerXAnchor.constraint(equalTo: mainActionView!.centerXAnchor),
                setsInfoView!.leadingAnchor.constraint(lessThanOrEqualTo: mainActionView!.leadingAnchor, constant: 32),
                setsInfoView!.trailingAnchor.constraint(lessThanOrEqualTo: mainActionView!.trailingAnchor, constant: -32),
                setsInfoView!.topAnchor.constraint(equalTo: mainActionView!.bottomAnchor, constant: -48),
                setsInfoView!.bottomAnchor.constraint(equalTo: mainActionView!.bottomAnchor, constant: -16)
            ])
            
            var lb = UILabel()
            lb.text = settings.repeats.toString()
            lb.textColor = .black
            lb.font = lb.font.withSize(32)
            lb.translatesAutoresizingMaskIntoConstraints = false
            mainActionView?.addSubview(lb)
            
            NSLayoutConstraint.activate([
                lb.centerXAnchor.constraint(equalTo: mainActionView!.centerXAnchor),
                lb.topAnchor.constraint(equalTo: mainActionView!.centerYAnchor, constant: -100),
                lb.bottomAnchor.constraint(equalTo: mainActionView!.centerYAnchor, constant: 100)
            ])
            
            repeatsLabelView = lb
        }
        
        setsInfoView?.markCompleted(amount: Int(exerciseInfo.completedSets + 1))
    }
    
    func showTimeoutView() {
        if RoundTimerVC == nil {
            print(settings.timeout.value)
            RoundTimerVC = RoundTimerViewController(duration: settings.timeout.value, resolution: 1.0/120.0)
            RoundTimerVC!.view.translatesAutoresizingMaskIntoConstraints = false
            add(RoundTimerVC!)
            NSLayoutConstraint.activate([
                RoundTimerVC!.view.leadingAnchor.constraint(equalTo: mainActionView!.leadingAnchor, constant: 120),
                RoundTimerVC!.view.trailingAnchor.constraint(equalTo: mainActionView!.trailingAnchor, constant: -120),
                RoundTimerVC!.view.topAnchor.constraint(equalTo: mainActionView!.topAnchor, constant: 120),
                RoundTimerVC!.view.bottomAnchor.constraint(equalTo: mainActionView!.bottomAnchor, constant: -120)
            ])
            RoundTimerVC!.setOnFinishCb {
                self.changeState()
            }
        }
        RoundTimerVC!.startTimer()
        self.RoundTimerVC!.view.isHidden = false
    }
    
    
    func initViewWithSettings() {
        var settingsView = UIView()
        
        settingsScreen = UIView()
        
        var setsSettingsView = ExerciseParamView(settingName: "Sets")
        var repsSettingsView = ExerciseParamView(settingName: "Repeats")
        var timeoutSettingsView = ExerciseParamView(settingName: "Timeout")
        
        settings.setObserving(forType: .Repeats) {
            repsSettingsView.updateValue(s: self.settings.repeats.toString())
        }
        
        settings.setObserving(forType: .Sets) {
            setsSettingsView.updateValue(s: self.settings.sets.toString())
        }
        
        settings.setObserving(forType: .Timeout) {
            timeoutSettingsView.updateValue(s: self.settings.timeout.toString())
        }
        
        setsSettingsView.addButtonTapGesture(funcCb: {
            self.settings.sets.incValue()
            
        }, dec: false)
        setsSettingsView.addButtonTapGesture(funcCb: {
            self.settings.sets.decValue()
        }, dec: true)
        
        repsSettingsView.addButtonTapGesture(funcCb: {
            self.settings.repeats.incValue()
        }, dec: false)
        
        repsSettingsView.addButtonTapGesture(funcCb: {
            self.settings.repeats.decValue()
        }, dec: true)
        
        
        timeoutSettingsView.addButtonTapGesture(funcCb: {
            self.settings.timeout.incValue()
        }, dec: false)
        
        timeoutSettingsView.addButtonTapGesture(funcCb: {
            self.settings.timeout.decValue()
            
        }, dec: true)
        
        settings.resetValues()
        
        var vStack = UIStackView()
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
        
        settingsScreen?.addSubview(settingsView)
        settingsScreen?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingsView.leadingAnchor.constraint(equalTo: settingsScreen!.leadingAnchor, constant: 96),
            settingsView.trailingAnchor.constraint(equalTo: settingsScreen!.trailingAnchor, constant: -96),
            settingsView.centerYAnchor.constraint(equalTo: settingsScreen!.centerYAnchor),
            settingsView.bottomAnchor.constraint(lessThanOrEqualTo: settingsScreen!.bottomAnchor),
        ])
        
        
        vStack.isUserInteractionEnabled = true
        settingsView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func changeState(_ sender: UITapGestureRecognizer? = nil) {
        var newState: ExerciseState
        
        switch self.state {
        case .initial:
            newState = .inProgress
        case .inProgress:
            exerciseInfo.completedSets += 1
            if exerciseInfo.completedSets < settings.sets.value {
                newState = .timeout
            } else {
                newState = .finished
            }
        case .timeout:
            newState = .inProgress
        default:
            newState = .finished
            break
        }
        
        if newState == .inProgress
        {
            repeatsLabelView?.isHidden = false
        }
        else
        {
            repeatsLabelView?.isHidden = true
        }
        
        self.state = newState
        print("New state \(self.state)")
        showViewState()
    }
    
    
    func getModalInfoView() -> UIView {
        let compositeView = UIView()
        var r = UILabel()
        compositeView.addSubview(r)
        r.translatesAutoresizingMaskIntoConstraints = false
        
        
        r.text = """
        Total \(self.activityType.toString()): \(self.exerciseInfo.completedSets * self.settings.repeats.value)
        Duration: \((Date(timeIntervalSinceNow: TimeInterval()) - exerciseInfo.timeStart).stringFromTimeInterval())
        """
        
        r.numberOfLines = 2
        NSLayoutConstraint.activate([
            r.topAnchor.constraint(equalTo: compositeView.topAnchor),
            r.leadingAnchor.constraint(equalTo: compositeView.leadingAnchor),
            r.bottomAnchor.constraint(lessThanOrEqualTo: compositeView.bottomAnchor),
            r.trailingAnchor.constraint(lessThanOrEqualTo: compositeView.trailingAnchor),
        ])
        r.backgroundColor = .clear
        return compositeView
    }
    func didTapCancel() {
        self.dismiss(animated: true)
    }
    
    func didTapAccept() {
        let completedAmount = self.exerciseInfo.completedSets * self.settings.repeats.value
        let exerciseDuration = Date(timeIntervalSinceNow: TimeInterval()) - exerciseInfo.timeStart
        ActivitiesRepositoryImpl.shared.insertActivityData(data: ActivityDataModel(id: 0, performedAmount: Double(completedAmount), duration: exerciseDuration, type: self.activityType, datetime: Date.init(timeIntervalSinceNow: TimeInterval())))
        _ = navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true)
    }
}


fileprivate extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else {
            return
        }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}

fileprivate extension Date {
    
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
}
