import Foundation
import Combine

@MainActor
final class ProductListViewModel: ObservableObject {
    @Published private(set) var state: ViewState<[Product]> = .loading
    @Published private(set) var favoriteIDs: Set<Int> = []

    private let productRepository: ProductRepository
    private let favoritesRepository: FavoritesRepository

    init(productRepository: ProductRepository, favoritesRepository: FavoritesRepository) {
        self.productRepository = productRepository
        self.favoritesRepository = favoritesRepository
    }

    func loadProducts() async {
        state = .loading
        favoriteIDs = favoritesRepository.favoriteIDs()
        do {
            let products = try await productRepository.fetchProducts()
            state = products.isEmpty ? .empty : .success(products)
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    func isFavorite(_ product: Product) -> Bool {
        favoriteIDs.contains(product.id)
    }

    func toggleFavorite(_ product: Product) {
        favoritesRepository.toggleFavorite(productID: product.id)
        favoriteIDs = favoritesRepository.favoriteIDs()
    }
}
