import FlowKitManager

struct Track: Codable {
    var id: Int?
    let name: String
    let artistName: String
    let length: Int
    
    init(id: Int, name: String, artistName: String, length: Int) {
        self.id = id
        self.name = name
        self.artistName = artistName
        self.length = length
    }
}

extension Track: ModelProtocol {
    var modelID: Int {
        return id ?? 0
    }
}
