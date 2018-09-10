import UIKit

protocol TrackSearchHeaderViewDelegate {
    func searchTextDidChage(text: String)
    func didSelectExit()
}

class TrackSearchHeaderView: UIView {
    let searchTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .yellow
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
