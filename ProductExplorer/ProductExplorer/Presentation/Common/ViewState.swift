import Foundation

/// Shared UI state used by every screen so loading / success / empty /
/// error are handled the same way everywhere.
enum ViewState<T> {
    case loading
    case success(T)
    case empty
    case error(String)
}
