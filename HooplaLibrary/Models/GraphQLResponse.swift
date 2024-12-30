struct GraphQLResponse<T: Decodable>: Decodable {
    let data: T
} 