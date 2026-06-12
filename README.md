# Personal NixOS System Configuration

[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)
[![NixOS](https://img.shields.io/badge/NixOS-26.05-blue?style=flat&logo=nixos&logoColor=white)](https://nixos.org)

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
| **Olympus**   | Core homelab server       | 🟡 In-Progress| In testing! Dell r730 -> Acer Laptop during this time |
| **Hermes**    | Ingress node              | 🟡 In-Progress| Virtualised on **Olympus** through microVM |


## Homelab Services

| Service | Host | Status |
| :--- | :--- | :--- |
| **Traefik**             | Hermes    | 🟢 Functional  |
| **AdGuard**             | Hermes    | 🟢 Functional  |
| **Crowdsec**            | Hermes    | ⚫ Planned     |
| &nbsp;                  |           |                |
| **Homepage**            | Olympus   | 🟡 In-Progress |
| **Loki**                | Olympus   | 🟡 In-Progress |
| **Ntfy**                | Olympus   | ⚫ Planned     |
| **Alloy**               | Olympus   | 🟡 In-Progress |
| **LLDAP**               | Olympus   | 🟢 Functional  |
| **Umami**               | Olympus   | 🟢 Functional  |
| **Immich**              | Olympus   | 🟢 Functional  |
| **Kavita**              | Olympus   | 🟢 Functional  |
| **Mealie**              | Olympus   | 🟢 Functional  |
| **Restic**              | Olympus   | ⚫ Planned     |
| **Wakapi**              | Olympus   | 🟢 Functional  |
| **Grafana**             | Olympus   | 🟡 In-Progress |
| **Authelia**            | Olympus   | 🟡 In-Progress |
| **Jellyfin**            | Olympus   | 🟢 Functional  |
| **Leantime**              | Olympus   | ⚫ Planned     |
| **Navidrome**           | Olympus   | 🟢 Functional  |
| **Tailscale**           | Olympus   | 🔴 Broken      |
| **Jellyseerr**          | Olympus   | 🟢 Functional  |
| **Prometheus**          | Olympus   | 🟡 In-Progress |
| **Adventure Log**       | Olympus   | ⚫ Planned     |
| **Paperless-ngx**       | Olympus   | 🟢 Functional  |
| **Woodpecker CI**       | Olympus   | 🟢 Functional  |
| **Personal Sites**      | Olympus   | 🔴 WIP         |
| **Speedtest Tracker**   | Olympus   | 🟢 Functional  |
| **Filebrowser-quantum** | Olympus   | 🟢 Functional  |




## Setup
As much as I disdain imperative configuration; some processes cannot be declared as of right right. Hopefully as time goes on this section will get shorter. 
This section also is just servicing as a running checklist and reminder to myself.


<details>
<summary>Common</summary>

Github SSH keys: [docs.github.com](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)


Sops keys: 
`sudo age-keygen -o ~/.config/sops/age/keys.txt`


### Wakatime
`~/.wakatime.cfg` needs to be imperatively edited to point to my self hosted wakapi instance.


</details>

<details>
<summary>Olympus</summary>


### Account Creations
- [ ] Authelia LLDAP Service Account 
        password from sops `ldap_password`
        under group `lldap_password_manager`

- [ ] User LLDAP Account creation
- [ ] Navidrome Admin Account Creation
    Required direct `IP:PORT` access


### Credential Changes
- [ ] Umami - https://docs.umami.is/docs/login
- [ ] SpeedtestTracker - https://docs.speedtest-tracker.dev/security/authentication


### Jellyfin
- Jellyfin LDAP Plugin Setup
    LDAP Server: `127.0.0.1`
    LDAP Port: `3890`

    Secure LDAP: `false`

    LDAP Bind User: `uid=jellyfin,ou=people,dc=..`
    LDAP Base DN for Searches: `ou=people,dc=..`
    LDAP Search Filter: `(|(memberOf=cn=media,ou=groups,dc=..)(memberOf=cn=admin,ou=groups,dc=..))`
    LDAP Search Attributes: `uid,cn,mail`

    LDAP Admin Filter: `(memberOf=CN=admin,ou=groups,dc=peaterpita,dc=com)`


- Jellyfin Prometheus Bridge
    jellyfin API key created and stored in sops
    Networking > Known proxies, add the ingress IP

- Jellyseerr Setup

### Misc
- Paperless Default Group
    name: `default`

    Document: `All`
    Tag: `All`
    Correspondent: `All`
    DocumentType: `All`
    StoragePath: `View`
    SavedView: `All`
    PaperlessTask: `All`
    UISettings: `All`
    Note: `All`

- SAMBA account
    `sudo smbpasswd -a <account name>`

</details>

## TODO
- [ ] Mouse Button Side Buttons (Logitech G502)
- [ ] ffmpeg ++ camera tool  (DSLR)
- [ ] Olympus SMTP setup (authelia TOTP registration)


## References / Resources
- [NixOS Wiki](https://wiki.nixos.org/wiki/NixOS_Wiki)
- [NixOS manual](https://nixos.org/manual/nix/stable)
- [Home-manager docs](https://nix-community.github.io/home-manager/index.html#ch-nix-flakes)
- [NixVim docs](https://github.com/nix-community/nixvim
)
- [Misterio77 Config](https://github.com/Misterio77/nix-config)
- [Notthebe Config](https://git.notthebe.ee/notthebee/nix-config)
