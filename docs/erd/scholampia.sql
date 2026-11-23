CREATE DATABASE IF NOT EXISTS scholampia;
USE scholampia;

CREATE TABLE user (
  id_user INT AUTO_INCREMENT PRIMARY KEY,
  nama VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  role VARCHAR(20) NOT NULL,
  tanggal_daftar DATE NOT NULL
);

CREATE TABLE paket_langganan (
  id_paket INT AUTO_INCREMENT PRIMARY KEY,
  nama_paket VARCHAR(50) NOT NULL,
  durasi_hari INT NOT NULL,
  harga DECIMAL(10,2) NOT NULL
);

CREATE TABLE transaksi_langganan (
  id_transaksi INT AUTO_INCREMENT PRIMARY KEY,
  id_user INT NOT NULL,
  id_paket INT NOT NULL,
  metode_pembayaran VARCHAR(30) NOT NULL,
  tanggal_transaksi DATETIME NOT NULL,
  tanggal_berakhir DATE NULL,
  status_pembayaran VARCHAR(20) NOT NULL,
  FOREIGN KEY (id_user) REFERENCES user(id_user),
  FOREIGN KEY (id_paket) REFERENCES paket_langganan(id_paket)
);

CREATE TABLE penyelenggara (
  id_penyelenggara INT AUTO_INCREMENT PRIMARY KEY,
  nama_penyelenggara VARCHAR(150) NOT NULL,
  jenis_penyelenggara VARCHAR(30) NOT NULL,
  email_resmi VARCHAR(100) NOT NULL UNIQUE,
  kontak_resmi VARCHAR(50) NOT NULL,
  website_resmi VARCHAR(255) NULL,
  riwayat_pencapaian TEXT NULL,
  status_verifikasi VARCHAR(20) NOT NULL
);

CREATE TABLE program (
  id_program INT AUTO_INCREMENT PRIMARY KEY,
  id_penyelenggara INT NOT NULL,
  id_admin_verifikator INT NULL,
  judul_program VARCHAR(200) NOT NULL,
  kategori VARCHAR(20) NOT NULL,
  jenjang VARCHAR(50) NOT NULL,
  lokasi VARCHAR(100) NOT NULL,
  biaya_pendaftaran DECIMAL(10,2) NOT NULL,
  deskripsi TEXT NOT NULL,
  syarat_ketentuan TEXT NOT NULL,
  tanggal_mulai DATE NOT NULL,
  tanggal_tutup DATE NOT NULL,
  poster_url VARCHAR(255) NULL,
  status_verifikasi VARCHAR(20) NOT NULL,
  FOREIGN KEY (id_penyelenggara) REFERENCES penyelenggara(id_penyelenggara),
  FOREIGN KEY (id_admin_verifikator) REFERENCES user(id_user)
);

CREATE TABLE artikel_edukasi (
  id_artikel INT AUTO_INCREMENT PRIMARY KEY,
  id_admin INT NOT NULL,
  judul_artikel VARCHAR(200) NOT NULL,
  kategori_edukasi VARCHAR(50) NOT NULL,
  isi_konten TEXT NOT NULL,
  gambar_perbandingan VARCHAR(255) NULL,
  tanggal_publikasi DATE NOT NULL,
  FOREIGN KEY (id_admin) REFERENCES user(id_user)
);

CREATE TABLE analisis_risiko (
  id_analisis INT AUTO_INCREMENT PRIMARY KEY,
  id_user INT NOT NULL,
  tautan_diperiksa VARCHAR(255) NULL,
  poster_diperiksa VARCHAR(255) NULL,
  teks_pengumuman TEXT NULL,
  skor_risiko INT NOT NULL,
  kategori_risiko VARCHAR(30) NOT NULL,
  ringkasan_indikator TEXT NOT NULL,
  tanggal_analisis DATETIME NOT NULL,
  FOREIGN KEY (id_user) REFERENCES user(id_user)
);

CREATE TABLE sesi_mentoring (
  id_mentoring INT AUTO_INCREMENT PRIMARY KEY,
  id_user INT NOT NULL,
  id_penyelenggara INT NOT NULL,
  topik_mentoring VARCHAR(150) NOT NULL,
  jadwal_sesi DATETIME NOT NULL,
  tautan_meeting VARCHAR(255) NULL,
  status_sesi VARCHAR(20) NOT NULL,
  FOREIGN KEY (id_user) REFERENCES user(id_user),
  FOREIGN KEY (id_penyelenggara) REFERENCES penyelenggara(id_penyelenggara)
);
