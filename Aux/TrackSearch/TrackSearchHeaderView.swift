import UIKit

protocol TrackSearchHeaderViewDelegate {
    func searchTextDidChage(text: String)
}

class TrackSearchHeaderView: UIView {
    let searchTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.accessibilityLabel = "SearchTextField"
        return textField
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
        
        searchTextField.addTargetClosure(for: .editingChanged) { (field) in
            self.delegate?.searchTextDidChage(text: self.searchTextField.text ?? "")
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
