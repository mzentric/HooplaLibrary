# Hoopla Library App

A SwiftUI app that demonstrates modern iOS development practices by integrating with Hoopla's GraphQL API to browse and view movie details.


## Screenshots

| iPad Grid | iPad Detail |
|-----------|-------------|
| <img src="Screenshots/ipad-grid.png" width="600" alt="iPad Grid View"/> | <img src="Screenshots/ipad-detail.png" width="600" alt="iPad Detail View"/> |

| iPhone Grid | iPhone Detail |
|-------------|---------------|
| <img src="Screenshots/iphone-grid.png" width="300" alt="iPhone Grid View"/> | <img src="Screenshots/iphone-detail.png" width="300" alt="iPhone Detail View"/> |

## Features

- Browse popular movies in a responsive grid layout (adapts to iPhone/iPad)
- Infinite scrolling with pagination
- Detailed movie view showing:
  - Movie poster
  - Title and artist
  - Synopsis
  - Genres
  - Directors and cast
- Clean architecture using:
  - MVVM pattern
  - Protocol-based services
  - Generic network layer
  - GraphQL integration
  - Combine for async operations

## Technical Details

- **Minimum iOS Version**: iOS 15.0
- **Architecture**: MVVM
- **Frameworks**:
  - SwiftUI
  - Combine
  - Foundation
- **Network**: Custom network layer with GraphQL support
- **Testing**: Protocol-based services for mockability
