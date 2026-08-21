import XCTest
@testable import ProductExplorer

@MainActor
final class FavoritesViewModelTests: XCTestCase {

    func test_loadFavorites_filtersOnlyFavoritedProducts() async {
        let repo = MockProductRepository()
        let p1 = Product(id: 1, title: "Shirt", price: 10, description: "d", category: "c", imageURL: nil)
        let p2 = Product(id: 2, title: "Shoes", price: 20, description: "d", category: "c", imageURL: nil)
        repo.productsToReturn = [p1, p2]

        let favoritesRepo = MockFavoritesRepository()
        favoritesRepo.toggleFavorite(productID: 2)

        let sut = FavoritesViewModel(productRepository: repo, favoritesRepository: favoritesRepo)
        await sut.loadFavorites()

        guard case .success(let products) = sut.state else {
            return XCTFail("Expected success state")
        }
        XCTAssertEqual(products.map(\.id), [2])
    }

    func test_loadFavorites_noFavorites_setsEmptyState() async {
        let repo = MockProductRepository()
        repo.productsToReturn = [
            Product(id: 1, title: "Shirt", price: 10, description: "d", category: "c", imageURL: nil)
        ]
        let sut = FavoritesViewModel(productRepository: repo, favoritesRepository: MockFavoritesRepository())

        await sut.loadFavorites()

        guard case .empty = sut.state else {
            return XCTFail("Expected empty state")
        }
    }

    func test_removeFromFavorites_removesProductFromSuccessState() async {
        let repo = MockProductRepository()
        let p1 = Product(id: 1, title: "Shirt", price: 10, description: "d", category: "c", imageURL: nil)
        repo.productsToReturn = [p1]

        let favoritesRepo = MockFavoritesRepository()
        favoritesRepo.toggleFavorite(productID: 1)

        let sut = FavoritesViewModel(productRepository: repo, favoritesRepository: favoritesRepo)
        await sut.loadFavorites()

        sut.removeFromFavorites(p1)

        guard case .empty = sut.state else {
            return XCTFail("Expected empty state after removing the only favorite")
        }
        XCTAssertFalse(favoritesRepo.isFavorite(productID: 1))
    }
}
