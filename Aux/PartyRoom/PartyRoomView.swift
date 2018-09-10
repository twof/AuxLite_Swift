import UIKit

class PartyRoomView: UIView {
    let trackListCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 50)
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .yellow
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.accessibilityLabel = "trackListCollection"
        return collection
    }()
    
    var tracks: [Track] = [
        Track(name: "Hello World", artistName: "Foo and the Bars", length: 10),
        Track(name: "Crave You", artistName: "Flight Facilities", length: 10),
        Track(name: "Gasoline", artistName: "Alpine", length: 10)
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        registerCells()
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        registerCells()
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        self.addSubview(trackListCollection)
        self.backgroundColor = .red
        
        trackListCollection.delegate = self
        trackListCollection.dataSource = self
    }
    
    private func setupConstraints() {
        
        // TracklistCollection constraints
        NSLayoutConstraint.activate([
            trackListCollection.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            trackListCollection.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            trackListCollection.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            trackListCollection.topAnchor.constraint(equalTo: self.topAnchor, constant: 100),
        ])
    }
    
    private func registerCells() {
        trackListCollection.register(PartyRoomTrackCell.self, forCellWithReuseIdentifier: PartyRoomTrackCell.identifier)
    }
}

extension PartyRoomView: UICollectionViewDelegate {
    
}

extension PartyRoomView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PartyRoomTrackCell.identifier, for: indexPath)
        
        guard let trackCell = cell as? PartyRoomTrackCell else {return UICollectionViewCell()}
        
        trackCell.configure(with: tracks[indexPath.row])
        
        return trackCell
    }
}
