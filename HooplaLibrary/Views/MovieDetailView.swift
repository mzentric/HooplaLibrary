import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @StateObject private var viewModel = MovieDetailViewModel()
    @State private var showingPlayAlert = false
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        ScrollView {
            if isIPad {
                // iPad Layout
                HStack(alignment: .top, spacing: 24) {
                    // Left side - Thumbnail
                    if let url = URL(string: movie.thumbnailUrl) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            case .failure:
                                Image(systemName: "photo")
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(width: 400)
                    }
                    
                    // Right side - Content
                    VStack(alignment: .leading, spacing: 16) {
                        contentView
                    }
                    .padding(.trailing)
                }
                .padding()
            } else {
                // iPhone Layout (existing vertical layout)
                VStack(alignment: .leading, spacing: 16) {
                    contentView
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchMovieDetail(id: movie.id)
        }
        .alert("Start Watching", isPresented: $showingPlayAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Watch Now") {

            }
        } message: {
            Text("Start watching \(movie.title)?")
        }
    }
    
    private var contentView: some View {
        VStack(alignment: .leading, spacing: 16) {
            if !isIPad {  // iPhone
                if let url = URL(string: movie.thumbnailUrl) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        case .failure:
                            Image(systemName: "photo")
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(maxHeight: 400)
                }
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text(movie.title)
                    .font(.title)
                
                if let detail = viewModel.movieDetail {
                    Group {
                        Text("By \(detail.artist)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        if !detail.synopsis.isEmpty {
                            Text(detail.synopsis)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                        HStack(spacing: 8) {
                            ForEach(detail.genres, id: \.name) { genre in
                                Text(genre.name)
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(16)
                            }
                        }
                        
                        if !detail.directors.isEmpty {
                            Text("Directors")
                                .font(.headline)
                                .padding(.top)
                            Text(detail.directors.map(\.name).joined(separator: ", "))
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        
                        if !detail.actors.isEmpty {
                            Text("Cast")
                                .font(.headline)
                                .padding(.top)
                            Text(detail.actors.map(\.name).joined(separator: ", "))
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Button(action: {
                    showingPlayAlert = true
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "play.fill")
                        Text("Start Watching")
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding(.top)
            }
        }
    }
} 
