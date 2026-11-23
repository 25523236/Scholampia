CREATE DATABASE IF NOT EXISTS scholampia
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE scholampia;

-- ---------- 1. user ----------
-- role: 'user' | 'admin'
-- Status premium TIDAK disimpan di sini, tetapi dihitung dari transaksi_langganan.
CREATE TABLE IF NOT EXISTS `user` (
  id_user        INT AUTO_INCREMENT PRIMARY KEY,
  nama           VARCHAR(100) NOT NULL,
  email          VARCHAR(100) NOT NULL UNIQUE,
  password       VARCHAR(255) NOT NULL,
  role           VARCHAR(20)  NOT NULL,
  tanggal_daftar DATE         NOT NULL,
  CONSTRAINT chk_user_role CHECK (role IN ('user', 'admin'))
) ENGINE=InnoDB;

-- ---------- 2. paket_langganan ----------
CREATE TABLE IF NOT EXISTS paket_langganan (
  id_paket    INT AUTO_INCREMENT PRIMARY KEY,
  nama_paket  VARCHAR(50)   NOT NULL,
  durasi_hari INT           NOT NULL,
  harga       DECIMAL(10,2) NOT NULL,
  CONSTRAINT chk_paket_durasi CHECK (durasi_hari >= 0),
  CONSTRAINT chk_paket_harga  CHECK (harga >= 0)
) ENGINE=InnoDB;

-- ---------- 3. transaksi_langganan ----------
CREATE TABLE IF NOT EXISTS transaksi_langganan (
  id_transaksi      INT AUTO_INCREMENT PRIMARY KEY,
  id_user           INT           NOT NULL,
  id_paket          INT           NOT NULL,
  metode_pembayaran VARCHAR(30)   NOT NULL,
  jumlah_bayar      DECIMAL(10,2) NOT NULL,
  tanggal_transaksi DATETIME      NOT NULL,
  tanggal_berakhir  DATE          NULL,
  status_pembayaran VARCHAR(20)   NOT NULL,
  CONSTRAINT fk_transaksi_user  FOREIGN KEY (id_user)  REFERENCES `user`(id_user),
  CONSTRAINT fk_transaksi_paket FOREIGN KEY (id_paket) REFERENCES paket_langganan(id_paket),
  CONSTRAINT chk_transaksi_status CHECK (status_pembayaran IN ('menunggu', 'berhasil', 'kedaluwarsa', 'gagal'))
) ENGINE=InnoDB;

-- ---------- 4. penyelenggara ----------
-- Data lembaga/mentor diinput dan dikelola admin (tidak punya akun login)
CREATE TABLE IF NOT EXISTS penyelenggara (
  id_penyelenggara    INT AUTO_INCREMENT PRIMARY KEY,
  nama_penyelenggara  VARCHAR(150) NOT NULL,
  jenis_penyelenggara VARCHAR(30)  NOT NULL,
  email_resmi         VARCHAR(100) NOT NULL UNIQUE,
  kontak_resmi        VARCHAR(50)  NOT NULL,
  website_resmi       VARCHAR(255) NULL,
  foto_profil         VARCHAR(255) NULL,
  riwayat_pencapaian  TEXT         NULL,
  status_verifikasi   VARCHAR(20)  NOT NULL,
  CONSTRAINT chk_penyelenggara_jenis CHECK (jenis_penyelenggara IN ('lembaga_resmi', 'alumni_pemenang')),
  CONSTRAINT chk_penyelenggara_status CHECK (status_verifikasi IN ('menunggu', 'terverifikasi', 'ditolak'))
) ENGINE=InnoDB;

-- ---------- 5. program ----------
CREATE TABLE IF NOT EXISTS program (
  id_program           INT AUTO_INCREMENT PRIMARY KEY,
  id_penyelenggara     INT           NOT NULL,
  id_admin_verifikator INT           NULL,
  judul_program        VARCHAR(200)  NOT NULL,
  kategori             VARCHAR(20)   NOT NULL,
  lokasi               VARCHAR(100)  NOT NULL,
  biaya_pendaftaran    DECIMAL(10,2) NOT NULL,
  deskripsi            TEXT          NOT NULL,
  syarat_ketentuan     TEXT          NOT NULL,
  tanggal_mulai        DATE          NOT NULL,
  tanggal_tutup        DATE          NOT NULL,
  poster_url           VARCHAR(255)  NULL,
  status_verifikasi    VARCHAR(20)   NOT NULL,
  CONSTRAINT fk_program_penyelenggara FOREIGN KEY (id_penyelenggara)     REFERENCES penyelenggara(id_penyelenggara),
  CONSTRAINT fk_program_admin         FOREIGN KEY (id_admin_verifikator) REFERENCES `user`(id_user),
  CONSTRAINT chk_program_kategori CHECK (kategori IN ('beasiswa', 'lomba')),
  CONSTRAINT chk_program_biaya    CHECK (biaya_pendaftaran >= 0),
  CONSTRAINT chk_program_tanggal  CHECK (tanggal_tutup >= tanggal_mulai),
  CONSTRAINT chk_program_status   CHECK (status_verifikasi IN ('menunggu', 'terverifikasi', 'ditolak'))
) ENGINE=InnoDB;

