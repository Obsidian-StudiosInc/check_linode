# check_linode.sh
[![License](https://img.shields.io/badge/license-MIT-blue.svg?colorB=9977bb&style=plastic)](https://github.com/Obsidian-StudiosInc/check_linode/blob/master/LICENSE)
[![Build Status](https://img.shields.io/travis/Obsidian-StudiosInc/check_linode/master.svg?colorA=9977bb&style=plastic)](https://travis-ci.org/Obsidian-StudiosInc/check_linode)
[![Build Status](https://img.shields.io/shippable/5840e5c204d5ee0f002033e7/master.svg?colorA=9977bb&style=plastic)](https://app.shippable.com/projects/5840e5c204d5ee0f002033e7/)

Nagios plugin to check the status of a Linode using the Linode API. 
Basic bash script using curl to check the status and return output for 
Nagios, and compatible.

## Install
To install simply copy check_linode.sh into nagios plugins directory.

Example
```bash
wget https://raw.githubusercontent.com/Obsidian-StudiosInc/check_linode/master/check_linode.sh
chmod 755 check_linode.sh
mv check_linode.sh /usr/lib/nagios/plugins
```

## Usage

### CLI
To use simply run the script with a Linode API Key using your 
linode's ID.

```bash
./check_linode.sh -k <api_key> -l <linode_id>
```

### Nagios
For use in Nagios you can see the included example. You need to define a 
command to include the check_linode.sh. Then add the check to any hosts.

```
# check command
define command {
	command_name	check_linode
	command_line	$USER1$/check_linode.sh -a $_HOSTLINODE_API_KEY$ -l $_HOSTLINODE_ID$
}
```

Then add the check to any hosts.

```
# host template
define host {
        host_name				linode
        address                                 0.0.0.0
        _linode_api_key				007
        _linode_id				007
        check_command				check_linode
}
```
