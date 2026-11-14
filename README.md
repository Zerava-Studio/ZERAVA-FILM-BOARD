# Zerava Filmboard

Aplikasi manajemen film board untuk Zerava Studio dengan fitur chat realtime, manajemen proyek, dan sistem kelas.

## 🚀 Deployment

Aplikasi ini sudah di-deploy ke GitHub Pages dengan custom domain:
- **URL:** https://filmboard.zerava.web.id
- **Repository:** https://github.com/Zerava-Studio/ZERAVA-FILM-BOARD

## ⚙️ Konfigurasi Supabase & Cloudflare R2

Untuk mengaktifkan fitur database dan upload file, Anda perlu mengkonfigurasi Supabase dan Cloudflare R2:

### 1. Supabase Setup

1. Buat project baru di [supabase.com](https://supabase.com)
2. Buat tabel-tabel berikut di SQL Editor:

```sql
-- Tabel Users
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  divisi TEXT,
  role TEXT,
  bio TEXT,
  avatar TEXT,
  is_admin BOOLEAN DEFAULT FALSE
);

-- Tabel Projects
CREATE TABLE projects (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  status TEXT,
  deadline TEXT
);

-- Tabel Messages
CREATE TABLE messages (
  id TEXT PRIMARY KEY,
  room_id TEXT NOT NULL,
  sender_id TEXT NOT NULL,
  text TEXT NOT NULL,
  timestamp TEXT NOT NULL
);
```

3. Dapatkan credentials dari Settings > API:
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`

4. Update file `index.html` di bagian konfigurasi (line 20-22):
```javascript
const SUPABASE_URL = 'https://your-project.supabase.co';
const SUPABASE_ANON_KEY = 'your-anon-key-here';
```

### 2. Cloudflare R2 Setup

1. Buat R2 bucket di Cloudflare Dashboard
2. Setup CORS policy untuk bucket:
```json
[
  {
    "AllowedOrigins": ["*"],
    "AllowedMethods": ["GET", "PUT", "POST"],
    "AllowedHeaders": ["*"],
    "MaxAgeSeconds": 3600
  }
]
```

3. Buat API endpoint untuk upload (bisa menggunakan Cloudflare Workers)
4. Update file `index.html` di bagian konfigurasi (line 25-26):
```javascript
const CLOUDFLARE_R2_ENDPOINT = 'https://your-r2-worker.workers.dev';
const CLOUDFLARE_R2_BUCKET = 'zerava-filmboard';
```

## 📝 Fitur

- **Login System:** Email/Username authentication
- **Chat Realtime:** Group chat dan private chat
- **Project Management:** Manajemen proyek film dengan naskah, shootlist, storyboard, dan dokumen
- **Zerava Class:** Sistem pembelajaran dengan materi dan modul
- **File Upload:** Upload file maksimal 15MB (via Cloudflare R2 atau base64 fallback)
- **Notifications:** Sistem notifikasi untuk chat dan materi baru
- **Dark Mode:** Tema gelap/terang otomatis

## 🔐 Security Notes

- Supabase Anon Key aman untuk penggunaan client-side
- Pastikan RLS (Row Level Security) diaktifkan di Supabase
- Validasi file size dilakukan di client-side (15MB max)

## 📦 Teknologi

- HTML5 + Vanilla JavaScript
- Tailwind CSS (via CDN)
- Supabase JS Client (via CDN)
- Cloudflare R2 (untuk file storage)
- LocalStorage (fallback database)

## 🤝 Kontribusi

Repository ini dikelola oleh Zerava Studio untuk internal use.

---

**Developed by Zerava Studio**
