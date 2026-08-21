import Foundation
import Combine

@MainActor
final class ProductDetailViewModel: ObservableObject {
    let product: Product
    @Published private(set) var isFavorite: Bool

    private let favoritesRepository: FavoritesRepository

    init(product: Product, favoritesRepository: FavoritesRepository) {
        self.product = product
        self.favoritesRepository = favoritesRepository
        self.isFavorite = favoritesRepository.isFavorite(productID: product.id)
    }

    func toggleFavorite() {
        favoritesRepository.toggleFavorite(productID: product.id)
        isFavorite = favoritesRepository.isFavorite(productID: product.id)
    }
}
