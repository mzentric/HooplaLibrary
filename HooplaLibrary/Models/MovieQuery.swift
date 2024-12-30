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
    
    static let variables: [String: Any] = [
        "criteria": [
            "kindId": 7,
            "popular": true,
            "availability": "ALL_TITLES",
            "pagination": [
                "page": 1,
                "pageSize": 48
            ]
        ]
    ]
} 
