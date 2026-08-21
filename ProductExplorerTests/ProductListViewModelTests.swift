import XCTest
@testable import ProductExplorer

@MainActor
final class ProductListViewModelTests: XCTestCase {

    func test_loadProducts_success_setsSuccessState() async {
        let repo = MockProductRepository()
        repo.productsToReturn = [
            Product(id: 1, title: "Shirt", price: 19.99, description: "desc", category: "clothing", imageURL: nil)
        ]
        let sut = ProductListViewModel(productRepository: repo, favoritesRepository: MockFavoritesRepository())

        await sut.loadProducts()

        guard case .success(let products) = sut.state else {
            return XCTFail("Expected success state")
        }
        XCTAssertEqual(products.count, 1)
        XCTAssertEqual(products.first?.title, "Shirt")
    }

    func test_loadProducts_emptyResult_setsEmptyState() async {
        let repo = MockProductRepository()
        repo.productsToReturn = []
        let sut = ProductListViewModel(productRepository: repo, favoritesRepository: MockFavoritesRepository())

        await sut.loadProducts()

        guard case .empty = sut.state else {
            return XCTFail("Expected empty state")
        }
    }

    func test_loadProducts_failure_setsErrorState() async {
        let repo = MockProductRepository()
        repo.errorToThrow = APIError.requestFailed("network down")
        let sut = ProductListViewModel(productRepository: repo, favoritesRepository: MockFavoritesRepository())

        await sut.loadProducts()

        guard case .error = sut.state else {
            return XCTFail("Expected error state")
        }
    }

    func test_toggleFavorite_updatesFavoriteState() async {
        let repo = MockProductRepository()
        let product = Product(id: 1, title: "Shirt", price: 19.99, description: "desc", category: "clothing", imageURL: nil)
        repo.productsToReturn = [product]
        let favoritesRepo = MockFavoritesRepository()
        let sut = ProductListViewModel(productRepository: repo, favoritesRepository: favoritesRepo)
        await sut.loadProducts()

        XCTAssertFalse(sut.isFavorite(product))
        sut.toggleFavorite(product)
        XCTAssertTrue(sut.isFavorite(product))
        sut.toggleFavorite(product)
        XCTAssertFalse(sut.isFavorite(product))
    }
}
