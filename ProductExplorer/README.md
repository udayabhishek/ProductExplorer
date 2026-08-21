# Product Explorer

A minimal SwiftUI app (MVVM + Clean Architecture) that lists products from
[fakestoreapi.com](https://fakestoreapi.com/products), shows product detail,
and lets you favorite/unfavorite products.

## Setup (Xcode)

This is delivered as source files rather than a `.xcodeproj` so it's easy to
read/review. To run it:

1. Open Xcode → **File → New → Project → iOS → App**.
   - Product Name: `ProductExplorer`
   - Interface: **SwiftUI**, Language: **Swift**
   - Uncheck "Include Tests" if it doesn't let you pick names — we'll add
     the two test targets manually in step 3.
2. Delete the default `ContentView.swift` and generated `ProductExplorerApp.swift`.
3. In Finder, drag the `ProductExplorer/App`, `Domain`, `Data`, and
   `Presentation` folders into the Xcode project navigator (check
   "Copy items if needed" and "Create groups", target: `ProductExplorer`).
4. Add two test targets:
   - **File → New → Target → Unit Testing Bundle** → name it
     `ProductExplorerTests` → drag in the contents of
     `ProductExplorerTests/` (mocks + test files).
   - **File → New → Target → UI Testing Bundle** → name it
     `ProductExplorerUITests` → drag in
     `ProductExplorerUITests/ProductExplorerUITests.swift`.
5. Build & run (⌘R). Run tests with ⌘U.

No third-party dependencies — pure `URLSession`, `SwiftUI`, `XCTest`.

## Architecture

```
Presentation (SwiftUI Views + ViewModels)
        │  depends on
        ▼
   Domain (Product, ProductRepository / FavoritesRepository protocols)
        ▲  implemented by
        │
   Data (ProductRepositoryImpl, FavoritesStore, ProductAPIService, APIClient)
```

- **Domain** — pure Swift, no imports of `Foundation` networking types
  beyond `URL`. Defines `Product` and the two repository *protocols*.
  Nothing here knows about JSON or UserDefaults.
- **Data** — implements those protocols. `ProductAPIService` +
  `APIClient` handle networking and decode `ProductDTO` → `Product`.
  `FavoritesStore` implements `FavoritesRepository` on top of
  `UserDefaults`. **ViewModels never touch `URLSession` or `UserDefaults`
  directly** — only the protocols, injected via `AppDependencies`.
- **Presentation** — one `ViewModel` + one `View` per screen:
  - `ProductListViewModel` / `ProductListView`
  - `ProductDetailViewModel` / `ProductDetailView`
  - `FavoritesViewModel` / `FavoritesView`

  Each list-based ViewModel exposes a single `ViewState<[Product]>`
  (`.loading`, `.success`, `.empty`, `.error`) so the View is a simple
  `switch` with no ad-hoc boolean flags.

- **Dependency injection** — `AppDependencies` builds the concrete
  repository instances once at app launch and hands out protocol-typed
  references to each ViewModel factory method. Tests substitute
  `MockProductRepository` / `MockFavoritesRepository` instead.

## Tests

- `ProductListViewModelTests` — success / empty / error states, favorite toggling.
- `FavoritesViewModelTests` — filtering to only favorited products, removal.
- `FavoritesStoreTests` — persistence add/remove roundtrip.
- `ProductRepositoryImplTests` — DTO → domain model mapping.
- `ProductExplorerUITests` — list → detail navigation, favoriting, and
  confirming the product appears on the Favorites tab.

## Notable simplifications (intentional, for interview scope)

- No explicit "UseCase" layer — `ProductRepository` / `FavoritesRepository`
  protocols are thin enough that ViewModels call them directly. Easy to
  introduce `FetchProductsUseCase` etc. later without touching the Data layer.
- No caching/offline layer — Favorites are persisted (UserDefaults),
  product data is re-fetched each time.
- No pagination — fakestoreapi returns the full list in one call.
