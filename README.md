# Puppet module: postfix

#### Table of contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Backwards incompatibility](#backwards-incompatibility)
4. [Setup - The basics of getting started with postfix](#setup)
    * [What postfix affects](#what-ssh-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with ssh](#beginning-with-postfix)
5. [Usage - Configuration options and additional functionality](#usage)
6. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
7. [Limitations - OS compatibility, etc.](#limitations)
8. [Development - Guide for contributing to the module](#development)
9. [Contributors](#contributors)

##Overview

The postfix module allows to manage postfix.

##Module description

postfix is a widely-used mail transport agent and this module provides
a way to manage it. Apart from package installation and service management
this to manage all aspects of the postfix configuration:

- main configuration file
- master configuration file
- map files
- installation of map provider(s) on Debian-based systems

## Setup

### What postfix effects

* postfix package
* postfix service
* postfix configuration (optional)
* postfix maps (optional)
* aliases

### Beginning with postfix

If you just want to install postfix, with the default configuration as supplied
by the package maintainer, you can run include '::postfix'.

If you want to manage the main.cf of postfix, you need to pass an options hash
and tell the module to manage the config.

```puppet
class { '::postfix':
  manage_config   => true
  postfix_options => $options_hash
}
```
The default template is simply maping the key/value pairs to corresponding
key = value pairs in the main configuration file.

If you do not specify an options hash, the module defaults to an options hash
which will setup the system for local mail delivery.

##Usage

### Classes and defined types

The postfix module provides various classes and defined types to
configure postfix, which are listed below. Please see the class docs for
supported parameters and their meaning.

#### Class: postfix

The module's primary class postfix guides the basic setup of postfix.

#### Define: postfix::config

This define allows managing a postfix configuration file (like main.cf or
master.cf) and will handle service reload on change. 

## Reference

The module contains the following public classes:

- postfix
- postfix::aliases

It also includes the following defined types:

- postfix::map
- postfix::config
- postfix::maincf
- postfix::mastercf

Lastly it contains an EXPERIMENTAL custom type

postconf_entry

which can be used to edit postfix main.cf settings. Currently it's not
recommended to be used, since its likely to change.

## Limitations

This module has been tested and is used primarily on Debian-based systems.
Other systems are supported but cannot be guaranted.

## Development

I happily accept bug reports and pull requests via github.

## Contributors

This module is written and being maintained by
    
    Patrick Schoenfeld <patrick.schoenfeld@credativ.de>.

It has been based on the module credativ/puppet-postfix, previously written
for my employer and maintained together with my colleagues. It contains
contributions from at least the following authors:

- Dennis Hoppe
- Damian Lukowski
- Alexander Wirt
- Arnd Hannemann
- Carsten Wolff
