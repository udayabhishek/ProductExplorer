import Foundation
@testable import ProductExplorer

final class MockProductRepository: ProductRepository {
    var productsToReturn: [Product] = []
    var errorToThrow: Error?
    private(set) var fetchCallCount = 0

    func fetchProducts() async throws -> [Product] {
        fetchCallCount += 1
        if let errorToThrow { throw errorToThrow }
        return productsToReturn
    }
}
