class log::forwarder {

	if $::agentfqdn != '' {
		$host = $::agentfqdn
	} elsif $::masterfqdn != '' {
		$host = $::masterfqdn
	} else {
		$host = $::fqdn
	}

	anchor { 'log::forwarder::begin': } ->

	class { 'beaver':
		hostname => $host,
	} ->

	file_fragment { 'logstash_version_fragment' :
		tag     => "beaver_config_${::fqdn}",
		content => "logstash_version:1\n",
		order   => 11,
	} ->

	beaver::output::redis { 'redis_out':
		host => hiera('log::broker', 'localhost'),
	} ->

	anchor { 'log::forwarder::end': }

}