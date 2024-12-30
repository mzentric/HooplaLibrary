struct MovieQuery {
    static let popularMovies = """
    query FilterSearch($criteria: SearchCriteria!, $sort: Sort) {
      search(criteria: $criteria, sort: $sort) {
        hits {
          id
          artKey
          title
          kind {
            name
            __typename
          }
          __typename
        }
        __typename
      }
    }
    """
    
    static let movieDetail = """
    query FETCH_TITLE_DETAIL($id: ID!, $includeDeleted: Boolean) {
      title(criteria: {id: $id, includeDeleted: $includeDeleted}) {
        id
        artKey
        title
        synopsis
        primaryArtist {
          name
        }
        genres {
          name
        }
        actors {
          name
        }
        directors {
          name
        }
        __typename
      }
    }
    """
    
    static func detailVariables(for titleId: String) -> [String: Any] {
        return [
            "id": titleId,
            "includeDeleted": false
        ]
    }
} 
