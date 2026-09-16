# Pengujian AmarOS 0.1

Semua pengujian boot dan instalasi di bawah masih **belum dijalankan**.
Validasi sintaks tidak menjamin repositori, paket, driver, atau boot berfungsi.

## VM pertama

Gunakan virt-manager/QEMU pada host yang memiliki cukup RAM dan disk:

- Arsitektur aarch64, machine `virt`, firmware UEFI AAVMF/EDK2.
- 2 vCPU, 4096 MiB RAM, disk virtual baru 40 GiB.
- Virtio untuk disk dan jaringan; gunakan grafis virtio yang didukung host.
- Pasang ISO AmarOS sebagai media boot; gunakan jaringan NAT.
- Jangan meneruskan disk fisik host ke VM.

Pada host Fedora, paket alat VM dapat dipasang dengan:

```bash
sudo dnf install virt-manager qemu-system-aarch64-core edk2-aarch64
```

Periksa hal berikut secara berurutan:

1. Boot UEFI mencapai installer tanpa error.
2. Installer menunggu pilihan penyimpanan; tidak menghapus disk otomatis.
3. Buat pengguna anggota administrator; root tidak memiliki password bawaan.
4. Repositori Fedora 44 dapat dijangkau, resolusi paket dan instalasi selesai.
5. Lepas ISO; sistem boot dari disk, GDM muncul, login GNOME berhasil.
6. `cat /etc/os-release` menampilkan AmarOS dan `VERSION_ID=44`.
7. Wallpaper AmarOS terlihat; Settings tetap dapat mengganti wallpaper.
8. `getenforce` menghasilkan Enforcing, `systemctl is-active firewalld`
   menghasilkan active, dan `swapon --show` menampilkan zram.
9. `sudo dnf upgrade --refresh` berhasil; reboot, periksa identitas dan login.
10. Dengan RAM 4 GB, buka Files, Settings, dan Firefox dengan beberapa tab.
    Catat `free -h`, respons desktop, dan kejadian OOM; jangan mengklaim
    minimum RAM tercapai sebelum hasilnya dicatat.

Jika instalasi gagal, simpan log Anaconda dan `/root/amaros-post.log`
dari sistem target sebelum menghapus VM.

## Matriks dukungan

| Target | Status | Pengujian tambahan |
|---|---|---|
| QEMU ARM64 UEFI | Belum diuji | Instalasi, reboot, GNOME, pembaruan |
| Desktop ARM64 UEFI | Kandidat | Model, GPU, Wi-Fi, audio, suspend, USB |
| Laptop Snapdragon | Belum didukung | Kernel/firmware dan driver per model |
| Raspberry Pi | Belum didukung | Boot firmware, kernel, GPU per model |
| Apple Silicon | Profil terpisah diperlukan | Integrasi Asahi dan installer khusus |

Catat model, versi firmware, hash ISO, tanggal, log, dan hasil setiap uji.
Kelulusan di VM tidak membuktikan kompatibilitas perangkat fisik.
