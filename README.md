# eXistdb Puppet module

customized and enhanced for use in rdd


#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with existdb](#setup)
    * [Beginning with existdb](#beginning-with-existdb)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)

## Description

This module installs the eXist database software and starts it as a service.

## Setup

To use this module, add these declarations to your Puppetfile:

```
mod 'puppetlabs-stdlib','4.25.1'
mod 'puppetlabs-java', '2.1.0'
mod 'puppet-archive', '3.0.0'
mod 'puppet-nginx','0.15.0'
mod 'jonhallettuob-existdb', '0.3.3'
```

To install eXistdb and start it as a service with default parameters:

```
class { 'java':
  package => 'java-1.8.0-openjdk-devel',
}
class { 'existdb': }
```

Or equivalently in Hiera:

```
---
classes:
  - java
  - existdb

java::package: 'java-1.8.0-openjdk-devel'
```

To configure a reverse proxy to make eXistdb appear on port 443, add `mod 'puppet-nginx', '0.9.0'` to your Puppetfile and then in Hiera:

```
classes:
  - existdb::reverseproxy

existdb::reverseproxy::servers:
  'server.example.com':
    server_cert_name: 'server.example.com'
    uri_path: '/exist/apps/example.com'
```

## Usage

Set up eXistdb and its data in specific directories:

```
class existdb {
  exist_home => '/usr/local/exist',
  exist_data => '/var/lib/exist',
}
```

## Service Configuration

When another service name (`$exist_service`) than the default ('eXist-db') is provided, the module looks after a configuration file `puppet:///modules/profiles/etc/systemd/system/${exist_service}.service`

## Reference

```
class existdb
(
  $exist_home                  = '/usr/local/existdb',
  $exist_data                  = '/var/lib/existdb',
  $exist_cache_size            = '128M',
  $exist_collection_cache_size = '24M',
  $exist_revision              = 'eXist-5.0.0',
  $exist_version               = regsubst($exist_revision, '^eXist-', ''),
  $java_home                   = '/usr/lib/jvm/jre',
  $exist_user                  = 'existdb',
  $exist_group                 = 'existdb',
  $exist_service               = 'eXist-db',
  $running                     = true,
)
{
 ...
}

class existdb::reverseproxy (
  $servers,
  $exist_home    = '/usr/local/existdb',
  $exist_service = 'eXist-db',
)
{
 ...
}

define existdb::reverseproxy::server {
  $server_name,
  $server_cert_name = $server_name,
  $ssl_cert_path = "/etc/pki/tls/certs/${server_cert_name}.crt",
  $ssl_cert = undef,
  $ssl_key_path = "/etc/pki/tls/private/${server_cert_name}.key",
  $ssl_key = undef,
  $uri_path = '',
  $proxy_redirect = 'default',
  $location_cfg_append = undef,
  $raw_append = undef,
) {
 ...
}
```

## Limitations

The module was developed on CentOS 7 using Puppet 4 and hasn't been tested on any other systems.