-- ---------- 6. jenjang ----------
-- Isi contoh: SD, SMP, SMA, D2, D3, S1, S2, Fresh-Graduate
CREATE TABLE IF NOT EXISTS jenjang (
  id_jenjang   INT AUTO_INCREMENT PRIMARY KEY,
  nama_jenjang VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- ---------- 7. program_jenjang (tabel jembatan M:N) ----------
CREATE TABLE IF NOT EXISTS program_jenjang (
  id_program INT NOT NULL,
  id_jenjang INT NOT NULL,
  PRIMARY KEY (id_program, id_jenjang),
  CONSTRAINT fk_pj_program FOREIGN KEY (id_program) REFERENCES program(id_program) ON DELETE CASCADE,
  CONSTRAINT fk_pj_jenjang FOREIGN KEY (id_jenjang) REFERENCES jenjang(id_jenjang)
) ENGINE=InnoDB;

-- ---------- 8. artikel_edukasi ----------
CREATE TABLE IF NOT EXISTS artikel_edukasi (
  id_artikel          INT AUTO_INCREMENT PRIMARY KEY,
  id_admin            INT          NOT NULL,
  judul_artikel       VARCHAR(200) NOT NULL,
  kategori_edukasi    VARCHAR(50)  NOT NULL,
  isi_konten          TEXT         NOT NULL,
  gambar_perbandingan VARCHAR(255) NULL,
  tanggal_publikasi   DATE         NOT NULL,
  CONSTRAINT fk_artikel_admin FOREIGN KEY (id_admin) REFERENCES `user`(id_user)
) ENGINE=InnoDB;

-- ---------- 9. analisis_risiko ----------
CREATE TABLE IF NOT EXISTS analisis_risiko (
  id_analisis         INT AUTO_INCREMENT PRIMARY KEY,
  id_user             INT          NOT NULL,
  tautan_diperiksa    VARCHAR(255) NULL,
  poster_diperiksa    VARCHAR(255) NULL,
  teks_pengumuman     TEXT         NULL,
  skor_risiko         INT          NOT NULL,
  kategori_risiko     VARCHAR(30)  NOT NULL,
  ringkasan_indikator TEXT         NOT NULL,
  tanggal_analisis    DATETIME     NOT NULL,
  CONSTRAINT fk_analisis_user FOREIGN KEY (id_user) REFERENCES `user`(id_user),
  CONSTRAINT chk_analisis_skor CHECK (skor_risiko BETWEEN 0 AND 100),
  CONSTRAINT chk_analisis_kategori CHECK (kategori_risiko IN ('rendah', 'sedang', 'tinggi')),
  CONSTRAINT chk_analisis_input CHECK (
    tautan_diperiksa IS NOT NULL OR poster_diperiksa IS NOT NULL OR teks_pengumuman IS NOT NULL
  )
) ENGINE=InnoDB;

-- ---------- 10. sesi_mentoring ----------
CREATE TABLE IF NOT EXISTS sesi_mentoring (
  id_mentoring     INT AUTO_INCREMENT PRIMARY KEY,
  id_user          INT          NOT NULL,
  id_penyelenggara INT          NOT NULL,
  topik_mentoring  VARCHAR(150) NOT NULL,
  jadwal_sesi      DATETIME     NOT NULL,
  tautan_meeting   VARCHAR(255) NULL,
  status_sesi      VARCHAR(20)  NOT NULL,
  CONSTRAINT fk_sesi_user          FOREIGN KEY (id_user)          REFERENCES `user`(id_user),
  CONSTRAINT fk_sesi_penyelenggara FOREIGN KEY (id_penyelenggara) REFERENCES penyelenggara(id_penyelenggara)
) ENGINE=InnoDB;
