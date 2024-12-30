import Foundation
import Combine

class MovieDetailViewModel: ObservableObject {
    @Published private(set) var movieDetail: MovieDetail?
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    private var cancellables = Set<AnyCancellable>()
    private let movieService: MovieServiceProtocol
    
    init(movieService: MovieServiceProtocol = MovieService()) {
        self.movieService = movieService
    }
    
    func fetchMovieDetail(id: String) {
        isLoading = true
        error = nil
        
        movieService.fetchMovieDetail(id: id)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching detail: \(error)")
                    self?.error = error
                }
            } receiveValue: { [weak self] detail in
                self?.movieDetail = detail
            }
            .store(in: &cancellables)
    }
} 
