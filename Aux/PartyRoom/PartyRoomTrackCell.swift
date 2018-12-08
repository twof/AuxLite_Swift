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
    let trackNameTextView: UITextView = {
        let textview = UITextView(frame: .zero)
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.accessibilityLabel = "TrackNameLabel"

        textview.backgroundColor = .purple

        textview.allowsEditingTextAttributes = false
        textview.isEditable = false
        textview.isSelectable = false
        textview.isScrollEnabled = false
        textview.showsVerticalScrollIndicator = false
        textview.showsHorizontalScrollIndicator = false

        return textview
    }()
    
    let artistNameTextView: UITextView = {
        let textview = UITextView(frame: .zero)
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.accessibilityLabel = "ArtistNameLabel"

        textview.backgroundColor = .blue

        textview.allowsEditingTextAttributes = false
        textview.isEditable = false
        textview.isSelectable = false
        textview.isScrollEnabled = false
        textview.showsVerticalScrollIndicator = false
        textview.showsHorizontalScrollIndicator = false

        return textview
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
        trackNameTextView.text = track.name
        artistNameTextView.text = track.artistName
    }
    
    private func setupViews() {
        contentView.addSubview(trackNameTextView)
        contentView.addSubview(artistNameTextView)
        contentView.backgroundColor = .green
    }
    
    private func setupConstraints() {
        // TrackName constraints
        NSLayoutConstraint.activate([
            trackNameTextView.topAnchor.constraint(equalTo: contentView.topAnchor),
            trackNameTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trackNameTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            trackNameTextView.bottomAnchor.constraint(lessThanOrEqualTo: artistNameTextView.topAnchor)
        ])
        
        // ArtistName constraints
        NSLayoutConstraint.activate([
            artistNameTextView.topAnchor.constraint(equalTo: trackNameTextView.bottomAnchor),
            artistNameTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            artistNameTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            artistNameTextView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
        ])
    }
}
