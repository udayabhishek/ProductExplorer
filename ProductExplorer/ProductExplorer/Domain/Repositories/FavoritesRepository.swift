import Foundation

/// Abstraction over favorites persistence. Presentation layer only knows
/// about this protocol, not that it's backed by UserDefaults.
protocol FavoritesRepository {
    func favoriteIDs() -> Set<Int>
    func isFavorite(productID: Int) -> Bool
    func toggleFavorite(productID: Int)
}
