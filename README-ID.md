# Aplikasi iOS The Movie 🎬

![Swift](https://img.shields.io/badge/Swift-6.0-orange?style=flat-square)
![Platform](https://img.shields.io/badge/Platform-iOS_17.0+-lightgrey?style=flat-square)
![Architecture](https://img.shields.io/badge/Architecture-MVVM-blue?style=flat-square)

**The Movie** adalah aplikasi iOS modern untuk menelusuri film populer, mencari film favorit, dan mengelola daftar tontonan pribadi. Dibangun dengan **SwiftUI** dan **SwiftData**, aplikasi ini menunjukkan arsitektur *offline-first* yang kuat dan kepatuhan konkurensi Swift 6.

---

## ✨ Fitur Utama

- **Offline-First**: Akses instant ke data film populer melalui cache SwiftData.
- **Konfigurasi Aman**: Manajemen API Key menggunakan `.xcconfig`.
- **Pagination**: Menjelajahi ribuan film dengan *infinite scroll*.
- **Detail Lengkap**: Sinkronisasi data detail film, genre, dan trailer YouTube.

---

## 🏗 Arsitektur & Teknologi

Aplikasi ini menggunakan pendekatan **Clean Architecture** dengan **MVVM-State**:
- **UI**: SwiftUI (iOS 17+)
- **Persistensi**: SwiftData (`@Model`)
- **Networking**: Alamofire dengan Async/Await
- **Keamanan**: Build Configurations (.xcconfig)

---

## 📂 Struktur Proyek

```
TheMovie/
├── App/                   # Entry Point, Config, & DI Container
├── Data/                  # Local Storage, Remote API, & Repository
├── Features/              # Fitur App (List, Detail, Favorites)
├── Shared/                # Komponen UI & Utils
└── Assets.xcassets        # Aset Visual
```

---

## 📚 Panduan Persiapan Interview Teknis

Untuk memahami logika kode secara mendalam (analisis baris-demi-baris) dan persiapan interview, silakan baca:
👉 **[PANDUAN INTERVIEW & DEEP DIVE KODE](docs/InterviewGuide.md)**
