# SSH server configuration and deployment of user keys.

class ssh::server(
    Hash $options,
    Hash $userkeys,
) {

    $sshsrv = $::osfamily ? {
        'Debian'  => 'ssh',
        default => 'sshd',
    }

    $optionarray = $options.map |$k, $v| { "set ${k} ${v}"}

    augeas { 'ssh server config':
        incl    => '/etc/ssh/sshd_config',
        lens    => 'sshd.lns',
        changes => $optionarray,
        notify  => Service[$sshsrv]
    }

    service { $sshsrv:
        ensure => running,
        enable => true,
    }

    File {
        ensure => present,
        owner  => 'root',
        group  => 'root',
        mode   => '0555',
    }

    file { '/etc/ssh/authorized_keys':
        ensure => directory,
    }

    $userkeys.each |String $u, Hash $v| {
        file { "/etc/ssh/authorized_keys/${u}":
            ensure  => $v['ensure'],
            mode    => '0444',
            content => inline_template(
                "<% @v['keys'].each do |k| -%><%= k %>\n<% end -%>",
            ),
        }
    }

}

