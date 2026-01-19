# Membangun Aplikasi Local-First dengan SwiftData & Alamofire: Studi Kasus "The Movie"

Dalam lanskap pengembangan aplikasi mobile saat ini, kecepatan dan keandalan adalah kunci utama retensi pengguna. Pengguna tidak lagi memaklumi spinner loading yang lama atau kegagalan aplikasi saat berada di area dengan koneksi internet terbatas. Di sinilah pendekatan **Local-First** menjadi krusial.

Artikel ini akan membahas secara mendalam implementasi teknis aplikasi **"The Movie"**—sebuah aplikasi katalog film modern yang dibangun menggunakan **SwiftUI**, **SwiftData**, dan **Alamofire** dengan standar **Swift 6**.

Anda dapat melihat kode sumber lengkapnya di: [https://github.com/balitax/TheMovie](https://github.com/balitax/TheMovie)

---

## 🚀 Mengapa Memilih Strategi Local-First?

Local-first bukan sekadar fitur "offline mode". Ini adalah perubahan paradigma di mana state aplikasi dikelola secara lokal dan disinkronkan dengan server di latar belakang. Manfaat utamanya meliputi:

1.  **Latensi Nol**: Data ditampilkan secara instan dari disk, bukan menunggu jaringan.
2.  **Efisiensi Baterai**: Mengurangi frekuensi penggunaan radio seluler yang boros daya.
3.  **Pengalaman Pengguna Premium**: Aplikasi tetap responsif bahkan di dalam lift atau terowongan.

---

## 🏗 Arsitektur: Mewujudkan Single Source of Truth

Untuk menjaga skalabilitas, aplikasi ini menerapkan kombinasi **MVVM** dan **Repository Pattern**. Arsitektur ini memastikan pemisahan tanggung jawab yang jelas:

-   **Model (SwiftData Entities)**: Representasi data yang didefinisikan dengan makro `@Model`.
-   **View (SwiftUI)**: Antarmuka yang reaktif terhadap perubahan state.
-   **ViewModel**: Mengelola logika UI dan berinteraksi dengan Repository menggunakan makro `@Observable`.
-   **Repository**: Bertindak sebagai "mediator" yang menentukan apakah data diambil dari cache lokal atau API remote.

### Contoh Implementasi Entitas SwiftData
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

## 🛠 Inti Teknis: Sinkronisasi Repository

Tantangan terbesar Local-First adalah menentukan kapan data lokal harus di-refresh. Dalam proyek "The Movie", kami menggunakan logika cerdas di dalam `MovieRepository`:

```swift
func getPopularMovies(page: Int = 1, forceRefresh: Bool = false) async throws -> PaginatedResult {
    // 1. Prioritaskan Cache untuk halaman pertama
    if !forceRefresh, page == 1,
       let cached = try? local.fetchMovies(), !cached.isEmpty {
        // Sync status favorit secara real-time
        cached.forEach { $0.isFavorite = local.isFavorite(id: $0.id) }
        return PaginatedResult(movies: cached, totalPages: Int.max, currentPage: 1)
    }

    // 2. Fetch data terbaru dari TMDB API melalui Alamofire
    let response: MovieDTO = try await remote.request(.popular(page: page))
    let entities = response.results.map { $0.toEntity() }

    // 3. Update Cache Lokal secara atomik
    if page == 1 {
        try? local.clear()
        try? local.save(entities)
    }

    return PaginatedResult(movies: entities, totalPages: response.totalPages, currentPage: response.page)
}
```

**Analisis Kode:**
-   `forceRefresh`: Memungkinkan pengguna melakukan "pull-to-refresh" untuk memaksa sinkronisasi ulang.
-   `paging`: Paginasi dikelola sedemikian rupa sehingga hanya data esensial yang disimpan di disk untuk menghemat ruang penyimpanan.

---

## 🌐 Networking dengan Alamofire & Swift 6 Concurrency

Kami memanfaatkan **Alamofire** dengan pendekatan modern menggunakan `async/await`. Dengan standard **Swift 6 Strict Concurrency**, kami memastikan tidak ada *data race* saat melakukan panggilan API.

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

## 🎨 UI/UX: Keindahan di Atas Performa

Performa tinggi tidak lengkap tanpa UI yang menawan. SwiftUI memudahkan kita membuat layout yang kompleks dengan kode yang deklaratif.

### Grid Desktop-Class
Menggunakan `LazyVGrid`, aplikasi ini mampu merender ribuan item dengan penggunaan memori yang minimal.
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

### Caching Gambar Cerdas
Kami menggunakan library **Kingfisher** untuk menangani caching gambar di disk dan memori secara otomatis, sehingga navigasi antar layar terasa sangat instan.

---

## 🧪 Pengujian & Kualitas Kode

Keandalan aplikasi dijamin melalui test suite yang komprehensif:
-   **Unit Testing**: Memastikan logika ViewModel dan Repository berjalan sesuai ekspektasi.
-   **UI Testing**: Menguji alur aplikasi secara otomatis mulai dari Splash Screen hingga interaksi Favorit.

---

## 💡 Kesimpulan

Membangun aplikasi dengan filosofi **Local-First** memerlukan perencanaan yang matang, terutama pada layer data. Namun, hasil akhirnya—aplikasi yang sangat cepat, handal, dan hemat data—memberikan nilai tambah yang tak ternilai bagi pengguna akhir.

SwiftData, dikombinasikan dengan kemudahan SwiftUI dan ketangguhan Alamofire, menjadikan pengembangan aplikasi seperti "The Movie" menjadi sebuah standar baru dalam ekosistem iOS.

**Cek Proyeknya Sekarang:**
🔗 [Repositori GitHub: balitax/TheMovie](https://github.com/balitax/TheMovie)

---
*Penulis adalah seorang antusias pengembangan mobile yang percaya bahwa software terbaik adalah yang tetap bekerja meski tanpa koneksi.*
