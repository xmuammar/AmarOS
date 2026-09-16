# Hasil validasi awal — 16 September 2026

Lingkungan: Fedora Asahi Remix 44, aarch64.

Lulus:

- Render Kickstart dengan Python 3.14.
- `ksvalidator -v F44 build/amaros.ks`, pykickstart 3.78.
- Pemeriksaan sintaks Bash skrip build dan bagian `%post` hasil render.
- Parse XML wallpaper SVG.
- `glib-compile-schemas --strict --dry-run` untuk override AmarOS dengan
  skema background, screensaver, dan enum GNOME host.

Belum dijalankan:

- Pembuatan ISO (`lorax` belum terpasang).
- Resolusi paket Fedora saat instalasi.
- Boot, instalasi, akun pengguna, pembaruan, dan pengukuran RAM di VM.
- Semua pengujian perangkat fisik.

Ruang kosong `/home` ketika diperiksa sekitar 1,5 GB, sehingga build ISO dan
VM ditunda. Validasi di atas hanya memeriksa konfigurasi; belum merupakan
bukti bahwa AmarOS dapat diinstal atau berjalan.
