import SwiftUI

struct FavoritesView: View {
    @StateObject private var viewModel: FavoritesViewModel
    let dependencies: AppDependencies

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _viewModel = StateObject(wrappedValue: dependencies.makeFavoritesViewModel())
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Favorites")
                .task { await viewModel.loadFavorites() }
                .refreshable { await viewModel.loadFavorites() }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView("Loading favorites…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .empty:
            ContentUnavailableView("No Favorites Yet", systemImage: "heart")

        case .error(let message):
            ErrorStateView(message: message) {
                Task { await viewModel.loadFavorites() }
            }

        case .success(let products):
            List(products) { product in
                NavigationLink(value: product) {
                    Text(product.title)
                }
                .swipeActions {
                    Button("Remove", role: .destructive) {
                        viewModel.removeFromFavorites(product)
                    }
                }
            }
            .listStyle(.plain)
            .navigationDestination(for: Product.self) { product in
                ProductDetailView(product: product, dependencies: dependencies)
            }
        }
    }
}
