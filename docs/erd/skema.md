# Skema Relasional Basis Data - Scholampia

* **user**(<u>id_user</u>, nama, email, password, role, tanggal_daftar)  
  FK: tidak ada

* **paket_langganan**(<u>id_paket</u>, nama_paket, durasi_hari, harga)  
  FK: tidak ada

* **penyelenggara**(<u>id_penyelenggara</u>, nama_penyelenggara, jenis_penyelenggara, email_resmi, kontak_resmi, website_resmi, foto_profil, riwayat_pencapaian, status_verifikasi)  
  FK: tidak ada

* **jenjang**(<u>id_jenjang</u>, nama_jenjang)  
  FK: tidak ada

* **program**(<u>id_program</u>, *id_penyelenggara*, *id_admin_verifikator*, judul_program, kategori, lokasi, biaya_pendaftaran, deskripsi, syarat_ketentuan, tanggal_mulai, tanggal_tutup, poster_url, status_verifikasi)  
  FK: `id_penyelenggara` → `penyelenggara(id_penyelenggara)`, `id_admin_verifikator` → `user(id_user)`

* **program_jenjang**(<u>*id_program*</u>, <u>*id_jenjang*</u>)  
  FK: `id_program` → `program(id_program)`, `id_jenjang` → `jenjang(id_jenjang)`

* **artikel_edukasi**(<u>id_artikel</u>, *id_admin*, judul_artikel, kategori_edukasi, isi_konten, gambar_perbandingan, tanggal_publikasi)  
  FK: `id_admin` → `user(id_user)`

* **analisis_risiko**(<u>id_analisis</u>, *id_user*, tautan_diperiksa, poster_diperiksa, teks_pengumuman, skor_risiko, kategori_risiko, ringkasan_indikator, tanggal_analisis)  
  FK: `id_user` → `user(id_user)`

* **transaksi_langganan**(<u>id_transaksi</u>, *id_user*, *id_paket*, metode_pembayaran, jumlah_bayar, tanggal_transaksi, tanggal_berakhir, status_pembayaran)  
  FK: `id_user` → `user(id_user)`, `id_paket` → `paket_langganan(id_paket)`

* **sesi_mentoring**(<u>id_mentoring</u>, *id_user*, *id_penyelenggara*, topik_mentoring, jadwal_sesi, tautan_meeting, status_sesi)  
  FK: `id_user` → `user(id_user)`, `id_penyelenggara` → `penyelenggara(id_penyelenggara)`
