
import Foundation
import UIKit


public class ExerciseParamView: UIView {
    private var valueLabel: UILabel
    private var decCb : ()->Void
    private var incCb : ()->Void
    
    private var incButton : UIButton;
    public var decButton : UIButton;
    required public init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func updateValue(s:String)
    {
        valueLabel.text = s
    }
    
    func setName(string:String)
    {
        
    }
    
    @objc
    func decOnTapGesture(_ sender: UITapGestureRecognizer? = nil)
    {
        decCb()
    }
    
    @objc
    func incOnTapGesture(_ sender: UITapGestureRecognizer? = nil)
    {
        incCb()
    }
    
    func addButtonTapGesture(funcCb: @escaping ()->Void, dec:Bool)
    {
        if dec
        {
            decCb = funcCb
        }
        else
        {
            incCb = funcCb
        }
    }
    
    init(settingName:String) {
        decCb = {}
        incCb = {}
        incButton = UIButton()
        decButton = UIButton()
        
        valueLabel = UILabel()
        super.init(frame: CGRect())
        isUserInteractionEnabled = true
        let settingLabel = UILabel()
        let labelVal = UILabel()
        valueLabel = labelVal
        let hStack = UIStackView()
        let vStack = UIStackView()
        
        settingLabel.text = settingName
        settingLabel.textColor = .black
        
        
        decButton.setImage(UIImage(systemName: "minus"), for: .normal)
        decButton.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        decButton.layer.borderWidth = 1
        decButton.layer.cornerRadius = 10
        decButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        decButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        decButton.translatesAutoresizingMaskIntoConstraints = true
        incButton.setImage(UIImage(systemName: "plus"), for: .normal)
        incButton.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        incButton.layer.borderWidth = 1
        incButton.layer.cornerRadius = 10
        incButton.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        incButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        incButton.translatesAutoresizingMaskIntoConstraints = true
        
        labelVal.text = "Val"
        labelVal.layer.borderWidth = 1
        labelVal.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        labelVal.translatesAutoresizingMaskIntoConstraints = true
        
        labelVal.textAlignment = .center
        
        
        
        hStack.axis = .horizontal
        hStack.distribution = .fillEqually
        hStack.alignment = .center
        hStack.spacing = 0
        
        hStack.addArrangedSubview(decButton)
        hStack.addArrangedSubview(labelVal)
        hStack.addArrangedSubview(incButton)
        NSLayoutConstraint.activate([labelVal.topAnchor.constraint(equalTo: hStack.topAnchor),
                                     labelVal.bottomAnchor.constraint(equalTo: hStack.bottomAnchor)])
        hStack.translatesAutoresizingMaskIntoConstraints = false
        
        vStack.axis = .vertical
        vStack.distribution = .equalSpacing
        vStack.alignment = .center
        vStack.spacing = 0
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.addArrangedSubview(settingLabel)
        vStack.addArrangedSubview(hStack)
        
        
        
        addSubview(vStack)
        hStack.layoutIfNeeded()
        vStack.layoutIfNeeded()
        
        NSLayoutConstraint.activate([
            hStack.leadingAnchor.constraint(equalTo: vStack.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: vStack.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            vStack.topAnchor.constraint(equalTo: topAnchor),
            vStack.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ])
        
        
        
        incButton.isUserInteractionEnabled = true
        incButton.addTapGesture(tapNumber: 1, target: self, action: #selector(incOnTapGesture(_:)))
        decButton.isUserInteractionEnabled = true
        decButton.addTapGesture(tapNumber: 1, target: self, action: #selector(decOnTapGesture(_:)))
    }
    
    
}

