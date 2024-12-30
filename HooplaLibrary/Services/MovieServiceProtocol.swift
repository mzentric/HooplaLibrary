import Combine

protocol MovieServiceProtocol {
    func fetchMovies() -> AnyPublisher<[Movie], Error>
} 