import UIKit

class PlayerView: UIView {
    let skipButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(#imageLiteral(resourceName: "SkipIcon"), for: UIControlState.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityLabel = "PlayerSkipButton"
        return button
    }()
    
    let playButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(#imageLiteral(resourceName: "PlayIcon"), for: UIControlState.normal)
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
    }
    
    private func setupConstraints() {
        // PlayButton constraints
        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            playButton.heightAnchor.constraint(equalToConstant: 40),
            playButton.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        // SkipButton constraints
        NSLayoutConstraint.activate([
            skipButton.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 20),
            skipButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            skipButton.heightAnchor.constraint(equalToConstant: 40),
            skipButton.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        // CurrentTrack constraints
        NSLayoutConstraint.activate([
            currentTrackLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            currentTrackLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])
    }}
