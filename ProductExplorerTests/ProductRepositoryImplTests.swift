import XCTest
@testable import ProductExplorer

final class ProductRepositoryImplTests: XCTestCase {

    private struct MockAPIService: ProductAPIServiceProtocol {
        let dtos: [ProductDTO]
        func fetchProducts() async throws -> [ProductDTO] { dtos }
    }

    func test_fetchProducts_mapsDTOsToDomainModels() async throws {
        let dto = ProductDTO(
            id: 1, title: "Shirt", price: 9.99, description: "d",
            category: "clothing", image: "https://example.com/img.png"
        )
        let sut = ProductRepositoryImpl(apiService: MockAPIService(dtos: [dto]))

        let products = try await sut.fetchProducts()

        XCTAssertEqual(products.count, 1)
        XCTAssertEqual(products.first?.id, 1)
        XCTAssertEqual(products.first?.title, "Shirt")
        XCTAssertEqual(products.first?.imageURL?.absoluteString, "https://example.com/img.png")
    }
}
