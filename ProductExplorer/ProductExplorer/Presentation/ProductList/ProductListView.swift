import SwiftUI

struct ProductListView: View {
    @StateObject private var viewModel: ProductListViewModel
    let dependencies: AppDependencies

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _viewModel = StateObject(wrappedValue: dependencies.makeProductListViewModel())
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Products")
                .task { await viewModel.loadProducts() }
                .refreshable { await viewModel.loadProducts() }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView("Loading products…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .empty:
            ContentUnavailableView("No Products", systemImage: "shippingbox")

        case .error(let message):
            ErrorStateView(message: message) {
                Task { await viewModel.loadProducts() }
            }

        case .success(let products):
            List(products) { product in
                NavigationLink(value: product) {
                    ProductRow(
                        product: product,
                        isFavorite: viewModel.isFavorite(product),
                        onToggleFavorite: { viewModel.toggleFavorite(product) }
                    )
                }
            }
            .listStyle(.plain)
            .navigationDestination(for: Product.self) { product in
                ProductDetailView(product: product, dependencies: dependencies)
            }
        }
    }
}

struct ErrorStateView: View {
    let message: String
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            Text("Something went wrong").font(.headline)
            Text(message).font(.subheadline).foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button("Retry", action: onRetry)
                .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct ProductRow: View {
    let product: Product
    let isFavorite: Bool
    let onToggleFavorite: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: product.imageURL) { phase in
                if let image = phase.image {
                    image.resizable().scaledToFit()
                } else {
                    Color.gray.opacity(0.15)
                }
            }
            .frame(width: 50, height: 50)
            .cornerRadius(8)

            VStack(alignment: .leading, spacing: 4) {
                Text(product.title).font(.subheadline).lineLimit(2)
                Text("$\(product.price, specifier: "%.2f")")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button(action: onToggleFavorite) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundStyle(isFavorite ? .red : .secondary)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
        }
        .padding(.vertical, 4)
    }
}
