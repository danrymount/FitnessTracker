
import CoreMotion
import MapKit
import UIKit

enum RunExerciseState {
    case initial
    case inProgress
    case paused
    case finished
}

class RunExerciseController: UIViewController {
    private var _state: RunExerciseState = .initial

    var runRouteData = RunRouteDataModel()
    var motionData = RunMotionDataModel()
    var locationManager: ExerciseLocationManagerProtocol = ExerciseLocationManager()
    var motionManager: ExerciseMotionManager = .init()
    var mapVC = MapViewController()
    
    private weak var displayLink: CADisplayLink?
    var startTime: CFTimeInterval?
    private var elapsed: CFTimeInterval = 0
    private var priorElapsed: CFTimeInterval = 0
    
    var exerciseInfoView = {
        let exInfo = RunExerciseInfoView()
        exInfo.translatesAutoresizingMaskIntoConstraints = false
        exInfo.backgroundColor = .white
        exInfo.layer.cornerRadius = 25
        exInfo.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        exInfo.layer.borderColor = UIColor.gray.cgColor
        exInfo.layer.borderWidth = 1
        return exInfo
    }()
    
    private var state: RunExerciseState {
        get { return _state }
        set(newState) {
            switch newState {
                case .initial:
                    break
                case .inProgress:
                    startTimer()
                    locationManager.start()
                    motionManager.start()
                case .paused:
                    pauseTimer()
                    locationManager.stop()
                    motionManager.stop()
                case .finished:
                    pauseTimer()
                    locationManager.stop()
                    motionManager.stop()
            }
            
            _state = newState
        }
    }
    
    func startTimer() {
        if displayLink == nil {
            startDisplayLink()
        }
    }
    
    func pauseTimer() {
        priorElapsed += elapsed
        elapsed = 0
        stopDisplayLink()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopDisplayLink()
        locationManager.stop()
        motionManager.stop()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        setupLayout()
        
        exerciseInfoView.viewDelegate = self
        
        locationManager.locationDelegate = self
        locationManager.configure()
        
        motionManager.motionDelegate = self
        
        exerciseInfoView.setPaceStr(str: "--/--")
        exerciseInfoView.setStepsStr(str: "0 steps")
    }
    
    @objc func addDummyCord(_ sender: UITapGestureRecognizer? = nil) {
        if let lastCoord = runRouteData.routeCoordinates.last {
            let newLat = lastCoord.coordinate.latitude + Double(Int.random(in: 0...10))/50000 * Double(Int.random(in: -1...1))
            let newLong = lastCoord.coordinate.longitude + Double(Int.random(in: 0...10))/50000
            var newCoord = CLLocation(latitude: newLat, longitude: newLong)
            
            runRouteData.routeCoordinates.append(newCoord)
            mapVC.setStartPoint(location: newCoord.coordinate)
            runRouteData.totalDistance += newCoord.distance(from: lastCoord)
            exerciseInfoView.setDistanceStr(str: "\(runRouteData.totalDistance.rounded()) m.")
        }
    }
    
    func setupLayout() {
        mapVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mapVC.view)
        view.addSubview(exerciseInfoView)
        
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .gray
        button.setTitle("D", for: .normal)
        view.addSubview(button)
        
        button.addTapGesture(tapNumber: 1, target: self, action: #selector(addDummyCord(_:)))
        
        NSLayoutConstraint.activate([
            mapVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            exerciseInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            exerciseInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            exerciseInfoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            exerciseInfoView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -360),
            
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension RunExerciseController: ExerciseLocationDelegate {
    func onChangeLocation(locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print(location)
        mapVC.setStartPoint(location: location.coordinate)
        if let lastCoord = runRouteData.routeCoordinates.last {
//            runRouteData.totalDistance += location.distance(from: lastCoord)
//            exerciseInfoView.setDistanceStr(str: "\(runRouteData.totalDistance.rounded()) m.")
        }
        runRouteData.routeCoordinates.append(location)
    }
    
    func onChangeStatus(status: CLAuthorizationStatus) {}
}

extension RunExerciseController {
    func startDisplayLink() {
        startTime = CACurrentMediaTime()
        let displayLink = CADisplayLink(target: self, selector: #selector(handleDisplayLink(_:)))
        displayLink.add(to: .main, forMode: .common)
        self.displayLink = displayLink
    }
    
    func stopDisplayLink() {
        displayLink?.invalidate()
    }
    
    @objc func handleDisplayLink(_ displayLink: CADisplayLink) {
        guard let startTime = startTime else { return }
        elapsed = CACurrentMediaTime() - startTime
        updateUI()
    }
    
    func updateUI() {
        let totalElapsed = elapsed + priorElapsed
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
    func onChangeData(data: RunMotionDataModel) {
        print(data)
        DispatchQueue.main.async {
            self.motionData = data
            self.exerciseInfoView.setPaceStr(str: self.motionData.getPaceStr())
            self.exerciseInfoView.setStepsStr(str: self.motionData.getStepsStr())
            self.exerciseInfoView.setDistanceStr(str: self.motionData.getDistanceStr())
        }
    }
}
