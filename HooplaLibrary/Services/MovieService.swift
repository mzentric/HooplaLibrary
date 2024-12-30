import Foundation
import Combine

class MovieService: MovieServiceProtocol {
    private let baseURL = "https://patron-api-gateway.hoopladigital.com/graphql"
    private let networkService: NetworkService
    
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchMovies() -> AnyPublisher<[Movie], Error> {
        guard let url = URL(string: baseURL) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Required headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("*/*", forHTTPHeaderField: "Accept")
        request.addValue("hoopla-www", forHTTPHeaderField: "apollographql-client-name")
        request.addValue("4.113.0", forHTTPHeaderField: "apollographql-client-version")
        request.addValue("true", forHTTPHeaderField: "binge-pass-external-enabled")
        request.addValue("true", forHTTPHeaderField: "binge-pass-internal-enabled")
        request.addValue("true", forHTTPHeaderField: "external-promos-enabled")
        request.addValue("https://www.hoopladigital.com", forHTTPHeaderField: "origin")
        request.addValue("https://www.hoopladigital.com/", forHTTPHeaderField: "referer")
        request.addValue("true", forHTTPHeaderField: "traditional-manga-enabled")
        request.addValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36", forHTTPHeaderField: "User-Agent")
        
        let body: [String: Any] = [
            "query": MovieQuery.popularMovies,
            "variables": MovieQuery.variables,
            "operationName": "FilterSearch"
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return networkService.dispatch(request)
            .map { (response: GraphQLResponse) in
                response.data.search.hits
            }
            .eraseToAnyPublisher()
    }
    
    func fetchMovieDetail(id: String) -> AnyPublisher<MovieDetail, Error> {
        guard let url = URL(string: baseURL) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Required headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("*/*", forHTTPHeaderField: "Accept")
        request.addValue("hoopla-www", forHTTPHeaderField: "apollographql-client-name")
        request.addValue("4.113.0", forHTTPHeaderField: "apollographql-client-version")
        request.addValue("https://www.hoopladigital.com", forHTTPHeaderField: "origin")
        request.addValue("https://www.hoopladigital.com/", forHTTPHeaderField: "referer")
        
        let body: [String: Any] = [
            "query": MovieQuery.movieDetail,
            "variables": MovieQuery.detailVariables(for: id),
            "operationName": "FETCH_TITLE_DETAIL"
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return networkService.dispatch(request)
            .map { (response: DetailGraphQLResponse) in
                response.data.title
            }
            .eraseToAnyPublisher()
    }
}

// GraphQL response structures
struct GraphQLResponse: Decodable {
    let data: GraphQLData
}

struct GraphQLData: Decodable {
    let search: SearchResponse
}

struct SearchResponse: Decodable {
    let hits: [Movie]
}

//struct MovieKind: Decodable {
//    let name: String
//    let typename: String
//    
//    enum CodingKeys: String, CodingKey {
//        case name
//        case typename = "__typename"
//    }
//} 

// Response structures for detail
struct DetailGraphQLResponse: Decodable {
    let data: DetailData
}

struct DetailData: Decodable {
    let title: MovieDetail
} 
