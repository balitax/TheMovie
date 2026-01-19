# Building a Local-First iOS App with SwiftData & Alamofire: "The Movie" Case Study

In today's mobile application landscape, speed and reliability are the primary keys to user retention. Users no longer tolerate long loading spinners or app failures when they are in areas with limited internet connectivity. This is where the **Local-First** approach becomes crucial.

This article provides an in-depth look at the technical implementation of **"The Movie"**—a modern movie catalog application built using **SwiftUI**, **SwiftData**, and **Alamofire**, following **Swift 6** standards.

You can view the full source code at: [https://github.com/balitax/TheMovie](https://github.com/balitax/TheMovie)

---

## 🚀 Why Choose a Local-First Strategy?

Local-first is not just an "offline mode" feature. It is a paradigm shift where the application state is managed locally and synchronized with the server in the background. Its primary benefits include:

1.  **Zero Latency**: Data is displayed instantly from the disk instead of waiting for the network.
2.  **Battery Efficiency**: Reduces the frequency of power-hungry cellular radio usage.
3.  **Premium User Experience**: The app remains responsive even in elevators or tunnels.

---

## 🏗 Architecture: Implementing a Single Source of Truth

To maintain scalability, this application implements a combination of **MVVM** and the **Repository Pattern**. This architecture ensures a clear separation of concerns:

-   **Model (SwiftData Entities)**: Data representations defined using the `@Model` macro.
-   **View (SwiftUI)**: An interface that reacts to state changes.
-   **ViewModel**: Manages UI logic and interacts with the Repository using the `@Observable` macro.
-   **Repository**: Acts as a "mediator" that decides whether to fetch data from the local cache or the remote API.

### SwiftData Entity Implementation Example
```swift
@Model
final class MovieEntity {
    @Attribute(.unique) var id: Int
    var title: String
    var overview: String
    var posterPath: String?
    var releaseDate: String?
    var popularity: Double
    var voteAverage: Double
    var voteCount: Int
    var isFavorite: Bool = false
    
    // ... init
}
```

---

## 🛠 Technical Core: Repository Synchronization

The biggest challenge with Local-First is determining when local data should be refreshed. In the "The Movie" project, we use intelligent logic within the `MovieRepository`:

```swift
func getPopularMovies(page: Int = 1, forceRefresh: Bool = false) async throws -> PaginatedResult {
    // 1. Prioritize Cache for the first page
    if !forceRefresh, page == 1,
       let cached = try? local.fetchMovies(), !cached.isEmpty {
        // Sync favorite status in real-time
        cached.forEach { $0.isFavorite = local.isFavorite(id: $0.id) }
        return PaginatedResult(movies: cached, totalPages: Int.max, currentPage: 1)
    }

    // 2. Fetch latest data from TMDB API via Alamofire
    let response: MovieDTO = try await remote.request(.popular(page: page))
    let entities = response.results.map { $0.toEntity() }

    // 3. Atomically Update Local Cache
    if page == 1 {
        try? local.clear()
        try? local.save(entities)
    }

    return PaginatedResult(movies: entities, totalPages: response.totalPages, currentPage: response.page)
}
```

**Code Analysis:**
-   `forceRefresh`: Allows users to perform a "pull-to-refresh" to force a resynchronization.
-   `paging`: Pagination is managed such that only essential data is saved to disk to conserve storage space.

---

## 🌐 Networking with Alamofire & Swift 6 Concurrency

We leverage **Alamofire** with a modern approach using `async/await`. With **Swift 6 Strict Concurrency** standards, we ensure no data races occur during API calls.

```swift
final class APIClient: NetworkService {
    func request<T: Decodable>(_ endpoint: MovieEndpoint) async throws -> T {
        let dataRequest = AF.request(APIConfig.baseURL + endpoint.path, parameters: endpoint.parameters)
        
        let response = await dataRequest
            .serializingDecodable(T.self)
            .response

        switch response.result {
        case .success(let value):
            return value
        case .failure(let error):
            throw NetworkError.unknown(error)
        }
    }
}
```

---

## 🎨 UI/UX: Beauty Above Performance

High performance is incomplete without a stunning UI. SwiftUI makes it easy to create complex layouts with declarative code.

### Desktop-Class Grid
Using `LazyVGrid`, the app can render thousands of items with minimal memory usage.
```swift
LazyVGrid(columns: columns, spacing: 16) {
    ForEach(viewModel.state.movies) { movie in
        NavigationLink(destination: DetailMovieView(...)) {
            MovieCell(movie: movie)
        }
        .onAppear {
            if movie == viewModel.state.movies.last {
                viewModel.send(.loadMore)
            }
        }
    }
}
```

### Smart Image Caching
We use the **Kingfisher** library to automatically handle image caching on disk and in memory, making navigation between screens feel instantaneous.

---

## 🧪 Testing & Code Quality

Application reliability is guaranteed through a comprehensive test suite:
-   **Unit Testing**: Ensures ViewModel and Repository logic perform as expected.
-   **UI Testing**: Automatically tests the app flow from the Splash Screen to Favorite interactions.

---

## 💡 Conclusion

Building an application with a **Local-First** philosophy requires careful planning, especially at the data layer. However, the end result—a lightning-fast, reliable, and data-efficient app—provides invaluable value to the end user.

SwiftData, combined with the ease of SwiftUI and the robustness of Alamofire, makes developing applications like "The Movie" a new standard in the iOS ecosystem.

**Check Out the Project Now:**
🔗 [GitHub Repository: balitax/TheMovie](https://github.com/balitax/TheMovie)

---
*The author is a mobile development enthusiast who believes the best software is the one that keeps working even without a connection.*
