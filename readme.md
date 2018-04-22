# SSH server configuration and deployment of user keys

Set the SSH server options and user keys in hiera.

For example :

```yaml
---
lookup_options:
    ssh::server::options:
        merge: hash
    ssh::server::userkeys:
        merge: hash

ssh::server::options:
    # the filebeat system auth module expects the SyslogFacility AUTH
    SyslogFacility: AUTH
    PermitRootLogin: without-password
    PubkeyAuthentication: 'yes'
    AuthorizedKeysFile: '/etc/ssh/authorized_keys/%u'

ssh::server::userkeys:
    foo:
        ensure: present
        keys:
            - "ssh-rsa \
               AAAAB3NzaC1yc2EAAAADAQABAAABAQCfI..."
            - "ssh-rsa \
               AAAAB3NzaC1yc2EAAAADAQABAAABAQC1n..."
     bar:
        ensure: present
        keys:
            - "ssh-rsa \
               AAAAB3NzaC1yc2EAAAADAQABAAABAQDOs..."

```
