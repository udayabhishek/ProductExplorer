import XCTest

final class ProductExplorerUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func test_navigateFromListToDetail_andToggleFavorite() throws {
        let app = XCUIApplication()
        app.launch()

        // Product List screen loads and shows at least one row.
        let firstCell = app.collectionViews.firstMatch.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10), "Product list should load a first row")

        // Navigate to Product Detail.
        firstCell.tap()

        let favoriteButton = app.buttons["favoriteButton"]
        XCTAssertTrue(favoriteButton.waitForExistence(timeout: 5), "Detail screen should show a favorite button")

        // Add to favorites.
        favoriteButton.tap()

        // Go back to the list.
        app.navigationBars.buttons.element(boundBy: 0).tap()

        // Switch to Favorites tab and confirm the product shows up there.
        app.tabBars.buttons["Favorites"].tap()
        let favoritesCell = app.collectionViews.firstMatch.cells.firstMatch
        XCTAssertTrue(favoritesCell.waitForExistence(timeout: 10), "Favorited product should appear in Favorites tab")
    }
}
