# SSH server configuration and deployment of user keys.
# Requires herculesteam/augeasproviders_ssh

class ssh::server(
    Hash $options,
    Hash $userkeys,
) {

    $sshsrv = $::osfamily ? {
        'Debian'  => 'ssh',
        default => 'sshd',
    }

    $optdefaults = {
        ensure => present,
        notify => Service[$sshsrv],
    }

    $options.each |$o, $p| { sshd_config { $o: * => $optdefaults + $p } }

    service { $sshsrv:
        ensure => running,
        enable => true,
    }

    $filedefaults = {
        ensure => present,
        owner  => 'root',
        group  => 'root',
        mode   => '0555',
    }

    file {
        default: * => $filedefaults;
        '/etc/ssh/authorized_keys':
            ensure => directory,;
    }

    $userkeys.each |String $u, Hash $v| {
        file {
            default: * => $filedefaults;
            "/etc/ssh/authorized_keys/${u}":
                ensure  => $v['ensure'],
                mode    => '0444',
                content => inline_template(
                    "<% @v['keys'].each do |k| -%><%= k %>\n<% end -%>",
                ),;
        }
    }

}

