import Foundation

/// Abstraction the presentation layer depends on. The UI/ViewModels never
/// talk to the network directly — only to this protocol.
protocol ProductRepository {
    func fetchProducts() async throws -> [Product]
}
