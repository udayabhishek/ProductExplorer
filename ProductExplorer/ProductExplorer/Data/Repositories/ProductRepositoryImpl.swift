import Foundation

/// Concrete implementation of ProductRepository. This is the ONLY place
/// that talks to ProductAPIService. ViewModels only ever see the protocol.
final class ProductRepositoryImpl: ProductRepository {
    private let apiService: ProductAPIServiceProtocol

    init(apiService: ProductAPIServiceProtocol) {
        self.apiService = apiService
    }

    func fetchProducts() async throws -> [Product] {
        let dtos = try await apiService.fetchProducts()
        return dtos.map { $0.toDomain() }
    }
}
