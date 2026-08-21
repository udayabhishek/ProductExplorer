import SwiftUI

struct RootTabView: View {
    let dependencies: AppDependencies

    var body: some View {
        TabView {
            ProductListView(dependencies: dependencies)
                .tabItem { Label("Products", systemImage: "list.bullet") }

            FavoritesView(dependencies: dependencies)
                .tabItem { Label("Favorites", systemImage: "heart") }
        }
    }
}
