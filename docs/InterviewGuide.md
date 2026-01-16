# 🎬 Panduan Interview & Dokumentasi Kode Terperinci "TheMovie"

Dokumen ini adalah referensi teknis lengkap untuk proyek **TheMovie**. Dirancang agar Anda dapat menjelaskan setiap bagian kode mulai dari arsitektur hingga detail implementasi baris demi baris.

---

## 🏗️ 1. Arsitektur: High-Level Overview

Proyek ini menggunakan **Clean Architecture** dengan pola **MVVM-State**.

- **AppLayer**: Entry point dan kontainer dependensi.
- **DataLayer**: Remote (API) dan Local (SwiftData).
- **DomainLayer**: `MovieRepository` yang menjembatani data dan logika.
- **PresentationLayer**: SwiftUI View yang mengamati `State` dari ViewModel.

---

## 📡 2. Networking Layer (Alamofire + Async/Await)

### **[MovieEndpoint.swift](file:///Users/bareksa/Documents/TheMovie/TheMovie/Data/Remote/MovieEndpoint.swift)**
Menggunakan `enum` untuk mendefinisikan semua API call.
- **Line 27-45**: Fungsi `parameters` secara otomatis menambahkan `api_key` ke setiap request.
- **Line 41**: Menggunakan `append_to_response=videos` untuk mendapatkan link YouTube trailer dalam satu request detail film.

### **[APIClient.swift](file:///Users/bareksa/Documents/TheMovie/TheMovie/Data/Remote/APIClient.swift)**
- **Generics**: Fungsi `request<T: Decodable>` memungkinkan kita menggunakannya untuk berbagai macam tipe response.
- **Async/Await**: Pendekatan deklaratif untuk menunggu response tanpa callback hell.

---

## 🔐 3. Security: .xcconfig & Info.plist

Aplikasi ini menggunakan praktik keamanan terbaik untuk menyimpan data sensitif:
- **[Config.xcconfig](file:///Users/bareksa/Documents/TheMovie/TheMovie/App/Config.xcconfig)**: Menyimpan `TMDB_API_KEY`. Ini memisahkan konfigurasi dari kode sumber.
- **Info.plist**: Memetakan variabel lingkungan dari xcconfig agar dapat diakses oleh kode Swift.
- **[APIConfig.swift](file:///Users/bareksa/Documents/TheMovie/TheMovie/Data/Remote/APIConfig.swift)**: Membaca API Key secara dinamis menggunakan `Bundle.main.object(forInfoDictionaryKey:)`.

---

## 💾 4. Persistence Layer (SwiftData)

### **[MovieLocalDataSource.swift](file:///Users/bareksa/Documents/TheMovie/TheMovie/Data/Local/MovieLocalDataSource.swift)**
- Menggunakan `#Predicate` untuk filter database yang *typesafe*.

---

## 🧠 5. Repository: "The Core Brain"

### **[MovieRepository.swift](file:///Users/bareksa/Documents/TheMovie/TheMovie/Data/Repository/MovieRepository.swift)**
Fungsi `getPopularMovies` (Line 35):
1. **Offline-First**: Mengambil data dari `local` jika tersedia di halaman 1.
2. **Pagination Trick**: Return `totalPages: Int.max` untuk memicu load halaman berikutnya.
3. **Cache Sync**: Membersihkan cache lama saat mendapatkan data segar dari halaman 1 API.

---

## 📱 6. Presentation Layer (SwiftUI + @Observable)

### **[ListMovieViewModel.swift](file:///Users/bareksa/Documents/TheMovie/TheMovie/Features/List/ListMovieViewModel.swift)**
- **State-Action Pattern**: Memastikan Unidirectional Data Flow yang dapat diprediksi.

### **[ListMovieView.swift](file:///Users/bareksa/Documents/TheMovie/TheMovie/Features/List/ListMovieView.swift)**
- **Infinite Scrolling**: Trigger `.loadMore` pada item terakhir di `LazyVGrid`.
- **Pull-to-Refresh**: Menggunakan `.refreshable`.

---

## ❓ 7. Deep Dive Q&A

**P1: Mengapa menggunakan .xcconfig?**
> **Jawaban**: Untuk memisahkan konfigurasi (per-environment) dari kode sumber. Ini meningkatkan keamanan karena file konfigurasi bisa di-exclude dari version control (git) jika perlu, dan memudahkan manajemen key di berbagai schema build (Debug/Release).

**P2: Bagaimana cara kerja `toggleFavorite`?**
> **Jawaban**: Mengecek keberadaan film di database favorit via ID. Menghapus jika ada, menambah jika tidak ada. Update flag favorit di memori dilakukan instan untuk UI responsif.

---

> [!TIP]
> **Tips Interview**: Saat ditanya tentang keamanan, sebutkan implementasi `.xcconfig` ini sebagai bukti Anda memahami standar industri dalam melindungi API keys.
