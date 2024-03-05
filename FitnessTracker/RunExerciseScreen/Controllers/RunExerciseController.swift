
import CoreMotion
import MapKit
import OSLog
import UIKit

enum RunExerciseState: String, CustomStringConvertible {
    case initial
    case readyToStart
    case inProgress
    case paused
    case finished

    var description: String {
        return self.rawValue
    }
}

class RunExerciseController: UIViewController, PopUpModalDelegate {
    func didTapCancel() {
        self.dismiss(animated: true)
    }
    
    func didTapAccept() {
        _ = navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true)
    }
    
    func getModalInfoView() -> UIView {
        var stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        
        let distanceLb = UILabel()
        distanceLb.text = "Distance: \(motionData.getDistanceStr())"
        
        let paceLb = UILabel()
        paceLb.text = "Pace: \(motionData.getPaceStr())"
        
        let stepsLb = UILabel()
        stepsLb.text = "Steps: \(motionData.getStepsStr())"
        
        distanceLb.translatesAutoresizingMaskIntoConstraints = false
        paceLb.translatesAutoresizingMaskIntoConstraints = false
        stepsLb.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addSubview(distanceLb)
        stack.addSubview(paceLb)
        stack.addSubview(stepsLb)
        
        NSLayoutConstraint.activate([
            distanceLb.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            distanceLb.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
            distanceLb.topAnchor.constraint(equalTo: stack.topAnchor),
            
            stepsLb.topAnchor.constraint(equalTo: distanceLb.bottomAnchor, constant: 12),
            stepsLb.leadingAnchor.constraint(equalTo: distanceLb.leadingAnchor),
            stepsLb.trailingAnchor.constraint(equalTo: distanceLb.trailingAnchor),
            
            paceLb.topAnchor.constraint(equalTo: stepsLb.bottomAnchor, constant: 12),
            paceLb.leadingAnchor.constraint(equalTo: distanceLb.leadingAnchor),
            paceLb.trailingAnchor.constraint(equalTo: distanceLb.trailingAnchor),
        
        ])
        
        return stack
    }
    
    private var _state: RunExerciseState = .initial
    
    func processManagerStatus() {
        if motionManagerStatus != .ready || (locationManagerStatus != .authorizedWhenInUse && locationManagerStatus != .authorizedAlways) {
            showWarningIcon(true)
        }
        else {
            showWarningIcon(false)
            state = .readyToStart
        }
    }
    
    var motionManagerStatus: MotionManagerStatus = .ready {
        didSet {
            Logger().info("motionManagerStatus set to \(String(describing: self.motionManagerStatus))")
            processManagerStatus()
        }
    }

    var locationManagerStatus: CLAuthorizationStatus = .notDetermined {
        didSet {
            Logger().info("locationManagerStatus set to \(String(describing: self.locationManagerStatus))")
            processManagerStatus()
        }
    }

    var runRouteData = RunRouteDataModel()
    var motionData = RunMotionDataModel()
    var locationManager: ExerciseLocationManagerProtocol
    var motionManager: ExerciseMotionManager = .init()
    var mapVC = MapViewController()
    
    var stopwatchService = StopwatchService()
    
    var distanceAfterLastLocation: Double = 0
    var activityData: RunExerciseDataModel?
    
    lazy var exerciseInfoView = {
        let exInfo = RunExerciseInfoView()
        exInfo.translatesAutoresizingMaskIntoConstraints = false
        exInfo.backgroundColor = .white
        exInfo.layer.cornerRadius = 25
        exInfo.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        exInfo.layer.borderColor = UIColor.gray.cgColor
        exInfo.layer.borderWidth = 1
        return exInfo
    }()

    @objc func onWarningIconPress(_ sender: UITapGestureRecognizer? = nil) {
        var msg = ""
        
        if motionManagerStatus == .error {
            msg += "Motion is not available\n"
        }
        if locationManagerStatus == .denied {
            msg += "Location service is disabled\n"
        }
        else if locationManagerStatus == .restricted {
            msg += "Location service is restricted\n"
        }
        
        let alert = UIAlertController(title: "Warning", message: String(msg.dropLast()), preferredStyle: .actionSheet)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil) })
    }
    
    func showWarningIcon(_ show: Bool) {
        if show {
            let btn = UIButton()
            btn.setImage(UIImage(systemName: "exclamationmark.triangle.fill"), for: .normal)
            btn.tintColor = .systemYellow
            btn.addTapGesture(tapNumber: 1, target: self, action: #selector(onWarningIconPress))
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
        }
        else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    func saveActivityData() {
        
//        ActivitiesRepositoryImpl.shared.updateActivity(data: activityData!)
    }
    
    private var state: RunExerciseState {
        get { return _state }
        set(newState) {
            switch newState {
                case .initial:
                    exerciseInfoView.setEnable(enable: false)
                case .readyToStart:
                    exerciseInfoView.setEnable(enable: true)
                    showWarningIcon(false)
                case .inProgress:
                    if state == .readyToStart {
                        activityData = RunExerciseDataModel(datetime: Date(timeIntervalSinceNow: 0))
                        ActivitiesRepositoryImpl.shared.createActivity(data: activityData!)
                    }
                    exerciseInfoView.state = .inProgress
                    stopwatchService.start()
                    locationManager.start()
                    motionManager.start()
                case .paused:
                    exerciseInfoView.state = .paused
                    exerciseInfoView.state = .paused
                    stopwatchService.pause()
                    locationManager.stop()
                    motionManager.stop()
                case .finished:
                    stopwatchService.pause()
                    locationManager.stop()
                    motionManager.stop()
            }
            
            _state = newState
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopwatchService.reset()
        locationManager.stop()
        motionManager.stop()
    }
    
    func showFinishDialog() {
        let view = PopUpModalViewController(delegate: self)
        view.delegate = self
        view.modalPresentationStyle = .overFullScreen
        view.modalTransitionStyle = .coverVertical
        self.present(view, animated: true)
    }
    
    @objc func backButtonCb(sender: AnyObject) {
        if state != .initial && state != .readyToStart {
            state = .paused
            showFinishDialog()
        }
        else {
            _ = navigationController?.popToRootViewController(animated: true)
        }
    }
    
    override func loadView() {
        super.loadView()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(backButtonCb(sender:)))
        
        mapVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mapVC.view)
        view.addSubview(exerciseInfoView)
        
        NSLayoutConstraint.activate([
            mapVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            exerciseInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            exerciseInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            exerciseInfoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        #if DEBUG
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .gray
        button.setTitle("D", for: .normal)
        view.addSubview(button)

        button.addTapGesture(tapNumber: 1, target: self, action: #selector(testRequestLocation(_:)))
        
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        #endif
    }
    
    init() {
        #if SIMULATE_LOCATION
        locationManager = DummyExerciseLocationManager()
        #else
        locationManager = ExerciseLocationManager()
        #endif
        
        super.init(nibName: nil, bundle: nil)
        
        title = "Run"
        
        exerciseInfoView.viewDelegate = self
        locationManager.locationDelegate = self
        motionManager.motionDelegate = self
        stopwatchService.onTimeUpdate = onStopwatchUpdate
        state = .initial
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboard is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        locationManager.configure()
        
        exerciseInfoView.setPaceStr(str: "--'--\"")
        exerciseInfoView.setStepsStr(str: "0 steps")
        locationManager.getCurrentLocation()
    }
}

extension RunExerciseController: ExerciseLocationDelegate {
    func onChangeLocation(locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        Logger.common.info("New location data: \(location)")
        
        runRouteData.routeCoordinates.append(location)
        
        if runRouteData.routeCoordinates.count == 1 {
            DispatchQueue.main.async {
                self.mapVC.setStartPoint(location: location.coordinate)
            }
        }
        else {
            DispatchQueue.main.async {
                self.mapVC.appendNewRoutePoint(location: location.coordinate)
            }
        }
        
        Logger.common.info("Total locations: \(self.runRouteData.routeCoordinates)")
    }
    
    func onChangeStatus(status: CLAuthorizationStatus) {
        // TODO: handle error
        print("New location status \(status)")
        locationManagerStatus = status
    }
}

extension RunExerciseController {
    func onStopwatchUpdate(elapsed: CFTimeInterval) {
        let totalElapsed = elapsed
        let hundredths = Int((totalElapsed * 100).rounded())
        let (minutes, hundredthsOfSeconds) = hundredths.quotientAndRemainder(dividingBy: 60 * 100)
        let (seconds, milliseconds) = hundredthsOfSeconds.quotientAndRemainder(dividingBy: 100)
        
        exerciseInfoView.setDurationStr(str: String(minutes) + ":" + String(format: "%02d", seconds) + "." + String(format: "%02d", milliseconds))
    }
}

extension RunExerciseController: RunExerciseInfoViewDelegate {
    func startButtonPressed() {
        state = .inProgress
    }
    
    func finishButtonPressed() {
        state = .finished
    }
    
    func pauseButtonPressed() {
        state = .paused
    }
}

extension RunExerciseController: ExerciseMotionDelegate {
    func onChangeStatus(status: MotionManagerStatus) {
        DispatchQueue.main.async {
            self.motionManagerStatus = status
        }
    }
    
    func onChangeData(data: RunMotionDataModel) {
        Logger.common.info("New motion data: \(String(describing: data))")
        if let newDist = data.distance {
            if newDist - distanceAfterLastLocation > 10 {
                locationManager.getCurrentLocation()
                distanceAfterLastLocation = newDist
            }
        }
        
        self.motionData = data
        
        if let newDist = motionData.distance {
            activityData?.distance = newDist
        }
        
        if let newPace = motionData.avgPace {
            activityData?.pace = newPace
        }
        
        activityData?.steps = Int64(motionData.steps)

        DispatchQueue.main.async {
            self.exerciseInfoView.setPaceStr(str: self.motionData.getPaceStr())
            self.exerciseInfoView.setStepsStr(str: self.motionData.getStepsStr())
            self.exerciseInfoView.setDistanceStr(str: self.motionData.getDistanceStr())
        }
    }
}

extension RunExerciseController {
    @objc func testRequestLocation(_ sender: UITapGestureRecognizer? = nil) {
        locationManager.getCurrentLocation()
    }
}
