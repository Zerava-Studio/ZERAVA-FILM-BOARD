# Zerava Filmboard

Aplikasi manajemen film board untuk Zerava Studio dengan fitur chat realtime, manajemen proyek, dan sistem kelas.

## 🚀 Deployment

Aplikasi ini di-deploy ke GitHub Pages dengan custom domain:
- **URL:** https://filmboard.zerava.web.id
- **Repository:** https://github.com/Zerava-Studio/ZERAVA-FILM-BOARD

## ⚙️ Setup Instructions

### 1. Supabase Setup

1. Buat project baru di [supabase.com](https://supabase.com)
2. Jalankan script SQL dari file `supabase-setup.sql` di Supabase SQL Editor
3. Dapatkan credentials dari Settings > API:
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`
4. Update file `index.html` di line 20-21:
```javascript
const SUPABASE_URL = 'https://your-project.supabase.co';
const SUPABASE_ANON_KEY = 'your-anon-key-here';
```

### 2. Cloudflare R2 & Worker Setup

1. Buat R2 bucket bernama `zerava-storage` di Cloudflare Dashboard
2. Hubungkan custom domain `files.zerava.web.id` ke bucket
3. Setup CORS policy:
```json
[
  {
    "AllowedOrigins": ["*"],
    "AllowedMethods": ["GET", "PUT", "POST", "DELETE", "HEAD"],
    "AllowedHeaders": ["*"],
    "MaxAgeSeconds": 86400
  }
]
```
4. Deploy Worker dari file `cloudflare-worker-upload.js` menggunakan Wrangler:
```bash
npm install -g wrangler
wrangler login
wrangler deploy
```
5. Update file `index.html` di line 22:
```javascript
const CLOUDFLARE_UPLOAD_WORKER = 'https://upload.zerava.web.id/upload';
```

### 3. GitHub Pages Configuration

1. Pastikan file `CNAME` berisi: `filmboard.zerava.web.id`
2. Di repository Settings > Pages:
   - Source: Deploy from branch `main`
   - Folder: `/ (root)`
3. Tambahkan custom domain `filmboard.zerava.web.id`
4. Update DNS records di domain provider Anda

## 📝 Fitur

- **Login System:** Email/Username authentication
- **Chat Realtime:** Group chat dan private chat (via Supabase)
- **Project Management:** Manajemen proyek film dengan naskah, shootlist, storyboard, dan dokumen
- **Zerava Class:** Sistem pembelajaran dengan materi dan modul
- **File Upload:** Upload file maksimal 15MB (via Cloudflare R2 Worker, fallback ke base64)
- **Notifications:** Sistem notifikasi untuk chat dan materi baru
- **Dark Mode:** Tema gelap/terang otomatis
- **Database Sync:** Realtime sync via Supabase dengan localStorage fallback

## 🔐 Security Notes

- Supabase Anon Key aman untuk penggunaan client-side
- RLS (Row Level Security) diaktifkan di Supabase dengan policy publik read/write
- Cloudflare Worker menyimpan R2 credentials (tidak exposed di frontend)
- Validasi file size dilakukan di client-side (15MB max)

## 📦 Teknologi

- HTML5 + Vanilla JavaScript
- Tailwind CSS (via CDN)
- Supabase JS Client (via CDN)
- Cloudflare R2 + Workers (untuk file storage)
- LocalStorage (fallback database & session cache)

## 📁 File Structure

```
├── index.html                    # Main application
├── CNAME                        # Custom domain config
├── supabase-setup.sql           # Database setup script
├── cloudflare-worker-upload.js  # R2 upload worker
├── wrangler.toml                # Cloudflare Worker config
└── README.md                    # This file
```

## 🤝 Kontribusi

Repository ini dikelola oleh Zerava Studio untuk internal use.

---

**Developed by Zerava Studio**
