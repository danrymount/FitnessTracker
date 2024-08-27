

import Foundation
import UIKit

class SetsExerciseInfoPreviewView: UIView {
    var repsStackView: UIStackView = {
        // TODO use scroll view
        var hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.distribution = .equalCentering
        hStack.spacing = 8
        
        return hStack
    }()
    
    let timeoutLb: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    init() {
        super.init(frame: CGRect())
        
        let vStack = {
            let view = UIStackView()
            view.axis = .vertical
            view.translatesAutoresizingMaskIntoConstraints = false
            
            view.layer.cornerRadius = 10
            view.layer.borderColor = UIColor(.black).cgColor
            view.layer.borderWidth = 1
            
            return view
        }()
        
        addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: self.topAnchor),
            vStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            vStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
        let setsTitleLb = {
            let view = UILabel()
            view.text = "Sets"
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let timeoutTitleLb = {
            let view = UILabel()
            view.text = "Timeout"
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        vStack.addSubview(setsTitleLb)
        vStack.addSubview(repsStackView)
        vStack.addSubview(timeoutTitleLb)
        vStack.addSubview(timeoutLb)
        
        NSLayoutConstraint.activate([
            setsTitleLb.topAnchor.constraint(equalTo: vStack.topAnchor, constant: 8),
            setsTitleLb.centerXAnchor.constraint(equalTo: vStack.centerXAnchor),
            setsTitleLb.leadingAnchor.constraint(greaterThanOrEqualTo: vStack.leadingAnchor),
            setsTitleLb.trailingAnchor.constraint(lessThanOrEqualTo: vStack.trailingAnchor),
            repsStackView.topAnchor.constraint(equalTo: setsTitleLb.bottomAnchor, constant: 8),
            repsStackView.leadingAnchor.constraint(equalTo: vStack.leadingAnchor, constant: 24),
            repsStackView.trailingAnchor.constraint(equalTo: vStack.trailingAnchor, constant: -24),

            
            timeoutTitleLb.topAnchor.constraint(equalTo: repsStackView.bottomAnchor, constant: 16),
            timeoutTitleLb.centerXAnchor.constraint(equalTo: vStack.centerXAnchor),
            timeoutTitleLb.leadingAnchor.constraint(greaterThanOrEqualTo: vStack.leadingAnchor),
            timeoutTitleLb.trailingAnchor.constraint(lessThanOrEqualTo: vStack.trailingAnchor),
            
            timeoutLb.topAnchor.constraint(equalTo: timeoutTitleLb.bottomAnchor, constant: 8),
            timeoutLb.centerXAnchor.constraint(equalTo: vStack.centerXAnchor),
            timeoutLb.leadingAnchor.constraint(greaterThanOrEqualTo: vStack.leadingAnchor),
            timeoutLb.trailingAnchor.constraint(lessThanOrEqualTo: vStack.trailingAnchor),
            
            timeoutLb.bottomAnchor.constraint(equalTo: vStack.bottomAnchor, constant: -8),
        ])
    }
    
    func update(reps: [UInt], timeout: TimeInterval) {
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.0, options: UIView.AnimationOptions.curveLinear, animations: { [self] in
            self.alpha = 0
        })
        
        for sub in self.repsStackView.subviews {
            self.repsStackView.removeArrangedSubview(sub)
            sub.removeFromSuperview()
        }

        for rep in reps {
            let lb = PaddingLabel(insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
            lb.translatesAutoresizingMaskIntoConstraints = false
            lb.text = String(rep)

            lb.layer.cornerRadius = 10
            lb.backgroundColor = .systemBlue
            lb.textColor = .white
            lb.textAlignment = .center
            lb.layer.masksToBounds = true
            lb.sizeToFit()
            self.repsStackView.addArrangedSubview(lb)
        }
        
        timeoutLb.text = timeout.stringFromTimeInterval()
        
        self.layoutSubviews()
        
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.0, options: UIView.AnimationOptions.curveLinear, animations: { [self] in
            self.alpha = 1
        })
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
