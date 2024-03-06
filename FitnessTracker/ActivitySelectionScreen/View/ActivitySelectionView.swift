
import UIKit


class ActivitySelectionCard: UIView
{
    init(frame: CGRect, activityType: ActivityType){
        super.init(frame: frame)
        
        let hStack = UIStackView()

        hStack.axis = .horizontal
        hStack.distribution = .fill
        let label = UILabel()
        label.text = activityType.toString()
        
        hStack.layer.borderColor = UIColor.black.cgColor
        hStack.layer.borderWidth = 1
        hStack.layer.cornerRadius = 10
        
        let icon = UIImageView(image:UIImage(systemName: activityType.toIconName()))
        let spacer = UIView()
        
        
        hStack.addArrangedSubview(label)
        hStack.addArrangedSubview(spacer)
        hStack.addArrangedSubview(icon)
        
        NSLayoutConstraint.activate([spacer.leadingAnchor.constraint(equalTo: label.trailingAnchor),
                                     spacer.trailingAnchor.constraint(equalTo: icon.leadingAnchor)])

        hStack.isLayoutMarginsRelativeArrangement = true
        hStack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        self.addSubview(hStack)
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        hStack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        hStack.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
        hStack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        

    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


extension UIView {
    static func spacer(size: CGFloat = .greatestFiniteMagnitude, for layout: NSLayoutConstraint.Axis = .horizontal) -> UIView {
        let spacer = UIView()
        
        if layout == .horizontal {
            let constraint = spacer.widthAnchor.constraint(equalToConstant: size)
            constraint.priority = .defaultLow
            constraint.isActive = true
        } else {
            let constraint = spacer.heightAnchor.constraint(equalToConstant: size)
            constraint.priority = .defaultLow
            constraint.isActive = true
        }
        return spacer
    }
}


extension UIView {
    func addTapGesture(tapNumber: Int, target: Any, action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        tap.numberOfTapsRequired = tapNumber
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
}


extension UIStackView {
    func customize(backgroundColor: UIColor = .clear, radiusSize: CGFloat = 0) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = backgroundColor
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
        
        subView.layer.cornerRadius = radiusSize
        subView.layer.masksToBounds = true
        subView.clipsToBounds = true
    }
}
