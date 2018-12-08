import UIKit
import FlowKitManager

class PartyRoomView: UIView {
    let trackListCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .yellow
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.accessibilityLabel = "trackListCollection"
        return collection
    }()
    let playerView: PlayerView =  {
        let player = PlayerView(frame: .zero)
        player.translatesAutoresizingMaskIntoConstraints = false
        player.accessibilityLabel = "PlayerView"
        player.backgroundColor = .red
        return player
    }()
    
    let trackSearchView: TrackSearchView = {
        let searchView = TrackSearchView(frame: .zero)
        searchView.translatesAutoresizingMaskIntoConstraints = false
        searchView.accessibilityLabel = "TrackSearchView"
        searchView.isHidden = true
        return searchView
    }()
    
    let trackAdapter: CollectionAdapter<Track, PartyRoomTrackCell> = {
        let trackAdapter = CollectionAdapter<Track, PartyRoomTrackCell>()
        
        trackAdapter.on.dequeue = { context in
            context.cell?.configure(with: context.model)
        }
        
        trackAdapter.on.itemSize = { context in
            guard let collection = context.collection else { fatalError() }
            let height = CGFloat(75)
            
            return CGSize(width: collection.bounds.size.width - 30, height: height)
        }
        
        return trackAdapter
    }()
    
    let usernameAdapter: CollectionAdapter<String, UsernameCell> = {
        let usernameAdapter = CollectionAdapter<String, UsernameCell>()
        
        usernameAdapter.on.dequeue = { context in
            context.cell?.configure(username: context.model)
        }
        
        usernameAdapter.on.itemSize = { context in
            guard let collection = context.collection else { fatalError() }
            let height = CGFloat(75)
            
            return CGSize(width: collection.bounds.size.width - 30, height: height)
        }
        
        return usernameAdapter
    }()
    
    var trackListCollectionDirector: FlowCollectionDirector
    
    var tracks: [Track] = [
        Track(id: 20, name: "This is a very long name that should span multiple lines and expand the cell so that we can see a lomg boi", artistName: "This is a very long artist name that should span multiple lines and expand the cell so that we can see a lomg boiThis is a very long artist name that should span multiple lines and expand the cell so that we can see a lomg boi", length: 10),
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
    
    var usernames: [String] = [
        "twof",
        "another username"
    ]
    
    override init(frame: CGRect) {
        self.trackListCollectionDirector = FlowCollectionDirector(self.trackListCollection)
        
        super.init(frame: frame)
        
        self.trackListCollectionDirector.minimumLineSpacing = 10
        
        self.trackListCollectionDirector.register(adapter: self.trackAdapter)
        self.trackListCollectionDirector.register(adapter: self.usernameAdapter)
        
        self.trackListCollectionDirector.add(self.createUsersSection())
        self.trackListCollectionDirector.add(self.createTracksSection())
        self.trackListCollectionDirector.reloadData()
        
        registerCells()
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func createTracksSection() -> CollectionSection {
        let tracksSection = CollectionSection(self.tracks)
        
        return tracksSection
    }
    
    func createUsersSection() -> CollectionSection {
        let userSection = CollectionSection(self.usernames)
        
        return userSection
    }
    
    private func setupViews() {
        self.addSubview(trackListCollection)
        self.addSubview(playerView)
        self.addSubview(trackSearchView)
        
        self.backgroundColor = .red
        
        playerView.delegate = self
        trackSearchView.delegate = self
        
        playerView.configure(with: tracks[0])
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
            playerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            playerView.bottomAnchor.constraint(equalTo: trackListCollection.topAnchor),
            playerView.topAnchor.constraint(equalTo: self.topAnchor),
        ])
        
        // TrackSearch constraints
        NSLayoutConstraint.activate([
            trackSearchView.topAnchor.constraint(equalTo: self.topAnchor),
            trackSearchView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            trackSearchView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            trackSearchView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
    }
    
    private func registerCells() {
        trackListCollection.register(cell: PartyRoomTrackCell.self)
        trackListCollection.register(cell: UsernameCell.self)
    }
}

extension PartyRoomView: PlayerViewDelegate {
    func didPressSkip() {
        tracks.remove(at: 0)
        playerView.configure(with: tracks[0])
        trackListCollectionDirector.reloadData(after: {
            self.trackListCollectionDirector.section(at: 1)?.set(models: self.tracks)
        })
    }
    
    func didPressSearch() {
        trackSearchView.isHidden = false
    }
}

extension PartyRoomView: TrackSearchViewDelegate {
    func didSelect(track: Track) {
        trackSearchView.isHidden = true
        tracks.append(track)
        trackListCollectionDirector.reloadData(after: {
            self.trackListCollectionDirector.firstSection()?.set(models: self.tracks)
        })
    }
    
    func didSelectExit() {
        trackSearchView.resignFirstResponder()
        trackSearchView.isHidden = true
    }
}

extension String: ModelProtocol {
    public var modelID: Int {
        return self.hashValue
    }
}

extension UICollectionView {
    func register(cell: (UICollectionViewCell & Identifiable).Type) {
        self.register(cell.self, forCellWithReuseIdentifier: cell.identifier)
    }
}
