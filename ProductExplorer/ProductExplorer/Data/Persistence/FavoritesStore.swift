import Foundation

/// UserDefaults-backed favorites persistence. Swappable for Core Data /
/// SwiftData later since callers only depend on `FavoritesRepository`.
final class FavoritesStore: FavoritesRepository {
    private let defaultsKey = "favorite_product_ids"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func favoriteIDs() -> Set<Int> {
        let array = defaults.array(forKey: defaultsKey) as? [Int] ?? []
        return Set(array)
    }

    func isFavorite(productID: Int) -> Bool {
        favoriteIDs().contains(productID)
    }

    func toggleFavorite(productID: Int) {
        var ids = favoriteIDs()
        if ids.contains(productID) {
            ids.remove(productID)
        } else {
            ids.insert(productID)
        }
        defaults.set(Array(ids), forKey: defaultsKey)
    }
}
