struct Track: Codable {
    var id: Int?
    let name: String
    let artistName: String
    let length: Int
    
    init(name: String, artistName: String, length: Int) {
        self.name = name
        self.artistName = artistName
        self.length = length
    }
}
