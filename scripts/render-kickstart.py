#!/usr/bin/env python3
"""Render installation-only customization; never modify the build host."""
import base64
from pathlib import Path
import shlex

ROOT = Path(__file__).resolve().parent.parent


def render():
    content = (ROOT / "kickstarts/amaros.ks").read_text()
    lines = [content.rstrip(), "", "%post --erroronfail --log=/root/amaros-post.log", "set -eu"]
    overlay = ROOT / "overlay"
    for source in sorted(overlay.rglob("*")):
        if not source.is_file():
            continue
        target = "/" + source.relative_to(overlay).as_posix()
        encoded = base64.b64encode(source.read_bytes()).decode("ascii")
        lines.extend([
            f"install -d -m 0755 {shlex.quote(str(Path(target).parent))}",
            f"printf '%s' {shlex.quote(encoded)} | base64 --decode > {shlex.quote(target)}",
            f"chmod 0644 {shlex.quote(target)}",
        ])
    lines.extend([
        # Write a separate /etc file: /etc/os-release is usually a symlink.
        "cp /usr/lib/os-release /etc/amaros-os-release.tmp",
        "sed -i -e '/^NAME=/d' -e '/^PRETTY_NAME=/d' -e '/^ID=/d' -e '/^ID_LIKE=/d' /etc/amaros-os-release.tmp",
        "cat >> /etc/amaros-os-release.tmp <<'AMAROS_RELEASE'",
        'NAME="AmarOS"',
        'PRETTY_NAME="AmarOS 0.1 (Fedora 44)"',
        "ID=amaros",
        'ID_LIKE="fedora"',
        "AMAROS_VERSION_ID=0.1",
        "AMAROS_RELEASE",
        "mv -f /etc/amaros-os-release.tmp /etc/os-release",
        "glib-compile-schemas --strict /usr/share/glib-2.0/schemas",
        "restorecon -RF /etc/os-release /usr/share/backgrounds/amaros /usr/share/glib-2.0/schemas",
        "%end",
        "",
    ])
    return "\n".join(lines)


if __name__ == "__main__":
    output = ROOT / "build/amaros.ks"
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(render())
    print(output)
