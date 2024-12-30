import Foundation
import Combine

class MovieService: MovieServiceProtocol {
    private let baseURL = "https://patron-api-gateway.hoopladigital.com/graphql"
    
    func fetchMovies(page: Int) -> AnyPublisher<[Movie], Error> {
        let variables: [String: Any] = [
            "criteria": [
                "kindId": 7,
                "popular": true,
                "availability": "ALL_TITLES",
                "pagination": [
                    "page": page,
                    "pageSize": 48
                ]
            ]
        ]
        
        let body: [String: Any] = [
            "query": MovieQuery.popularMovies,
            "variables": variables,
            "operationName": "FilterSearch"
        ]
        
        return NetworkService().request(url: baseURL, body: body)
            .map { (response: GraphQLResponse<SearchData>) in
                response.data.search.hits
            }
            .eraseToAnyPublisher()
    }
    
    func fetchMovieDetail(id: String) -> AnyPublisher<MovieDetail, Error> {
        let body: [String: Any] = [
            "query": MovieQuery.movieDetail,
            "variables": MovieQuery.detailVariables(for: id),
            "operationName": "FETCH_TITLE_DETAIL"
        ]
        
        return NetworkService().request(url: baseURL, body: body)
            .map { (response: GraphQLResponse<DetailData>) in
                response.data.title
            }
            .eraseToAnyPublisher()
    }
}

// Response structures
struct SearchData: Decodable {
    let search: SearchResponse
}

struct SearchResponse: Decodable {
    let hits: [Movie]
}

struct DetailData: Decodable {
    let title: MovieDetail
} 
