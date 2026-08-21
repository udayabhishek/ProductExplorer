import Foundation

protocol ProductAPIServiceProtocol {
    func fetchProducts() async throws -> [ProductDTO]
}

final class ProductAPIService: ProductAPIServiceProtocol {
    private let apiClient: APIClient
    private let productsURL = URL(string: "https://fakestoreapi.com/products")!

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func fetchProducts() async throws -> [ProductDTO] {
        try await apiClient.fetch([ProductDTO].self, from: productsURL)
    }
}
