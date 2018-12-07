import UIKit
import FlowKitManager

class UsernameCell: UICollectionViewCell, Identifiable {
    let usernameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityLabel = "TrackNameLabel"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    public func configure(username: String) {
        self.usernameLabel.text = username
    }
    
    private func setupViews() {
        contentView.addSubview(usernameLabel)
        contentView.backgroundColor = .orange
    }
    
    private func setupConstraints() {
        // username constraints
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            usernameLabel.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor)
        ])
    }
}

