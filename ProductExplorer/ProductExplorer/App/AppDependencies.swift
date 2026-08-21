import Foundation

/// Simple manual DI container. Keeps object-graph construction in one place
/// so ViewModels never build their own dependencies (and stay testable).
final class AppDependencies {
    let productRepository: ProductRepository
    let favoritesRepository: FavoritesRepository

    init() {
        let apiClient = APIClient()
        let apiService = ProductAPIService(apiClient: apiClient)
        self.productRepository = ProductRepositoryImpl(apiService: apiService)
        self.favoritesRepository = FavoritesStore()
    }

    @MainActor
    func makeProductListViewModel() -> ProductListViewModel {
        ProductListViewModel(productRepository: productRepository, favoritesRepository: favoritesRepository)
    }

    @MainActor
    func makeFavoritesViewModel() -> FavoritesViewModel {
        FavoritesViewModel(productRepository: productRepository, favoritesRepository: favoritesRepository)
    }

    @MainActor
    func makeProductDetailViewModel(product: Product) -> ProductDetailViewModel {
        ProductDetailViewModel(product: product, favoritesRepository: favoritesRepository)
    }
}
