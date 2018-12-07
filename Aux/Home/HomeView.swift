import UIKit

class HomeView: UIView {
    let partyCodeTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.accessibilityLabel = "PartyCodeTextField"
        textField.backgroundColor = .green
        return textField
    }()
    
    let joinPartyButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityLabel = "JoinPartyButton"
        button.backgroundColor = .brown
        button.setTitle("Enter A Party Code", for: .disabled)
        button.setTitle("Join Party", for: .normal)
        button.isEnabled = false
        return button
    }()
    
    let signupButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityLabel = "SignupButton"
        button.backgroundColor = .brown
        button.setTitle("Signup", for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
        setupActions()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setupActions() {
        self.partyCodeTextField.addTargetClosure(for: UIControl.Event.editingChanged) { (control) in
            guard let textField = control as? UITextField else { return }
            self.joinPartyButton.isEnabled = textField.text != ""
            self.joinPartyButton.isUserInteractionEnabled = textField.text != ""
        }
        
        self.joinPartyButton.addTargetClosure(for: .touchUpInside ) { (control) in
            print("hello")
        }
    }
    
    func setupViews() {
        self.backgroundColor = .yellow
        
        self.addSubview(partyCodeTextField)
        self.addSubview(joinPartyButton)
        self.addSubview(signupButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            partyCodeTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            partyCodeTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            partyCodeTextField.widthAnchor.constraint(equalToConstant: 300),
            partyCodeTextField.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        NSLayoutConstraint.activate([
            joinPartyButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            joinPartyButton.topAnchor.constraint(equalTo: partyCodeTextField.bottomAnchor, constant: 20),
            joinPartyButton.widthAnchor.constraint(equalToConstant: 200),
            joinPartyButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            signupButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            signupButton.topAnchor.constraint(equalTo: joinPartyButton.bottomAnchor, constant: 20),
            signupButton.widthAnchor.constraint(equalToConstant: 200),
            signupButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
