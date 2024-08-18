import Foundation
import UIKit

class SetsExerciseViewController: UIViewController, PopUpModalDelegate {
    enum ExerciseState {
        case initial
        case inProgress
        case timeout
        case paused
        case finished
    }
    
    private var roundTimerVC: RoundTimerViewController?
    
    private var state: ExerciseState
    
    private var settingsScreen: UIView?
    private var actionButton: UIButton?
    private var mainActionView: UIView?
    private var setsInfoView: SetsInfoView?
    private var repeatsLabelView: UILabel?
    private var activityType: ActivityType
    
    private var infoViewModel: SetsExerciseViewModel
    
    init(activityType: ActivityType) {
        infoViewModel = SetsExerciseViewModel(activityType: activityType)
        state = .initial
        
        self.activityType = activityType
        super.init(nibName: nil, bundle: nil)
        
        self.view.backgroundColor = UIColor.white
        self.title = self.activityType.toString()
    }
    
    @available(*, unavailable)
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
        if state != .initial {
            self.state = .finished
            changeState()
        } else {
            _ = navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func initScreen() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(backButtonCb(sender:)))
        
        let mainActionView = UIView()
        let actButton = UIButton()
        
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
        let buttonLabel: String = {
            switch forState {
            case .initial:
                return "Start"
            case .inProgress:
                if infoViewModel.isLastSet {
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
        self.roundTimerVC?.resetTimer()
        self.roundTimerVC?.view.isHidden = true
        
        if setsInfoView == nil {
            for v in mainActionView!.subviews {
                v.removeFromSuperview()
            }
            setsInfoView = SetsInfoView(sets: infoViewModel.allRepsArr)
            setsInfoView?.translatesAutoresizingMaskIntoConstraints = false
            mainActionView?.addSubview(setsInfoView!)
            NSLayoutConstraint.activate([
                setsInfoView!.centerXAnchor.constraint(equalTo: mainActionView!.centerXAnchor),
                setsInfoView!.leadingAnchor.constraint(lessThanOrEqualTo: mainActionView!.leadingAnchor, constant: 32),
                setsInfoView!.trailingAnchor.constraint(lessThanOrEqualTo: mainActionView!.trailingAnchor, constant: -32),
                setsInfoView!.topAnchor.constraint(equalTo: mainActionView!.bottomAnchor, constant: -48),
                setsInfoView!.bottomAnchor.constraint(equalTo: mainActionView!.bottomAnchor, constant: -16)
            ])
            
            let lb = UILabel()
            lb.text = String(infoViewModel.currentReps)
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
        
        setsInfoView?.markCompleted(amount: infoViewModel.completedSets)
    }
    
    func showTimeoutView() {
        if roundTimerVC == nil {
            roundTimerVC = RoundTimerViewController(duration: infoViewModel.currentTimeout, resolution: 1.0 / 120.0)
            guard let roundTimerVC = roundTimerVC, let mainActionView = mainActionView else {
                return
            }
            roundTimerVC.view.translatesAutoresizingMaskIntoConstraints = false
            add(roundTimerVC)
            NSLayoutConstraint.activate([
                roundTimerVC.view.leadingAnchor.constraint(equalTo: mainActionView.leadingAnchor, constant: 120),
                roundTimerVC.view.trailingAnchor.constraint(equalTo: mainActionView.trailingAnchor, constant: -120),
                roundTimerVC.view.topAnchor.constraint(equalTo: mainActionView.topAnchor, constant: 120),
                roundTimerVC.view.bottomAnchor.constraint(equalTo: mainActionView.bottomAnchor, constant: -120)
            ])
            roundTimerVC.setOnFinishCb {
                self.changeState()
            }
        }
        
        if let roundTimerVC = roundTimerVC {
            roundTimerVC.startTimer()
            roundTimerVC.view.isHidden = false
        }
    }
    
    let settingsController = SetsExerciseSettingsController()

    func initViewWithSettings() {
        settingsController.onUpdateSettings = { settings in
            self.infoViewModel.settings = settings
        }
        add(settingsController)
        
        settingsScreen = settingsController.view
        settingsScreen?.translatesAutoresizingMaskIntoConstraints = false
        
        self.mainActionView?.addSubview(settingsScreen!)
        
        NSLayoutConstraint.activate([
            settingsScreen!.leadingAnchor.constraint(equalTo: mainActionView!.leadingAnchor, constant: 60),
            settingsScreen!.trailingAnchor.constraint(equalTo: mainActionView!.trailingAnchor, constant: -60),
            settingsScreen!.topAnchor.constraint(equalTo: mainActionView!.topAnchor),
            settingsScreen!.bottomAnchor.constraint(equalTo: mainActionView!.bottomAnchor)
        ])
    }
    
    @objc func changeState(_ sender: UITapGestureRecognizer? = nil) {
        var newState: ExerciseState
        
        switch self.state {
        case .initial:
            settingsController.remove()
            newState = .inProgress
        case .inProgress:
            infoViewModel.setDone()
            setsInfoView?.markCompleted(amount: infoViewModel.completedSets)
            if !infoViewModel.isCompleted {
                newState = .timeout
            } else {
                newState = .finished
            }
        case .timeout:
            newState = .inProgress
        default:
            newState = .finished
        }
        
        if newState == .inProgress {
            repeatsLabelView?.isHidden = false
        } else {
            repeatsLabelView?.isHidden = true
        }
        
        self.state = newState
        print("New state \(self.state)")
        showViewState()
    }
    
    func getModalInfoView() -> UIView {
        let compositeView = UIView()
        let summaryLb = UILabel()
        compositeView.addSubview(summaryLb)
        summaryLb.translatesAutoresizingMaskIntoConstraints = false
        
//        summaryLb.text = """
        ////        Total \(self.activityType.toString()): \(self.exerciseInfo.completedSets * self.settings.repeats.value)
        ////        Duration: \((Date(timeIntervalSinceNow: TimeInterval()) - exerciseInfo.timeStart).stringFromTimeInterval())
//        """
        
        summaryLb.numberOfLines = 2
        NSLayoutConstraint.activate([
            summaryLb.topAnchor.constraint(equalTo: compositeView.topAnchor),
            summaryLb.leadingAnchor.constraint(equalTo: compositeView.leadingAnchor),
            summaryLb.bottomAnchor.constraint(lessThanOrEqualTo: compositeView.bottomAnchor),
            summaryLb.trailingAnchor.constraint(lessThanOrEqualTo: compositeView.trailingAnchor)
        ])
        summaryLb.backgroundColor = .clear
        return compositeView
    }

    func didTapCancel() {
        self.dismiss(animated: true)
    }
    
    func didTapAccept() {
        infoViewModel.save()
        
        // TODO: pop only in success
        _ = navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true)
    }
}
