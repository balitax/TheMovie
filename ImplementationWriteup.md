# TheMovie App Implementation Write-up

This document outlines the key decisions, challenges, and solutions encountered during the development of "TheMovie" iOS application.

## 🏗 Architectural Decisions

### 1. MVVM + State Pattern (Unidirectional Flow)
I implemented an MVVM architecture enhanced with a `State` struct for each ViewModel. This decision was made to:
- **Simplify UI Updates**: Using `@Observable` (SwiftUI 5.0+) ensures that any change in the state automatically updates the view.
- **Predictable Logic**: Centralizing all actions in a `send(_ action:)` method makes the business logic easier to track and debug.

### 2. Offline-First with SwiftData
To ensure a smooth user experience even without internet, I implemented an offline-first strategy:
- Movies are cached locally using **SwiftData**.
- The app displays cached data immediately on launch, while a fresh network fetch kicks in in the background or when explicitly requested via Pull to Refresh.

### 3. Repository Pattern
I used a `MovieRepository` to decouple the data source (Remote API vs Local Database) from the business logic. This allowed for:
- Easy mocking during Unit Testing.
- Centralized logic for synchronization (e.g., clearing cache when Page 1 of popular movies is fetched).

---

## 🚧 Challenges Faced & Solutions

### 1. Resilience to Inconsistent API Data
**Challenge**: The app initially crashed with `DecodingError.keyNotFound` because the Movie Database API sometimes omitted fields like `genre_ids` or `popularity` for certain movies.
**Solution**: I refactored the `MovieDTO` to make almost all non-essential fields optional (`?`) and provided safe default values (like empty arrays or 0.0) during the mapping to `MovieEntity`. This made the app significantly more robust against malformed JSON.

### 2. Complex Pagination Logic
**Challenge**: Implementing infinite scroll was tricky, especially with the offline-first requirement. When data was loaded from cache, the app initially signaled "Page 1 of 1", which blocked the loading of subsequent pages.
**Solution**: 
- I modified the Repository to return `totalPages: Int.max` when serving cached data, fooling the ViewModel into allowing a "Load More" trigger.
- Once Page 2 is fetched from the network, the real `totalPages` value from the API is synced, ensuring the pagination eventually stops correctly.

### 3. Premature Pagination Triggers
**Challenge**: Placing a `ProgressView` at the bottom of a `LazyVGrid` caused the app to automatically load several pages at once because SwiftUI eagerly loads views at the edge of the screen.
**Solution**: I moved the pagination trigger to the `.onAppear` modifier of the **last visible movie card** in the list. This ensures that the next page is only requested when the user physically scrolls to the end of the current results.

### 4. UI Flickering on Initial Launch
**Challenge**: On launch, the `EmptyStateView` would flash briefly before the movies appeared because the network call was happening asynchronously.
**Solution**:- I updated the ViewModel to set `isLoading = true` **synchronously** as soon as the `.onAppear` action is received, ensuring the loading indicator is the first thing the user sees if data isn't ready.

### 5. Decoupling Favorites from Cache (Persistent Favorites)
**Challenge**: Initially, `MovieEntity` used an `isFavorite` flag. However, when the user pulled to refresh, the local cache was cleared to make way for fresh data, unintentionally wiping out all user favorites.
**Solution**: 
- I refactored the architecture to include a dedicated `FavoriteMovieEntity`. 
- The `MovieRepository` now serves as a synchronization layer: every time movies are fetched (from network or cache), it cross-references the IDs with the persistent `FavoriteMovieEntity` table to determine the `isFavorite` status.
- This ensures that favorites are **permanent** while the movie list remains **volatile and up-to-date**.

### 6. SwiftData Race Conditions in Unit Tests (malloc errors)
**Challenge**: During automated testing, the repeated creation and destruction of `ModelContainer` in parallel environments caused `malloc` corruption and "double-free" errors.
**Solution**: 
- I implemented a **Singleton ModelContainer** (`TestModelContainer.shared`) for all test suites. 
- By registering the schema once per process and using fresh `ModelContext` instances for each test (with explicit cleanup in `tearDown`), I achieved a 100% stable and high-performance test suite.

---

## 🛠 Tech Stack & Tools Used
- **SwiftUI**: Modern declarative UI with `@Observable` state management.
- **SwiftData**: High-performance local persistence for both caching and user data.
- **Alamofire**: Robust network requests with specialized TMDB routers.
- **Kingfisher**: High-performance image downloading and persistent caching.
- **Swift 6**: Strict concurrency compliance (`@MainActor`, `Sendable`).
- **XCTest**: Reliable Unit and UI automation.

## ✅ Conclusion
By combining modern SwiftUI patterns with a focus on data safety (Decoupled Favorites) and test reliability (Singleton Containers), I created an app that is not only visually premium but also architecturally solid and future-proof. 🚀🎬
