# check_linode.sh
[![License](https://img.shields.io/badge/license-MIT-blue.svg?colorB=9977bb&style=plastic)](https://github.com/Obsidian-StudiosInc/check_linode/blob/master/LICENSE)
[![Build Status](https://img.shields.io/github/actions/workflow/status/Obsidian-StudiosInc/check_linode/shellcheck.yml?color=9977bb&style=plastic)](https://github.com/Obsidian-StudiosInc/check_linode/actions)

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
To use simply run the script with a Linode API token using your 
linode's ID.

```bash
./check_linode.sh -t <token> -l <linode_id>
```

### Nagios
For use in Nagios you can see the included example. You need to define a 
command to include the check_linode.sh. Then add the check to any hosts.

```
# check command
define command {
	command_name	check_linode
	command_line	$USER1$/check_linode.sh -t $_HOSTLINODE_TOKEN$ -l $_HOSTLINODE_ID$
}
```

Then add the check to any hosts.

```
# host template
define host {
        host_name				linode
        address                                 0.0.0.0
        _linode_token				007
        _linode_id				007
        check_command				check_linode
}
```
