

import UIKit

public protocol PopUpModalDelegate: AnyObject {
    func didTapCancel()
    func didTapAccept()
    func getModalInfoView() -> UIView
}

public final class PopUpModalViewController: UIViewController {
    
    private static func create(
        delegate: PopUpModalDelegate
    ) -> PopUpModalViewController {
        let view = PopUpModalViewController(delegate: delegate)
        return view
    }
    
    @discardableResult
    static public func present(
        initialView: UIViewController,
        delegate: PopUpModalDelegate
    ) -> PopUpModalViewController {
        let view = PopUpModalViewController.create(delegate: delegate)
        view.modalPresentationStyle = .overFullScreen
        view.modalTransitionStyle = .coverVertical
        initialView.present(view, animated: true)
        return view
    }
    
    public init(delegate: PopUpModalDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public weak var delegate: PopUpModalDelegate?
    
    private lazy var canvas: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
        let b: UIButton = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = .systemGray
        b.setTitle("Cancel", for: .normal)
        b.layer.cornerRadius = 10
        b.addTarget(self, action: #selector(self.didTapCancel(_:)), for: .touchUpInside)
        return b
    }()
    
    private lazy var acceptButton: UIButton = {
        let b: UIButton = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = .systemBlue
        b.setTitle("Save", for: .normal)
        b.layer.cornerRadius = 10
        b.addTarget(self, action: #selector(self.didTapAccept(_:)), for: .touchUpInside)
        return b
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }
    
    @objc func didTapCancel(_ btn: UIButton) {
        self.delegate?.didTapCancel()
    }
    
    @objc func didTapAccept(_ btn: UIButton) {
        self.delegate?.didTapAccept()
    }
    
    
    private func setupViews() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        self.view.addSubview(canvas)
        let headerLb = UILabel()
        headerLb.text = "Workout info"
        headerLb.font = UIFont.boldSystemFont(ofSize: 32)
        headerLb.translatesAutoresizingMaskIntoConstraints = false
        headerLb.textAlignment = .center
        self.canvas.addSubview(headerLb)
        self.canvas.addSubview(acceptButton)
        self.canvas.addSubview(cancelButton)
        
        let mainView : UIView =
        {
            if self.delegate != nil
            {
                return (self.delegate?.getModalInfoView())!
            }
            
            return UIView()
        }()
        
        mainView.translatesAutoresizingMaskIntoConstraints = false
        self.canvas.addSubview(mainView)
        
       
        NSLayoutConstraint.activate([
            self.canvas.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.canvas.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.canvas.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.8),
            self.canvas.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.5),
            
            headerLb.topAnchor.constraint(equalTo: self.canvas.topAnchor, constant: 16),
            headerLb.leadingAnchor.constraint(equalTo: self.canvas.leadingAnchor, constant: 8),
            headerLb.trailingAnchor.constraint(equalTo: self.canvas.trailingAnchor, constant: -8),
            
            self.cancelButton.heightAnchor.constraint(equalToConstant: 32),
            self.cancelButton.bottomAnchor.constraint(equalTo: self.canvas.bottomAnchor, constant: -16),
            self.cancelButton.trailingAnchor.constraint(equalTo: self.canvas.trailingAnchor, constant: -8),
            self.cancelButton.leadingAnchor.constraint(equalTo: self.canvas.centerXAnchor, constant: 8),
            
            self.acceptButton.heightAnchor.constraint(equalToConstant: 32),
            self.acceptButton.bottomAnchor.constraint(equalTo: self.canvas.bottomAnchor, constant: -16),
            self.acceptButton.leadingAnchor.constraint(equalTo: self.canvas.leadingAnchor, constant: 8),
            self.acceptButton.trailingAnchor.constraint(equalTo: self.canvas.centerXAnchor, constant: -8),
        ])
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: headerLb.bottomAnchor, constant: 8),
            mainView.leadingAnchor.constraint(equalTo: self.canvas.leadingAnchor, constant: 8),
            mainView.trailingAnchor.constraint(equalTo: self.canvas.trailingAnchor, constant: -8),
            mainView.bottomAnchor.constraint(equalTo: self.acceptButton.topAnchor, constant: -8)
        ])
    }
}
