import SwiftUI

@main
struct ProductExplorerApp: App {
    private let dependencies = AppDependencies()

    var body: some Scene {
        WindowGroup {
            RootTabView(dependencies: dependencies)
        }
    }
}
