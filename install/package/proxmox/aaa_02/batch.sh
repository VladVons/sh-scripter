apt install --yes --no-install-recommends $(grep -vE '^\s*#|^\s*$' proxmox.apt)

