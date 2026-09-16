# AmarOS Desktop 0.1 — prototipe ARM64

Distribusi desktop berbasis Fedora 44, GNOME, dengan target minimum RAM 4 GB
dan penyimpanan 40 GB. Target awal adalah mesin ARM64/aarch64 dengan UEFI
standar dan perangkat virtual QEMU `virt`.

Status: konfigurasi dan alat build awal. Belum ada ISO yang dibangun atau
perangkat yang dinyatakan lulus pengujian. Hasil build adalah **installer
jaringan**, bukan live desktop atau installer offline. Internet diperlukan
untuk mengunduh paket saat instalasi.

## Isi proyek

- `kickstarts/amaros.ks`: pilihan desktop dan konfigurasi instalasi.
- `overlay/`: wallpaper SVG dan pengaturan GNOME.
- `scripts/render-kickstart.py`: menyatukan overlay ke Kickstart mandiri.
- `scripts/build-iso.sh`: menyisipkan konfigurasi ke ISO netinstall Fedora.
- `docs/testing.md`: prosedur uji dan matriks perangkat.

## Persiapan build

Gunakan Fedora 44 aarch64. Sediakan setidaknya 15 GB ruang kerja kosong untuk
ISO sumber, hasil build, dan berkas sementara; sediakan ruang tambahan untuk
disk VM. RAM VM ditetapkan 4096 MiB. Jangan menjalankan VM sebesar itu jika
RAM bebas host tidak mencukupi.

```bash
sudo dnf install lorax pykickstart xorriso isomd5sum
```

Unduh **Fedora Everything 44 aarch64 netinstall ISO** beserta CHECKSUM dari
https://fedoraproject.org/everything/download/ . Verifikasi tanda tangan
CHECKSUM menggunakan kunci Fedora yang sidik jarinya telah dicocokkan dengan
https://fedoraproject.org/security/ , lalu verifikasi SHA-256 ISO. Jangan gunakan
Workstation Live ISO: Kickstart ini memakai instalasi paket dari repositori.

## Validasi dan build

Jalankan dari direktori proyek:

```bash
python3 scripts/render-kickstart.py
ksvalidator -v F44 build/amaros.ks
bash scripts/build-iso.sh /path/Fedora-Everything-netinst-aarch64-44-RELEASE.iso
```

Skrip build memeriksa arsitektur, nama media, dependensi, ruang kosong, dan
validitas Kickstart sebelum meminta sudo untuk `mkksiso`. ISO sumber harus
sudah diverifikasi. Berkas hasil: `build/AmarOS-0.1-Fedora44-aarch64-netinst.iso`
dan SHA-256 terkait. Tidak ada unduhan atau instalasi paket host otomatis.

Saat installer berjalan, pilih disk dan skema partisi, buat akun administrator,
lalu tinjau konfigurasi sebelum memulai instalasi. Root dikunci; tidak ada
kata sandi bawaan atau login otomatis. Jangan menguji pada disk berisi data.

## Identitas dan pembaruan

Sistem terpasang menampilkan AmarOS melalui salinan `/etc/os-release`.
`VERSION_ID=44` dipertahankan untuk kompatibilitas repositori Fedora;
`AMAROS_VERSION_ID=0.1` adalah versi proyek. Paket dan pembaruan tetap berasal
dari Fedora. Wallpaper dan default GNOME berasal dari proyek ini; pilihan
pengguna dapat menggantikannya.

Branding masih prototipe: installer dan sebagian aset paket tetap memakai
identitas upstream. Sebelum rilis publik, identitas dan aset perlu dikemas
dalam RPM, perilaku upgrade diuji, dan branding distribusi diselesaikan.
Ini bukan produk resmi Fedora atau Red Hat.

Apple Silicon/Asahi, Raspberry Pi, serta laptop Snapdragon belum didukung
oleh profil ini. Masing-masing membutuhkan pemeriksaan kernel, firmware,
bootloader, dan driver sesuai model. Arsitektur ARM64 saja bukan jaminan
kompatibilitas. Lihat [rencana pengujian](docs/testing.md).

## Rujukan

- https://weldr.io/lorax/mkksiso.html
- https://pykickstart.readthedocs.io/en/latest/kickstart-docs.html
- https://fedoraproject.org/wiki/Architectures/ARM/Installation
- https://fedoraproject.org/wiki/Legal/Secondary_trademark_usage_guidelines
