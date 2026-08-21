import Foundation
@testable import ProductExplorer

final class MockFavoritesRepository: FavoritesRepository {
    private var ids: Set<Int> = []

    func favoriteIDs() -> Set<Int> { ids }

    func isFavorite(productID: Int) -> Bool { ids.contains(productID) }

    func toggleFavorite(productID: Int) {
        if ids.contains(productID) {
            ids.remove(productID)
        } else {
            ids.insert(productID)
        }
    }
}
