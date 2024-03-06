
import Foundation
import UIKit
import SwiftUI


class ActivitySelectionViewController: UIViewController {
    private var stackViewInScreen : UIStackView?
    
    var stackView: UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        return stack
    }
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let scrollStackViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollStackViewContainer)
        
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        scrollStackViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollStackViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollStackViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollStackViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        scrollStackViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        configureContainerView()
    }
    
    @objc func handleTapRun(_ sender: UITapGestureRecognizer? = nil) {
        navigateToActivity(activityType: .Run)
    }
    
    @objc func handleTapPushups(_ sender: UITapGestureRecognizer? = nil) {
        navigateToActivity(activityType: .Push_ups)
    }
    
    @objc func handleTapSquats(_ sender: UITapGestureRecognizer? = nil) {
        navigateToActivity(activityType: .Squats)
    }
    
    private func configureContainerView() {
        let acts: [ActivityType] = [.Push_ups, .Squats, .Run]
        
        for act in acts
        {
            let a = ActivitySelectionCard(frame: CGRect(), activityType: act )
            
            let selector : Selector = {
                switch act
                {
                case .Push_ups:
                    return #selector(handleTapPushups(_:))
                case .Run:
                    return #selector(handleTapRun(_:))
                case .Squats:
                    return #selector(handleTapSquats(_:))
                }
            }()
            
            a.addTapGesture(tapNumber: 1, target: self, action: selector)
            scrollStackViewContainer.addArrangedSubview(a)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setupScrollView()
        
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @objc func navigateToActivity(_ sender: UITapGestureRecognizer? = nil, activityType: ActivityType) {
        var newVC: UIViewController? = nil
        switch activityType
        {
        case .Push_ups:
            newVC = SetsExerciseViewController(activityType: .Push_ups)
        case .Squats:
            newVC = SetsExerciseViewController(activityType: .Squats)
        case .Run:
            newVC = RunExerciseController()
            break
        }
        
        if let vc = newVC
        {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboard is not supported")
    }
    
}



struct ActivitySelectionViewControllerRepres : UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return ActivitySelectionViewController()
    }
}
