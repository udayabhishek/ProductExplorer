import Foundation

/// Pure domain model. No Codable, no networking concerns — this is what
/// the rest of the app (ViewModels, Views) actually works with.
struct Product: Identifiable, Equatable, Hashable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let imageURL: URL?
}
