import Foundation

/// Wire format for https://fakestoreapi.com/products.
/// Kept separate from the domain `Product` so API shape changes never
/// ripple into the rest of the app.
struct ProductDTO: Decodable, Equatable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String

    func toDomain() -> Product {
        Product(
            id: id,
            title: title,
            price: price,
            description: description,
            category: category,
            imageURL: URL(string: image)
        )
    }
}
