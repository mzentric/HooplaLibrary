import Foundation
import Combine

class MovieViewModel: ObservableObject {
    @Published private(set) var movies: [Movie] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    private var currentPage = 1
    private var hasMorePages = true
    private var cancellables = Set<AnyCancellable>()
    private let movieService: MovieServiceProtocol
    
    init(movieService: MovieServiceProtocol = MovieService()) {
        self.movieService = movieService
        fetchMovies()
    }
    
    func fetchMovies() {
        guard !isLoading && hasMorePages else { return }
        isLoading = true
        
        movieService.fetchMovies(page: currentPage)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error
                }
            } receiveValue: { [weak self] newMovies in
                guard let self = self else { return }
                if newMovies.isEmpty {
                    self.hasMorePages = false
                } else {
                    self.movies.append(contentsOf: newMovies)
                    self.currentPage += 1
                }
            }
            .store(in: &cancellables)
    }
    
    func loadMoreIfNeeded(currentItem movie: Movie) {
        let thresholdIndex = movies.index(movies.endIndex, offsetBy: -5)
        if movies.firstIndex(where: { $0.id == movie.id }) ?? 0 >= thresholdIndex {
            fetchMovies()
        }
    }
} 