<div align="center">
    <h1> Personal NixOS System Configurations</h1>
    <p>Atlas, Icarus, Olympus, Hermes</p>
</div>

<p align="center">
    <img src="https://builtwithnix.org/badge.svg" alt="Built with nix">
    <img src="https://img.shields.io/badge/NixOS-26.05-blue?style=for-the-badge&logo=nixos&logoColor=white" alt="NixOS">
    <img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fwakapi.peaterpita.com%2Fapi%2Fcompat%2Fshields%2Fv1%2Fd467d029-0079-4dd8-8b00-46b340ebe1bf%2Finterval%3Aall_time%2Fproject%3Anixos&style=for-the-badge&label=Dev%20Time%20(Since%2028th%20May)&color=blueviolet" alt="Dev Time">
</p>

> [!IMPORTANT] 
> This is my **personal** flake-based, multi-machine configuration. It is not intended to be used or ran by anyone else but me, therefore I cannot promise these configurations will work for anyone else. 
> This repo should also not be used for inspiration for your own configs; I would still very much class myself as a novice. Many parts of this repo require significant refactorings and improvements. 

---


## Machines
| Hostname      | Role                      | Status         |  Notes                                                 | CI                      | 
| :---          | :---                      | :---           |  :---                                                  | :---:                  |
| **Atlas**     | Main workhorse & Gaming   | 🟢 Functional  |  Running an NVIDIA GPU                                 | ![build][atlas-badge]   | 
| **Icarus**    | Laptop                    | 🟢 Functional  |  Semi-light weight                                     | ![build][icarus-badge]  |
| &nbsp;        |                           |                |                                                        |                         |
| **Olympus**   | Core homelab server       | 🟡 In-Progress |  In testing! Dell r730 -> Acer Laptop during this time | ![build][olympus-badge] |
| **Hermes**    | Ingress node              | 🟡 In-Progress |  Virtualised on **Olympus** through microVM            | ![build][hermes-badge]  |   
| **Elysium**   | Off-Site Backup           | ⚫ Planned     |  Restic REST server                                    |                         |


## Homelab Services
| Service | Host | Status |
| :--- | :--- | :--- |
| **Traefik**             | Hermes    | 🟢 Functional  |
| **AdGuard**             | Hermes    | 🟢 Functional  |
| **Crowdsec**            | Hermes    | ⚫ Planned     |
| &nbsp;                  |           |                |
| **Homepage**            | Olympus   | 🟡 In-Progress |
| **Ntfy**                | Olympus   | ⚫ Planned     |
| **LLDAP**               | Olympus   | 🟢 Functional  |
| **Umami**               | Olympus   | 🔴 Disabled    |
| **Immich**              | Olympus   | 🟢 Functional  |
| **Mealie**              | Olympus   | 🟢 Functional  |
| **Restic**              | Olympus   | 🟢 Functional  |
| **Wakapi**              | Olympus   | 🟢 Functional  |
| **Grafana**             | Olympus   | 🟡 In-Progress |
| **Authelia**            | Olympus   | 🟡 In-Progress |
| **Harmonia**            | Olympus   | 🟢 Functional  |
| **Jellyfin**            | Olympus   | 🟢 Functional  |
| **Navidrome**           | Olympus   | 🟢 Functional  |
| **Tailscale**           | Olympus   | 🟢 Functional  |
| **Woodpecker CI**       | Olympus   | 🟢 Functional  |
| **Home Assistant**      | Olympus   | 🟡 In-Progress |
| **Personal Sites**      | Olympus   | 🟡 In-Progress |
| **Speedtest Tracker**   | Olympus   | 🟢 Functional  |
| **Filebrowser-quantum** | Olympus   | 🟢 Functional  |


## References / Resources
- [NixOS Wiki](https://wiki.nixos.org/wiki/NixOS_Wiki)
- [NixOS manual](https://nixos.org/manual/nix/stable)
- [Home-manager docs](https://nix-community.github.io/home-manager/index.html#ch-nix-flakes)
- [NixVim docs](https://github.com/nix-community/nixvim)


- [Misterio77 Config](https://github.com/Misterio77/nix-config)
- [Notthebe Config](https://git.notthebe.ee/notthebee/nix-config)

All logos and images are credited: [Credits](assets/credits.md)

[olympus-badge]: https://ci.peaterpita.com/api/badges/PeaterPita/Config.NixOS/status.svg?workflow=Olympus
[hermes-badge]: https://ci.peaterpita.com/api/badges/PeaterPita/Config.NixOS/status.svg?workflow=Hermes
[atlas-badge]: https://ci.peaterpita.com/api/badges/PeaterPita/Config.NixOS/status.svg?workflow=Atlas
[icarus-badge]: https://ci.peaterpita.com/api/badges/PeaterPita/Config.NixOS/status.svg?workflow=Icarus
