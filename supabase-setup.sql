-- ============================================
-- SUPABASE SETUP SCRIPT FOR ZERAVA FILMBOARD
-- ============================================
-- Run this in Supabase SQL Editor
-- Access Token: Set in Supabase dashboard
-- ============================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- TABLE: zerava_users
-- ============================================
CREATE TABLE IF NOT EXISTS zerava_users (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  divisi TEXT,
  role TEXT,
  bio TEXT,
  avatar TEXT,
  is_admin BOOLEAN DEFAULT FALSE,
  password TEXT,
  online BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

-- ============================================
-- TABLE: zerava_nicknames
-- ============================================
CREATE TABLE IF NOT EXISTS zerava_nicknames (
  owner_id TEXT NOT NULL,
  target_id TEXT NOT NULL,
  nickname TEXT NOT NULL,
  PRIMARY KEY (owner_id, target_id),
  FOREIGN KEY (owner_id) REFERENCES zerava_users(id) ON DELETE CASCADE,
  FOREIGN KEY (target_id) REFERENCES zerava_users(id) ON DELETE CASCADE
);

-- ============================================
-- TABLE: zerava_groups
-- ============================================
CREATE TABLE IF NOT EXISTS zerava_groups (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  avatar TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

-- ============================================
-- TABLE: zerava_group_members
-- ============================================
CREATE TABLE IF NOT EXISTS zerava_group_members (
  group_id TEXT NOT NULL,
  user_id TEXT NOT NULL,
  PRIMARY KEY (group_id, user_id),
  FOREIGN KEY (group_id) REFERENCES zerava_groups(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES zerava_users(id) ON DELETE CASCADE
);

-- ============================================
-- TABLE: zerava_messages
-- ============================================
CREATE TABLE IF NOT EXISTS zerava_messages (
  id TEXT PRIMARY KEY,
  room_id TEXT NOT NULL,
  room_type TEXT DEFAULT 'group',
  sender_id TEXT NOT NULL,
  text TEXT NOT NULL,
  reply_to JSONB,
  timestamp TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
  FOREIGN KEY (sender_id) REFERENCES zerava_users(id) ON DELETE CASCADE
);

-- ============================================
-- TABLE: zerava_projects
-- ============================================
CREATE TABLE IF NOT EXISTS zerava_projects (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  status TEXT,
  deadline TEXT,
  naskah JSONB DEFAULT '[]'::jsonb,
  shootlist JSONB DEFAULT '[]'::jsonb,
  storyboard JSONB DEFAULT '[]'::jsonb,
  dokumen JSONB DEFAULT '[]'::jsonb,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

-- ============================================
-- TABLE: zerava_class_materials
-- ============================================
CREATE TABLE IF NOT EXISTS zerava_class_materials (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  thumbnail TEXT,
  file_name TEXT,
  file_size TEXT,
  url TEXT,
  uploader_id TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
  FOREIGN KEY (uploader_id) REFERENCES zerava_users(id) ON DELETE CASCADE
);

-- ============================================
-- TABLE: zerava_notifications
-- ============================================
CREATE TABLE IF NOT EXISTS zerava_notifications (
  id TEXT PRIMARY KEY,
  type TEXT NOT NULL,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  time TEXT NOT NULL,
  page TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

-- ============================================
-- TABLE: zerava_invites
-- ============================================
CREATE TABLE IF NOT EXISTS zerava_invites (
  id TEXT PRIMARY KEY,
  code TEXT UNIQUE NOT NULL,
  inviter_id TEXT NOT NULL,
  status TEXT DEFAULT 'pending',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
  FOREIGN KEY (inviter_id) REFERENCES zerava_users(id) ON DELETE CASCADE
);

-- ============================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================

-- Enable RLS on all tables
ALTER TABLE zerava_users ENABLE ROW LEVEL SECURITY;
ALTER TABLE zerava_nicknames ENABLE ROW LEVEL SECURITY;
ALTER TABLE zerava_groups ENABLE ROW LEVEL SECURITY;
ALTER TABLE zerava_group_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE zerava_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE zerava_projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE zerava_class_materials ENABLE ROW LEVEL SECURITY;
ALTER TABLE zerava_notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE zerava_invites ENABLE ROW LEVEL SECURITY;

-- Public read/write policies for zerava_users
CREATE POLICY "Users are viewable by everyone" ON zerava_users FOR SELECT USING (true);
CREATE POLICY "Users can be inserted by everyone" ON zerava_users FOR INSERT WITH CHECK (true);
CREATE POLICY "Users can be updated by everyone" ON zerava_users FOR UPDATE USING (true);
CREATE POLICY "Users can be deleted by everyone" ON zerava_users FOR DELETE USING (true);

-- Public read/write policies for zerava_nicknames
CREATE POLICY "Nicknames are viewable by everyone" ON zerava_nicknames FOR SELECT USING (true);
CREATE POLICY "Nicknames can be inserted by everyone" ON zerava_nicknames FOR INSERT WITH CHECK (true);
CREATE POLICY "Nicknames can be updated by everyone" ON zerava_nicknames FOR UPDATE USING (true);
CREATE POLICY "Nicknames can be deleted by everyone" ON zerava_nicknames FOR DELETE USING (true);

-- Public read/write policies for zerava_groups
CREATE POLICY "Groups are viewable by everyone" ON zerava_groups FOR SELECT USING (true);
CREATE POLICY "Groups can be inserted by everyone" ON zerava_groups FOR INSERT WITH CHECK (true);
CREATE POLICY "Groups can be updated by everyone" ON zerava_groups FOR UPDATE USING (true);
CREATE POLICY "Groups can be deleted by everyone" ON zerava_groups FOR DELETE USING (true);

-- Public read/write policies for zerava_group_members
CREATE POLICY "Group members are viewable by everyone" ON zerava_group_members FOR SELECT USING (true);
CREATE POLICY "Group members can be inserted by everyone" ON zerava_group_members FOR INSERT WITH CHECK (true);
CREATE POLICY "Group members can be deleted by everyone" ON zerava_group_members FOR DELETE USING (true);

-- Public read/write policies for zerava_messages
CREATE POLICY "Messages are viewable by everyone" ON zerava_messages FOR SELECT USING (true);
CREATE POLICY "Messages can be inserted by everyone" ON zerava_messages FOR INSERT WITH CHECK (true);
CREATE POLICY "Messages can be updated by everyone" ON zerava_messages FOR UPDATE USING (true);
CREATE POLICY "Messages can be deleted by everyone" ON zerava_messages FOR DELETE USING (true);

-- Public read/write policies for zerava_projects
CREATE POLICY "Projects are viewable by everyone" ON zerava_projects FOR SELECT USING (true);
CREATE POLICY "Projects can be inserted by everyone" ON zerava_projects FOR INSERT WITH CHECK (true);
CREATE POLICY "Projects can be updated by everyone" ON zerava_projects FOR UPDATE USING (true);
CREATE POLICY "Projects can be deleted by everyone" ON zerava_projects FOR DELETE USING (true);

-- Public read/write policies for zerava_class_materials
CREATE POLICY "Class materials are viewable by everyone" ON zerava_class_materials FOR SELECT USING (true);
CREATE POLICY "Class materials can be inserted by everyone" ON zerava_class_materials FOR INSERT WITH CHECK (true);
CREATE POLICY "Class materials can be updated by everyone" ON zerava_class_materials FOR UPDATE USING (true);
CREATE POLICY "Class materials can be deleted by everyone" ON zerava_class_materials FOR DELETE USING (true);

-- Public read/write policies for zerava_notifications
CREATE POLICY "Notifications are viewable by everyone" ON zerava_notifications FOR SELECT USING (true);
CREATE POLICY "Notifications can be inserted by everyone" ON zerava_notifications FOR INSERT WITH CHECK (true);
CREATE POLICY "Notifications can be updated by everyone" ON zerava_notifications FOR UPDATE USING (true);
CREATE POLICY "Notifications can be deleted by everyone" ON zerava_notifications FOR DELETE USING (true);

-- Public read/write policies for zerava_invites
CREATE POLICY "Invites are viewable by everyone" ON zerava_invites FOR SELECT USING (true);
CREATE POLICY "Invites can be inserted by everyone" ON zerava_invites FOR INSERT WITH CHECK (true);
CREATE POLICY "Invites can be updated by everyone" ON zerava_invites FOR UPDATE USING (true);
CREATE POLICY "Invites can be deleted by everyone" ON zerava_invites FOR DELETE USING (true);

-- ============================================
-- SEED DATA: 30 ZERAVA MEMBERS
-- ============================================

INSERT INTO zerava_users (id, name, email, divisi, role, bio, avatar, is_admin, password, online) VALUES
('u_0', 'Admin Zerava Studio', 'zeravaproduction@gmail.com', 'Management', 'Admin', 'Management Admin di Zerava Production.', 'https://ui-avatars.com/api/?name=Admin+Zerava+Studio&background=2B6E7E&color=fff&bold=true', true, '123456', true),
('u_1', 'Rifky Ivanda Hardiansyah', 'kikiivanda4@gmail.com', 'Soundman', 'Anggota', 'Soundman Anggota di Zerava Production.', 'https://ui-avatars.com/api/?name=Rifky+Ivanda+Hardiansyah&background=2B6E7E&color=fff&bold=true', false, '123456', true),
('u_2', 'Ektada Ageng B.M', 'billyminecraft776@gmail.com', 'Behind the scene', 'Anggota', 'Behind the scene Anggota di Zerava Production.', 'https://ui-avatars.com/api/?name=Ektada+Ageng+B.M&background=2B6E7E&color=fff&bold=true', false, '123456', true),
('u_3', 'Carissa Pabha Jivita', 'carissapj2009@gmail.com', 'Wardrobe', 'Anggota', 'Wardrobe Anggota di Zerava Production.', 'https://ui-avatars.com/api/?name=Carissa+Pabha+Jivita&background=2B6E7E&color=fff&bold=true', false, '123456', true),
('u_4', "Faiz Musyafa'", 'paizmsy@gmail.com', 'Sutradara', 'Anggota', 'Sutradara Anggota di Zerava Production.', 'https://ui-avatars.com/api/?name=Faiz+Musyafa&background=2B6E7E&color=fff&bold=true', false, '123456', false),
('u_5', 'Dherick Radhitya Irawan', 'dherickradhit95@gmail.com', 'Artistik', 'Anggota', 'Artistik Anggota di Zerava Production.', 'https://ui-avatars.com/api/?name=Dherick+Radhitya+Irawan&background=2B6E7E&color=fff&bold=true', false, '123456', true),
('u_6', 'Rasya Nur Pahlevy', 'rnurpahlevy@gmail.com', 'Aktor', 'Anggota', 'Aktor Anggota di Zerava Production.', 'https://ui-avatars.com/api/?name=Rasya+Nur+Pahlevy&background=2B6E7E&color=fff&bold=true', false, '123456', true),
('u_7', 'Angelina Rahma Firauzza', 'firauzzaangelin@gmail.com', 'Editor', 'Anggota', 'Editor Anggota di Zerava Production.', 'https://ui-avatars.com/api/?name=Angelina+Rahma+Firauzza&background=2B6E7E&color=fff&bold=true', false, '123456', true),
('u_8', 'Hafidza Arafah', 'bbze777@gmail.com', 'Sutradara', 'Anggota', 'Sutradara Anggota di Zerava Production.', 'https://ui-avatars.com/api/?name=Hafidza+Arafah&background=2B6E7E&color=fff&bold=true', false, '123456', true),
('u_9', 'Aning Tiyas Triasih', 'aning6651@gmail.com', 'Editor', 'Anggota', 'Editor Anggota di Zerava Production.', 'https://ui-avatars.com/api/?name=Aning+Tiyas+Triasih&background=2B6E7E&color=fff&bold=true', false, '123456', true),
('u_10', 'Hersita Azmi Candrawati', 'hersitaazmi@gmail.com', 'Artistik', 'Anggota', 'Artistik Anggota di Zerava Production.', 'https://ui-avatars.com/api/?name=Hersita+Azmi+Candrawati&background=2B6E7E&color=fff&bold=true', false, '123456', true),
('u_11', 'Fetika Rahmawati', 'fetikara269@gmail.com', 'Wardrobe', 'Anggota', 'Wardrobe Anggota di Zerava Production.', 'https://ui-avatars.com/api/?name=Fetika+Rahmawati&background=2B6E7E&color=fff&bold=true', false, '123456', true),
('u_12', 'Keiko Marco Valentino Sorongan', 'keikomarco1819@gmail.com', 'DOP', 'Anggota', 'DOP Anggota di Zerava Production.', 'https://ui-avatars.com/api/?name=Keiko+Marco+Valentino+Sorongan&background=2B6E7E&color=fff&bold=true', false, '123456', true),
('u_13', 'Zilfia Indi Mecca', 'indiindii636@gmail.com', 'Wardrobe', 'Anggota', 'Wardrobe Anggota di Zerava Production.', 'https://ui-avatars.com/api/?name=Zilfia+Indi+Mecca&background=2B6E7E&color=fff&bold=true', false, '123456', true),
('u_14', 'Trandwika Hestu Sundoro', 'hestutran@gmail.com', 'Sutradara', 'Anggota', 'Sutradara Anggota di Zerava Production.', 'https://ui-avatars.com/api/?name=Trandwika+Hestu+Sundoro&background=2B6E7E&color=fff&bold=true', false, '123456', true),
('u_15', 'Vico Evrat Anargya', 'vicoeanargya@gmail.com', 'Gaffer', 'Anggota', 'Gaffer Anggota di Zerava Production.', 'https://ui-avatars.com/api/?name=Vico+Evrat+Anargya&background=2B6E7E&color=fff&bold=true', false, '123456', true),
('u_16', 'Moza Zabdiel Ade Setiawan', 'mozazabdiel@gmail.com', 'Runner', 'Anggota', 'Runner Anggota di Zerava Production.', 'https://ui-avatars.com/api/?name=Moza+Zabdiel+Ade+Setiawan&background=2B6E7E&color=fff&bold=true', false, '123456', true),
('u_17', 'Sherene Nabil Aquila Ramadan', 'yala77206@gmail.com', 'Editor', 'Anggota', 'Editor Anggota di Zerava Production.', 'https://ui-avatars.com/api/?name=Sherene+Nabil+Aquila+Ramadan&background=2B6E7E&color=fff&bold=true', false, '123456', true),
('u_18', 'Ibrathaillah Abbad Annabhan', 'abad.anaban1@gmail.com', 'Runner', 'Anggota', 'Runner Anggota di Zerava Production.', 'https://ui-avatars.com/api/?name=Ibrathaillah+Abbad+Annabhan&background=2B6E7E&color=fff&bold=true', false, '123456', true),
('u_19', 'Afifah Larassati Rahmadani', 'applescat@gmail.com', 'Scriptwriter', 'Bendahara', 'Scriptwriter Bendahara di Zerava Production.', 'https://ui-avatars.com/api/?name=Afifah+Larassati+Rahmadani&background=2B6E7E&color=fff&bold=true', false, '123456', true),
('u_20', 'Syifa Nur Rahmah', 'syifaaiianurrahmah@gmail.com', 'Gaffer', 'Anggota', 'Gaffer Anggota di Zerava Production.', 'https://ui-avatars.com/api/?name=Syifa+Nur+Rahmah&background=2B6E7E&color=fff&bold=true', false, '123456', true),
('u_21', 'Nanda Afif Al Fathoni', 'afifgwantengfull@gmail.com', 'Kameramen', 'Anggota', 'Kameramen Anggota di Zerava Production.', 'https://ui-avatars.com/api/?name=Nanda+Afif+Al+Fathoni&background=2B6E7E&color=fff&bold=true', false, '123456', true),
('u_22', 'Ghaniyy Akbar Amandhio', 'ghaniyyakbarrramandhio@gmail.com', 'Kameramen', 'Ketua', 'Kameramen Ketua di Zerava Production.', 'https://ui-avatars.com/api/?name=Ghaniyy+Akbar+Amandhio&background=2B6E7E&color=fff&bold=true', true, '123456', true),
('u_23', 'Nur Asifah', 'nurhaifassifa099@gmail.com', 'Behind the scene', 'Anggota', 'Behind the scene Anggota di Zerava Production.', 'https://ui-avatars.com/api/?name=Nur+Asifah&background=2B6E7E&color=fff&bold=true', false, '123456', true),
('u_24', 'Bonia Prabandari', 'boniaaprbndri@gmail.com', 'Kameramen', 'Anggota', 'Kameramen Anggota di Zerava Production.', 'https://ui-avatars.com/api/?name=Bonia+Prabandari&background=2B6E7E&color=fff&bold=true', false, '123456', true),
('u_25', 'Cintasya Aulia Irfadillah', 'Cintasyaai@gmail.com', 'Kameramen', 'Anggota', 'Kameramen Anggota di Zerava Production.', 'https://ui-avatars.com/api/?name=Cintasya+Aulia+Irfadillah&background=2B6E7E&color=fff&bold=true', false, '123456', true),
('u_26', 'Deri Nugroho', 'derinugrohoo@gmail.com', 'Producer', 'Hiatus (kalo di call paiz balik)', 'Producer Hiatus (kalo di call paiz balik) di Zerava Production.', 'https://ui-avatars.com/api/?name=Deri+Nugroho&background=2B6E7E&color=fff&bold=true', false, '123456', true),
('u_27', 'Dwi Sebastian Saputra', 'martiantian510@gmail.com', 'Gaffer', 'Anggota', 'Gaffer Anggota di Zerava Production.', 'https://ui-avatars.com/api/?name=Dwi+Sebastian+Saputra&background=2B6E7E&color=fff&bold=true', false, '123456', true),
('u_28', 'Aqilla Amor Fadilla Wait', 'kilaace4hee@gmail.com', 'Scriptwriter', 'Bendahara', 'Scriptwriter Bendahara di Zerava Production.', 'https://ui-avatars.com/api/?name=Aqilla+Amor+Fadilla+Wait&background=2B6E7E&color=fff&bold=true', false, '123456', true),
('u_29', 'Alfira Nayla Putri', 'segitigasedotan@gmail.com', 'Kameramen', 'Anggota', 'Kameramen Anggota di Zerava Production.', 'https://ui-avatars.com/api/?name=Alfira+Nayla+Putri&background=2B6E7E&color=fff&bold=true', false, '123456', true),
('u_30', 'Abdullah Shindid Alfarras', 'alfarrasabdullah25@gmail.com', 'Runner', 'Anggota', 'Runner Anggota di Zerava Production.', 'https://ui-avatars.com/api/?name=Abdullah+Shindid+Alfarras&background=2B6E7E&color=fff&bold=true', false, '123456', true);

-- Seed groups
INSERT INTO zerava_groups (id, name, avatar) VALUES
('g_main', 'Zerava Production (All Crew)', 'https://images.unsplash.com/photo-1485846234645-a62644f84728?w=200&auto=format&fit=crop&q=80'),
('g_flsn', 'Tim Inti Produksi Film', 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=200&auto=format&fit=crop&q=80');

-- Seed group members
INSERT INTO zerava_group_members (group_id, user_id) 
SELECT 'g_main', id FROM zerava_users;

INSERT INTO zerava_group_members (group_id, user_id) VALUES
('g_flsn', 'u_0'), ('g_flsn', 'u_1'), ('g_flsn', 'u_4'), ('g_flsn', 'u_12'), ('g_flsn', 'u_22'), ('g_flsn', 'u_27');

-- Seed messages
INSERT INTO zerava_messages (id, room_id, sender_id, text, timestamp, reply_to) VALUES
('m1', 'g_main', 'u_22', 'Teman-teman besok kumpul produksi tepat waktu ya!', '09:15', NULL),
('m2', 'g_main', 'u_1', 'Siap, alat audio sudah aman semua.', '09:18', NULL),
('m3', 'g_main', 'u_27', 'Lighting & gaffer siap merapat!', '09:20', '{"senderId": "u_22", "text": "Teman-teman besok kumpul produksi tepat waktu ya!"}');

-- Seed class materials
INSERT INTO zerava_class_materials (id, title, description, thumbnail, file_name, file_size, url, uploader_id) VALUES
('cm_1', 'Camera Angle & Komposisi', 'Kamera angle adalah penempatan sudut kamera untuk menghasilkan psikologi dan karakter visual pada adegan film.', 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=600&auto=format&fit=crop&q=80', 'Modul Dasar Camera Angle.pdf', '256 KB', 'https://zerava.web.id', 'u_12');

-- Seed notifications
INSERT INTO zerava_notifications (id, type, title, body, time, page) VALUES
('n_1', 'chat', 'Pesan Grup: Zerava Production', 'Dwi Sebastian: Lighting & gaffer siap merapat!', '09:20', 'chat'),
('n_2', 'class', 'Materi Baru di Zerava Class', 'Keiko Marco menambahkan materi "Camera Angle & Komposisi"', '08:30', 'class');

-- ============================================
-- REALTIME SUBSCRIPTIONS (for chat sync)
-- ============================================
-- Enable realtime for messages table
ALTER PUBLICATION supabase_realtime ADD TABLE zerava_messages;
