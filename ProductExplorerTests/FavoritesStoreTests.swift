import XCTest
@testable import ProductExplorer

final class FavoritesStoreTests: XCTestCase {

    private var defaults: UserDefaults!
    private var sut: FavoritesStore!

    override func setUp() {
        super.setUp()
        defaults = UserDefaults(suiteName: #file)
        defaults.removePersistentDomain(forName: #file)
        sut = FavoritesStore(defaults: defaults)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: #file)
        super.tearDown()
    }

    func test_toggleFavorite_addsAndRemovesID() {
        XCTAssertFalse(sut.isFavorite(productID: 5))

        sut.toggleFavorite(productID: 5)
        XCTAssertTrue(sut.isFavorite(productID: 5))
        XCTAssertEqual(sut.favoriteIDs(), [5])

        sut.toggleFavorite(productID: 5)
        XCTAssertFalse(sut.isFavorite(productID: 5))
        XCTAssertTrue(sut.favoriteIDs().isEmpty)
    }
}
