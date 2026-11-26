# Skema Relasional Basis Data - Scholampia

- **user**(<ins>id_user</ins>, nama, email, password, role, tanggal_daftar)
  FK: tidak ada

- **paket_langganan**(<ins>id_paket</ins>, nama_paket, durasi_hari, harga)
  FK: tidak ada

- **penyelenggara**(<ins>id_penyelenggara</ins>, nama_penyelenggara, jenis_penyelenggara, email_resmi, kontak_resmi, website_resmi, foto_profil, riwayat_pencapaian, status_verifikasi)
  FK: tidak ada

- **jenjang**(<ins>id_jenjang</ins>, nama_jenjang)
  FK: tidak ada

- **program**(<ins>id_program</ins>, *id_penyelenggara*, *id_admin_verifikator*, judul_program, kategori, lokasi, biaya_pendaftaran, deskripsi, syarat_ketentuan, tanggal_mulai, tanggal_tutup, poster_url, status_verifikasi)
  FK: `id_penyelenggara` → `penyelenggara(id_penyelenggara)`, `id_admin_verifikator` → `user(id_user)`

- **program_jenjang**(<ins>*id_program*</ins>, <ins>*id_jenjang*</ins>)
  FK: `id_program` → `program(id_program)`, `id_jenjang` → `jenjang(id_jenjang)`

- **artikel_edukasi**(<ins>id_artikel</ins>, *id_admin*, judul_artikel, kategori_edukasi, isi_konten, gambar_perbandingan, tanggal_publikasi)
  FK: `id_admin` → `user(id_user)`

- **analisis_risiko**(<ins>id_analisis</ins>, *id_user*, tautan_diperiksa, poster_diperiksa, teks_pengumuman, skor_risiko, kategori_risiko, ringkasan_indikator, tanggal_analisis)
  FK: `id_user` → `user(id_user)`

- **transaksi_langganan**(<ins>id_transaksi</ins>, *id_user*, *id_paket*, metode_pembayaran, jumlah_bayar, tanggal_transaksi, tanggal_berakhir, status_pembayaran)
  FK: `id_user` → `user(id_user)`, `id_paket` → `paket_langganan(id_paket)`

- **sesi_mentoring**(<ins>id_mentoring</ins>, *id_user*, *id_penyelenggara*, topik_mentoring, jadwal_sesi, tautan_meeting, status_sesi)
  FK: `id_user` → `user(id_user)`, `id_penyelenggara` → `penyelenggara(id_penyelenggara)`
