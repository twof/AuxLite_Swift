import UIKit

protocol TrackSearchViewDelegate {
    func didSelect(track: Track)
    func didSelectExit()
}

class TrackSearchView: UIView {
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
    let trackSearchHeader: TrackSearchHeaderView =  {
        let player = TrackSearchHeaderView(frame: .zero)
        player.translatesAutoresizingMaskIntoConstraints = false
        player.accessibilityLabel = "TrackSearchHeader"
        player.backgroundColor = .red
        return player
    }()
    
    var delegate: TrackSearchViewDelegate?
    
    var searchText = ""
    
    var tracks: [Track] = [
        Track(id: 0, name: "Hello World", artistName: "Foo and the Bars", length: 10),
        Track(id: 1, name: "Crave You", artistName: "Flight Facilities", length: 10),
        Track(id: 2, name: "Gasoline", artistName: "Alpine", length: 10),
        Track(id: 3, name: "Hello World", artistName: "Foo and the Bars", length: 10),
        Track(id: 4, name: "Crave You", artistName: "Flight Facilities", length: 10),
        Track(id: 5, name: "Gasoline", artistName: "Alpine", length: 10),
        Track(id: 6, name: "Hello World", artistName: "Foo and the Bars", length: 10),
        Track(id: 7, name: "Crave You", artistName: "Flight Facilities", length: 10),
        Track(id: 8, name: "Gasoline", artistName: "Alpine", length: 10),
        Track(id: 9, name: "Hello World", artistName: "Foo and the Bars", length: 10),
        Track(id: 10, name: "Crave You", artistName: "Flight Facilities", length: 10),
        Track(id: 11, name: "Gasoline", artistName: "Alpine", length: 10),
        Track(id: 12, name: "Hello World", artistName: "Foo and the Bars", length: 10),
        Track(id: 13, name: "Crave You", artistName: "Flight Facilities", length: 10),
        Track(id: 14, name: "Gasoline", artistName: "Alpine", length: 10),
    ]
    
    var filteredTracks: [Track] {
        return tracks.filter { track in
            let foundInName = track.name.lowercased().contains(other: searchText.lowercased())
            let foundInArtist = track.artistName.lowercased().contains(other: searchText.lowercased())
            
            return foundInName || foundInArtist
        }
    }
    
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
        self.addSubview(trackSearchHeader)
        self.backgroundColor = .red
        
        trackListCollection.delegate = self
        trackListCollection.dataSource = self
        
        trackSearchHeader.delegate = self
        
        trackSearchHeader.configure(with: tracks[0])
    }
    
    private func setupConstraints() {
        
        // TracklistCollection constraints
        NSLayoutConstraint.activate([
            trackListCollection.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            trackListCollection.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            trackListCollection.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            trackListCollection.topAnchor.constraint(equalTo: self.topAnchor, constant: 200),
        ])
        
        // PlayerView constraints
        NSLayoutConstraint.activate([
            trackSearchHeader.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            trackSearchHeader.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            trackSearchHeader.bottomAnchor.constraint(equalTo: trackListCollection.topAnchor),
            trackSearchHeader.topAnchor.constraint(equalTo: self.topAnchor),
        ])
    }
    
    private func registerCells() {
        trackListCollection.register(PartyRoomTrackCell.self, forCellWithReuseIdentifier: PartyRoomTrackCell.identifier)
    }
}

extension TrackSearchView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didSelect(track: filteredTracks[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = CGFloat(75)
        return CGSize(width: collectionView.bounds.size.width - 30, height: height)
    }
}

extension TrackSearchView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredTracks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PartyRoomTrackCell.identifier, for: indexPath)
        
        guard let trackCell = cell as? PartyRoomTrackCell else {return UICollectionViewCell()}
        
        trackCell.configure(with: filteredTracks[indexPath.row])
        
        return trackCell
    }
}

extension TrackSearchView: TrackSearchHeaderViewDelegate {
    func searchTextDidChage(text: String) {
        self.searchText = text
        trackListCollection.reloadData()
    }
    
    func didSelectExit() {
        self.delegate?.didSelectExit()
    }
}

extension String {
    func contains(other string: String) -> Bool {
        return self.range(of: string) != nil
    }
}

