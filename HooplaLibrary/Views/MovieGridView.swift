import SwiftUI

struct MovieGridView: View {
    @StateObject private var viewModel = MovieViewModel()
    
    private var gridColumns: [GridItem] {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return Array(repeating: GridItem(.flexible(), spacing: 20), count: 4)
        }
        return Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)
    }
    
    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else if let error = viewModel.error {
                VStack {
                    Text("Error loading movies")
                        .foregroundColor(.red)
                    Text(error.localizedDescription)
                        .font(.caption)
                        .foregroundColor(.gray)
                    Button("Retry") {
                        viewModel.fetchMovies()
                    }
                    .padding()
                }
            } else {
                LazyVGrid(columns: gridColumns, spacing: 24) {
                    ForEach(viewModel.movies) { movie in
                        MovieGridItem(movie: movie)
                    }
                }
                .padding()
            }
        }
        .refreshable {
            viewModel.fetchMovies()
        }
    }
}

struct MovieGridItem: View {
    let movie: Movie
    private let itemHeight: CGFloat = 380
    private let imageWidth: CGFloat = 200
    private let imageHeight: CGFloat = 300
    private let titleHeight: CGFloat = 60
    
    var body: some View {
        NavigationLink(destination: MovieDetailView(movie: movie)) {
            VStack(spacing: 0) {
                if let url = URL(string: movie.thumbnailUrl) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: imageWidth, height: imageHeight)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: imageWidth, height: imageHeight)
                                .clipped()
                        case .failure(_):
                            Image(systemName: "photo")
                                .frame(width: imageWidth, height: imageHeight)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                
                Spacer(minLength: 0)
                
                HStack(alignment: .top) {
                    Text(movie.title)
                        .font(.title3)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 0)
                        .lineLimit(2)
                        .foregroundColor(.primary)
                }
                .frame(width: imageWidth, height: titleHeight)
                .background(Color(.systemBackground))
            }
            .frame(width: imageWidth, height: itemHeight)
            .background(Color(.systemBackground))
            .cornerRadius(8)
            .shadow(radius: 2)
        }
    }
}

struct MovieGridView_Previews: PreviewProvider {
    static var previews: some View {
        MovieGridView()
    }
} 
