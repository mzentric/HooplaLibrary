import Combine

//so we can mock the services.
protocol MovieServiceProtocol {
    func fetchMovies(page: Int) -> AnyPublisher<[Movie], Error>
    func fetchMovieDetail(id: String) -> AnyPublisher<MovieDetail, Error>
} 
