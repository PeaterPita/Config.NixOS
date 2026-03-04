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
| **Atlas** | Main workhorse & Gaming | 🟢 Functional | Running an NVIDIA GPU | 
| **Icarus** | University laptop | 🟢 Functional | Semi-light weight |
| **Hermes** | Ingress node | 🟡 In-Progress |  Currently virtualized on the same hardware as **Olympus**, but i hope to transplant this over to an arm micro-computer at some point. |
| **Olympus** | Core homelab server | 🔴 WIP | Nonfunctional right now. This machine will run all my self hosting services |
| **Apollo** | *Arr Stack | ⚫ Planned | |


## References / Resources
- [NixOS Wiki](https://wiki.nixos.org/wiki/NixOS_Wiki)
- [NixOS manual](https://nixos.org/manual/nix/stable)
- [Home-manager docs](https://nix-community.github.io/home-manager/index.html#ch-nix-flakes)
- [NixVim docs](https://github.com/nix-community/nixvim
)

- [Misterio77 Config](https://github.com/Misterio77/nix-config)







