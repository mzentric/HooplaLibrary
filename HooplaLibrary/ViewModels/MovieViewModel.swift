import Foundation
import Combine

class MovieViewModel: ObservableObject {
    @Published private(set) var movies: [Movie] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    private var cancellables = Set<AnyCancellable>()
    private let movieService: MovieServiceProtocol
    
    init(movieService: MovieServiceProtocol = MovieService()) {
        self.movieService = movieService
        fetchMovies()
    }
    
    func fetchMovies() {
        isLoading = true
        error = nil
        
        movieService.fetchMovies()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.error = error
                }
            } receiveValue: { [weak self] movies in
                self?.movies = movies
            }
            .store(in: &cancellables)
    }
} 