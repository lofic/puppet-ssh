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

# Requires the module puppet/augeasproviders_ssh
ssh::server::options:
    # The filebeat system auth module expects the SyslogFacility AUTHPRIV
    # for ssh logs
    'SyslogFacility generic':
        key: SyslogFacility
        value: AUTHPRIV
    'PermitRootLogin generic':
        key: PermitRootLogin
        value: without-password
    'PubkeyAuthentication generic':
        key: PubkeyAuthentication
        # Quote the value to get a String, not a Boolean.
        value: 'yes'
    'AuthorizedKeysFile generic':
        key: AuthorizedKeysFile
        value: '/etc/ssh/authorized_keys/%u'
    'Set SSH Idle Timeout Interval - OSCAP guideline':
        key: ClientAliveInterval
        value: '600'
    'GSSAPIAuthentication no':
        key: GSSAPIAuthentication
        value: 'no'
    'UseDNS no':
        key: UseDNS
        value: 'no'
    'AllowTcpForwarding sftpusers':
        key: AllowTcpForwarding
        # Quote the value to get a String, not a Boolean
        value: 'no'
        condition: 'Group sftpusers'
    'ChrootDirectory sftpusers':
        key: ChrootDirectory
        value: '/home/%u'
        condition: 'Group sftpusers'
    'ForceCommand sftpusers':
        key: ForceCommand
        value: internal-sftp
        condition: 'Group sftpusers'
    'GatewayPorts sftpusers':
        key: GatewayPorts
        value: 'no'
        condition: 'Group sftpusers'
    'X11Forwarding sftpusers':
        key: X11Forwarding
        value: 'no'
        condition: 'Group sftpusers'

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
