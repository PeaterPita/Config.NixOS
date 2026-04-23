# Personal NixOS System Configuration

[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)
[![NixOS](https://img.shields.io/badge/NixOS-25.11-blue?style=flat&logo=nixos&logoColor=white)](https://nixos.org)

## Foreword
This is my **personal** flake-based, multi-machine configuration. It is not intended to be used or ran by anyone else but me, therefore I cannot promise these configurations will work for anyone else. 
This repo should also not be used for inspiration for your own configs; I would still very much class myself as a novice. Many parts of this repo require significant refactorings and improvements. 

---

## Machines

| Hostname | Role | Status | Notes |
| :--- | :--- | :--- | :--- |
| **Atlas**     | Main workhorse & Gaming   | 🟢 Functional | Running an NVIDIA GPU | 
| **Icarus**    | University laptop         | 🟢 Functional | Semi-light weight     |
| &nbsp;        |                           |               | |
| **Olympus**   | Core homelab server       | 🔴 WIP        | In testing! Dell r730 -> Acer Laptop during this time |
| **Hermes**    | Ingress node              | 🟡 In-Progress| Virtualised on **Olympus** through microVM |
| **Apollo**    | *Arr Stack                | ⚫ Planned    | |


## Homelab Services

| Service | Host | Status |
| :--- | :--- | :--- |
| **Traefik**           | Hermes    | 🟢 Functional |
| **AdGuard**           | Hermes    | 🟢 Functional |
| **Fail2Ban**          | Hermes    | ⚫ Planned    |
| &nbsp;                |           |               |
| **Homepage**          | Olympus   | 🟡 In-Progress|
| **LLDAP**             | Olympus   | 🟢 Functional |
| **Umami**             | Olympus   | ⚫ Planned    |
| **Kavita**            | Olympus   | 🟢 Functional |
| **Mealie**            | Olympus   | 🟢 Functional |
| **Immich**            | Olympus   | ⚫ Planned    |
| **Grafana**           | Olympus   | ⚫ Planned    |
| **Authelia**          | Olympus   | 🟢 Functional |
| **Jellyfin**          | Olympus   | 🔴 redundant  |
| **Nextcloud**         | Olympus   | ⚫ Planned    |
| **Navidrome**         | Olympus   | 🟢 Functional |
| **Openreads**         | Olympus   | ⚫ Planned    |
| **Tailscale**         | Olympus   | 🟢 Functional |
| **Drafft-ink**        | Olympus   | ⚫ Planned    |
| **Prometheus**        | Olympus   | ⚫ Planned    |
| **Vaultwarden**       | Olympus   | ⚫ Planned    |
| **Uptime Kuma**       | Olympus   | ⚫ Planned    |
| **Paperless-ngx**     | Olympus   | ⚫ Planned    |
| **Personal Sites**    | Olympus   | 🔴 WIP        |
| **Speedtest Tracker** | Olympus   | 🟢 Functional |
| &nbsp;                |           |               |
| **Arr Stack**         | Apollo    | ⚫ Planned    |




## Setup
As much as I disdain imperative configuration; some processes cannot be declared as of right right. Hopefully as time goes on this section will get shorter and shorter.


<details>
<summary>Common</summary>

Github SSH keys: [docs.github.com](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)


</details>

<details>
<summary>Olympus</summary>

+ ??
+ Manual OIDC secret generation



### OIDC Client Secrets
- Generate random string
- `authelia crypto hash generate pbkdf2 --variant sha512`

+ ??




</details>


## References / Resources
- [NixOS Wiki](https://wiki.nixos.org/wiki/NixOS_Wiki)
- [NixOS manual](https://nixos.org/manual/nix/stable)
- [Home-manager docs](https://nix-community.github.io/home-manager/index.html#ch-nix-flakes)
- [NixVim docs](https://github.com/nix-community/nixvim
)

- [Misterio77 Config](https://github.com/Misterio77/nix-config)







