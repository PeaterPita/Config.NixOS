# Setup
As much as I disdain imperative configuration; some processes cannot be declared as of right right. Hopefully as time goes on this section will get shorter. 
This section also is just servicing as a running checklist and reminder to myself.


## Common
Github SSH keys: [docs.github.com](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)


Sops keys: 
`sudo age-keygen -o ~/.config/sops/age/keys.txt`


### Wakatime
`~/.wakatime.cfg` needs to be imperatively edited to point to my self hosted wakapi instance.




## Olympus

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

### Backups
`Olympus` now leverages restic for important file and database backups. Currently "backups" are just local snapshots however a off-site backup box (`Elysium`) would be a crucial next step.

- `sudo systemctl start restic-backups-olympus.service` - Manually start the restic backup (does not call postgresBackup)
- `sudo restic-olympus snapshots` - View current snapshots


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

- Harmonia Binary Cache keys
    `nix-store --generate-binary-cache-key cache.peaterpita.com-1 /tmp/key.secret /tmp/key.pub`
    Replace sops and common.nix values

