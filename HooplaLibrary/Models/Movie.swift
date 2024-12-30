struct Movie: Identifiable, Decodable {
    let id: String
    let artKey: String
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case artKey
        case title
    }
    
    var thumbnailUrl: String {
        "https://marvel-b1-cdn.bc0a.com/f00000000280066/d2snwnmzyr8jue.cloudfront.net/\(artKey)_270.jpeg"
    }
} 
