

import Foundation
import UIKit



class SetsInfoView : UIView
{
    private var setsLabel : [UILabel]
    init(sets:[UInt]) {
        
        setsLabel = []
        
        
        super.init(frame: CGRect())
        
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.distribution = .fillProportionally
        hStack.alignment = .center
        hStack.spacing = 16
        
        
        hStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hStack)
        for i in sets
        {
            let lb = PaddingLabel(insets: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12))
            
            lb.text = String(i)
            lb.layer.cornerRadius = 4
            lb.layer.masksToBounds = true
            
            lb.backgroundColor = .gray
            lb.textColor = .white
            
            
            setsLabel.append(lb)
            //            lb.sizeToFit()
            hStack.addArrangedSubview(lb)
        }
        
        NSLayoutConstraint.activate([
            hStack.centerXAnchor.constraint(equalTo: centerXAnchor),
//            hStack.leadingAnchor.constraint(equalTo: leadingAnchor),
//            hStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            hStack.topAnchor.constraint(equalTo: topAnchor),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
//        hStack.sizeToFit()
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    public func markCompleted(amount :Int)
    {
        var count = 0
        for v in (subviews[0] as! UIStackView).subviews
        {
            if count >= amount
            {
                break;
            }
            count += 1
            (v as! UILabel).backgroundColor = .systemGreen
        }
    }
}


class PaddingLabel: UILabel {
    
    var topInset: CGFloat
    var bottomInset: CGFloat
    var leftInset: CGFloat
    var rightInset: CGFloat
    
    
    required init(insets: UIEdgeInsets) {
        self.topInset = insets.top
        self.bottomInset = insets.bottom
        self.leftInset = insets.left
        self.rightInset = insets.right
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
    
}
