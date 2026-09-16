#!/usr/bin/env bash
set -euo pipefail
project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
fail() { printf 'Error: %s\n' "$*" >&2; exit 1; }
[[ $# -eq 1 ]] || fail "Usage: bash scripts/build-iso.sh FEDORA44_AARCH64_NETINSTALL.iso"
[[ $(uname -m) == aarch64 ]] || fail 'Build memerlukan host aarch64.'
for dependency in python3 ksvalidator mkksiso xorriso sha256sum realpath df awk; do
    command -v "$dependency" >/dev/null || fail "Dependensi belum tersedia: $dependency"
done
source_iso="$(realpath -- "$1")"
[[ -f "$source_iso" ]] || fail 'ISO sumber tidak ditemukan.'
case "$(basename -- "$source_iso")" in
    Fedora-Everything-netinst-aarch64-44-*.iso) ;;
    *) fail 'Gunakan Fedora Everything 44 aarch64 netinstall ISO yang sudah diverifikasi.' ;;
esac
output_iso="$project_dir/build/AmarOS-0.1-Fedora44-aarch64-netinst.iso"
[[ ! -e "$output_iso" ]] || fail "Hasil sudah ada: $output_iso"
free_kib="$(df -Pk "$project_dir" | awk 'END {print $4}')"
(( free_kib >= 15 * 1024 * 1024 )) || fail 'Sediakan minimal 15 GiB ruang kerja kosong.'
python3 "$project_dir/scripts/render-kickstart.py"
ksvalidator -v F44 "$project_dir/build/amaros.ks"
printf 'Membuat installer jaringan AmarOS; sumber: %s\n' "$source_iso"
if (( EUID == 0 )); then
    mkksiso --ks "$project_dir/build/amaros.ks" --volid AMAROS_0_1_AARCH64 "$source_iso" "$output_iso"
else
    sudo mkksiso --ks "$project_dir/build/amaros.ks" --volid AMAROS_0_1_AARCH64 "$source_iso" "$output_iso"
fi
sha256sum "$output_iso" > "$output_iso.sha256"
printf 'ISO selesai: %s\n' "$output_iso"
