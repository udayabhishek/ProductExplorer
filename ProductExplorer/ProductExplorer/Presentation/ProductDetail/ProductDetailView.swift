import SwiftUI

struct ProductDetailView: View {
    @StateObject private var viewModel: ProductDetailViewModel

    init(product: Product, dependencies: AppDependencies) {
        _viewModel = StateObject(wrappedValue: dependencies.makeProductDetailViewModel(product: product))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: viewModel.product.imageURL) { phase in
                    if let image = phase.image {
                        image.resizable().scaledToFit()
                    } else {
                        Color.gray.opacity(0.15)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 220)

                Text(viewModel.product.title)
                    .font(.title2).bold()

                Text("$\(viewModel.product.price, specifier: "%.2f")")
                    .font(.title3)
                    .foregroundStyle(.secondary)

                Text(viewModel.product.category.capitalized)
                    .font(.caption)
                    .padding(.horizontal, 8).padding(.vertical, 4)
                    .background(Color.secondary.opacity(0.15))
                    .clipShape(Capsule())

                Text(viewModel.product.description)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: viewModel.toggleFavorite) {
                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                        .foregroundStyle(viewModel.isFavorite ? .red : .primary)
                }
                .accessibilityIdentifier("favoriteButton")
            }
        }
    }
}
