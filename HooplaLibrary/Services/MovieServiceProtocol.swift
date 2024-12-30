import Combine

protocol MovieServiceProtocol {
    func fetchMovies() -> AnyPublisher<[Movie], Error>
    func fetchMovieDetail(id: String) -> AnyPublisher<MovieDetail, Error>
} 