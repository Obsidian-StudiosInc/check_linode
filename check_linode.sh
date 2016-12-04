#!/bin/bash
#
# Copyright 2015 Obsidian-Studios, Inc.
# Author William L. Thomson Jr.
# 	 wlt@o-sinc.com#

# Distributed under the terms of The MIT License (MIT)

# check_linode.sh checks the status of a Linode using the Linode API.
# Using a Linode API key and Linode ID as parameters and returning a
# Nagios plugin status code with message.

VERSION="Version 0.1"

print_help() {
	echo "Usage: $0 -k <api_key> -l <linode_id>"
}

print_version() {
	echo "${VERSION}"
}

[[ -z $1 ]] && display_help && exit 3

# Parse parameters
while :
do
	case "$1" in
		-k | --api-key)
			[[ -z ${2} ]] && echo "Linode API Key not specified aborting" && exit 3
			API_KEY=${2}
			shift 2
			;;
		-l | --linode-id)
			[[ -z ${2} ]] && echo "Linode ID not specified aborting" && exit 3
			LINODE_ID=${2}
			shift 2
			;;
		-h | --help)
			print_help
			exit 0
			;;
		-v | --version)
            		print_version "${0}" "${VERSION}"
		        exit 0
            		;;
		--)
			shift
			break
			;;
		-*)
			echo "Error: Unknown option: $1 >&2"
			exit 3
			;;
		*)
			break
			;;
	esac
done

# Check required variables
[[ -z ${API_KEY} ]] && echo "Linode API Key not specified aborting" && exit 3
[[ -z ${LINODE_ID} ]] && echo "Linode ID not specified aborting" && exit 3

RESPONSE=$(curl -s "https://api.linode.com/?api_key=${API_KEY}&api_action=linode.list&linodeid=${LINODE_ID}")

# Check response
[[ -z ${RESPONSE} ]] && echo "CRITICAL - Linode API unreachable" && exit 2

STATUS="$(echo -e "${RESPONSE}" | sed 's/.*"STATUS":\([0-9]*\),.*/\1/')"

# Check status
[[ -z ${STATUS} ]] && echo "CRITICAL - Linode API invalid response" && exit 2

# Handle status
case ${STATUS} in
	-1) echo "WARNING - Linode Being Created"
		exit 1
		;;
	0) echo "WARNING - Brand New Linode"
		exit 1
		;;
	1) echo "OK - Linode Running"
		exit 0
		;;
	2) echo "CRITICAL - Linode Powered Off"
		exit 2
		;;
	*) echo "Unknown"
		exit 3
		;;
esac
