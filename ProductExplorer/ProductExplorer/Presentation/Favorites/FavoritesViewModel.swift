import Foundation
import Combine

@MainActor
final class FavoritesViewModel: ObservableObject {
    @Published private(set) var state: ViewState<[Product]> = .loading

    private let productRepository: ProductRepository
    private let favoritesRepository: FavoritesRepository

    init(productRepository: ProductRepository, favoritesRepository: FavoritesRepository) {
        self.productRepository = productRepository
        self.favoritesRepository = favoritesRepository
    }

    func loadFavorites() async {
        state = .loading
        do {
            let allProducts = try await productRepository.fetchProducts()
            let favoriteIDs = favoritesRepository.favoriteIDs()
            let favorites = allProducts.filter { favoriteIDs.contains($0.id) }
            state = favorites.isEmpty ? .empty : .success(favorites)
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    func removeFromFavorites(_ product: Product) {
        favoritesRepository.toggleFavorite(productID: product.id)
        if case .success(let products) = state {
            let updated = products.filter { $0.id != product.id }
            state = updated.isEmpty ? .empty : .success(updated)
        }
    }
}
