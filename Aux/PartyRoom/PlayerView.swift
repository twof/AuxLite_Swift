import UIKit

protocol PlayerViewDelegate {
    func didPressSkip()
    func didPressSearch()
}

class PlayerView: UIView {
    let skipButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(#imageLiteral(resourceName: "SkipIcon"), for: UIControlState.normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityLabel = "PlayerSkipButton"
        return button
    }()
    
    let playButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(#imageLiteral(resourceName: "PlayIcon"), for: UIControlState.normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityLabel = "PlayerSkipButton"
        return button
    }()
    
    let addTrackButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(#imageLiteral(resourceName: "PlusIcon"), for: UIControlState.normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityLabel = "PlayerSkipButton"
        return button
    }()
    
    let currentTrackLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityLabel = "PlayerViewTrackNameLabel"
        return label
    }()
    
    public var delegate: PlayerViewDelegate?
    
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
        currentTrackLabel.text = "\(track.artistName) - \(track.name)"
    }
    
    private func setupViews() {
        self.addSubview(skipButton)
        self.addSubview(playButton)
        self.addSubview(currentTrackLabel)
        self.addSubview(addTrackButton)
        
        skipButton.addTargetClosure(for: .touchUpInside) { (button) in
            self.delegate?.didPressSkip()
        }
        
        addTrackButton.addTargetClosure(for: .touchUpInside) { (button) in
            self.delegate?.didPressSearch()
        }
    }
    
    private func setupConstraints() {
        // PlayButton constraints
        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            playButton.heightAnchor.constraint(equalToConstant: 70),
            playButton.widthAnchor.constraint(equalToConstant: 70)
        ])
        
        // SkipButton constraints
        NSLayoutConstraint.activate([
            skipButton.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 20),
            skipButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            skipButton.heightAnchor.constraint(equalToConstant: 30),
            skipButton.widthAnchor.constraint(equalToConstant: 30)
        ])
        
        // CurrentTrack constraints
        NSLayoutConstraint.activate([
            currentTrackLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            currentTrackLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])
        
        // AddTrack constraints
        NSLayoutConstraint.activate([
            addTrackButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            addTrackButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            addTrackButton.heightAnchor.constraint(equalToConstant: 30),
            addTrackButton.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
}
