import UIKit
import FlowKitManager

protocol Identifiable {
    static var identifier: String { get }
}

extension Identifiable {
    static var identifier: String {
        return String(describing: Self.self)
    }
}

class PartyRoomTrackCell: UICollectionViewCell, Identifiable {
    let trackNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityLabel = "TrackNameLabel"
        return label
    }()
    
    let artistNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityLabel = "ArtistNameLabel"
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
        trackNameLabel.text = track.name
        artistNameLabel.text = track.artistName
    }
    
    private func setupViews() {
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.backgroundColor = .green
    }
    
    private func setupConstraints() {
        // TrackName constraints
        NSLayoutConstraint.activate([
            trackNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            trackNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trackNameLabel.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor)
        ])
        
        // ArtistName constraints
        NSLayoutConstraint.activate([
            artistNameLabel.topAnchor.constraint(equalTo: trackNameLabel.bottomAnchor),
            artistNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            artistNameLabel.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor)
        ])
    }
}
