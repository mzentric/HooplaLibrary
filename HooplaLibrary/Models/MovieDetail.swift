struct MovieDetail: Identifiable, Decodable {
    let id: String
    let artKey: String
    let title: String
    let synopsis: String
    let artist: String
    let genres: [Genre]
    let actors: [Artist]
    let directors: [Artist]
    
    struct Genre: Decodable {
        let name: String
    }
    
    struct Artist: Decodable {
        let name: String
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case artKey
        case title
        case synopsis
        case primaryArtist
        case genres
        case actors
        case directors
    }
    
    struct ArtistResponse: Decodable {
        let name: String
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        artKey = try container.decode(String.self, forKey: .artKey)
        title = try container.decode(String.self, forKey: .title)
        synopsis = try container.decode(String.self, forKey: .synopsis)
        genres = try container.decode([Genre].self, forKey: .genres)
        actors = try container.decode([Artist].self, forKey: .actors)
        directors = try container.decode([Artist].self, forKey: .directors)
        
        let artistResponse = try container.decode(ArtistResponse.self, forKey: .primaryArtist)
        artist = artistResponse.name
    }
    
    var thumbnailUrl: String {
        "https://marvel-b1-cdn.bc0a.com/f00000000280066/d2snwnmzyr8jue.cloudfront.net/\(artKey)_270.jpeg"
    }
} 