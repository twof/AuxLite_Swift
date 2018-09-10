import UIKit

protocol TrackSearchHeaderViewDelegate {
    func searchTextDidChage(text: String)
    func didSelectExit()
}

class TrackSearchHeaderView: UIView {
    let searchTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.accessibilityLabel = "SearchTextField"
        return textField
    }()
    
    let exitButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(#imageLiteral(resourceName: "PlusIcon"), for: UIControlState.normal)
        button.transform = button.transform.rotated(by: .pi/4)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityLabel = "PlayerSkipButton"
        return button
    }()
    
    public var delegate: TrackSearchHeaderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupViews()
        setupConstraints()
    }
    
    public func configure(with track: Track) {
        
    }
    
    private func setupViews() {
        self.addSubview(searchTextField)
        self.addSubview(exitButton)
        
        searchTextField.addTargetClosure(for: .editingChanged) { (field) in
            self.delegate?.searchTextDidChage(text: self.searchTextField.text ?? "")
        }
        
        exitButton.addTargetClosure(for: .touchUpInside) { (button) in
            self.delegate?.didSelectExit()
        }
    }
    
    private func setupConstraints() {
        // PlayButton constraints
        NSLayoutConstraint.activate([
            searchTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            searchTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            searchTextField.heightAnchor.constraint(equalToConstant: 50),
            searchTextField.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        // ExitButton constraints
        NSLayoutConstraint.activate([
            exitButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            exitButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            exitButton.heightAnchor.constraint(equalToConstant: 30),
            exitButton.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
}

extension UIControl {
    
    typealias UIControlTargetClosure = (UIControl) -> ()
    
    private struct AssociatedKeys {
        static var targetClosure = "targetClosure"
    }
    
    class ClosureWrapper: NSObject {
        let closure: UIControlTargetClosure
        init(_ closure: @escaping UIControlTargetClosure) {
            self.closure = closure
        }
    }
    
    private var targetClosure: UIControlTargetClosure? {
        get {
            guard let closureWrapper = objc_getAssociatedObject(self, &AssociatedKeys.targetClosure) as? ClosureWrapper else { return nil }
            return closureWrapper.closure
        }
        set(newValue) {
            guard let newValue = newValue else { return }
            objc_setAssociatedObject(self, &AssociatedKeys.targetClosure, ClosureWrapper(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func addTargetClosure(for event: UIControlEvents, closure: @escaping UIControlTargetClosure) {
        targetClosure = closure
        addTarget(self, action: #selector(UIControl.closureAction), for: event)
    }
    
    @objc func closureAction() {
        guard let targetClosure = targetClosure else { return }
        targetClosure(self)
    }
}
