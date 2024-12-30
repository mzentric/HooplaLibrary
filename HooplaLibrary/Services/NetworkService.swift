import Foundation
import Combine

struct NetworkService {
    private var commonHeaders: [String: String] {
        [
            "Content-Type": "application/json",
            "Accept": "*/*",
            "apollographql-client-name": "hoopla-www",
            "apollographql-client-version": "4.113.0",
            "origin": "https://www.hoopladigital.com",
            "referer": "https://www.hoopladigital.com/",
        ]
    }
    
    func request<T: Decodable>(url: String, 
                              method: String = "POST",
                              body: [String: Any]) -> AnyPublisher<T, Error> {
        guard let url = URL(string: url) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        commonHeaders.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                if let httpResponse = response as? HTTPURLResponse {
                    print("Response status: \(httpResponse.statusCode)")
                }
                
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Response data: \(jsonString)")
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
} 
