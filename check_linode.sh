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

if [[ -z ${1} ]]; then
	display_help
	exit 3
fi

# Parse parameters
while :
do
	case "$1" in
		-k | --api-key)
			if [[ -z ${2} ]]; then
				echo "Linode API Key not specified aborting"
				exit 3
			fi
			API_KEY="${2}"
			shift 2
			;;
		-l | --linode-id)
			if [[ -z ${2} ]]; then
				echo "Linode ID not specified aborting"
				exit 3
			fi
			LINODE_ID="${2}"
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
if [[ -z ${API_KEY} ]]; then
	echo "Linode API Key not specified aborting"
	exit 3
fi

if [[ -z ${LINODE_ID} ]]; then
	echo "Linode ID not specified aborting"
	exit 3
fi

RESPONSE=$(curl -s "https://api.linode.com/?api_key=${API_KEY}&api_action=linode.list&linodeid=${LINODE_ID}")

# Check response
if [[ -z ${RESPONSE} ]]; then
	echo "CRITICAL - Linode API unreachable"
	exit 2
fi

STATUS="$(echo -e "${RESPONSE}" | sed 's/.*"STATUS":\([0-9]*\),.*/\1/')"

# Check status
if [[ -z ${STATUS} ]]; then
	echo "CRITICAL - Linode API invalid response"
	exit 2
fi

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
