import Foundation
import Combine

class MovieService: MovieServiceProtocol {
    private let baseURL = "https://patron-api-gateway.hoopladigital.com/graphql"
    
    func fetchMovies() -> AnyPublisher<[Movie], Error> {
        guard let url = URL(string: baseURL) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Required headers from the browser request
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
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { data, response in
                if let httpResponse = response as? HTTPURLResponse {
                    print("Response Status Code: \(httpResponse.statusCode)")
                    print("Response Headers: \(httpResponse.allHeaderFields)")
                }
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response Data: \(responseString)")
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    print("Bad status code: \(httpResponse.statusCode)")
                    throw URLError(.badServerResponse)
                }
                
                return data
            }
            .decode(type: GraphQLResponse.self, decoder: JSONDecoder())
            .map { $0.data.search.hits }
            .print()
            .receive(on: DispatchQueue.main)
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

struct MovieKind: Decodable {
    let name: String
    let typename: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case typename = "__typename"
    }
} 
