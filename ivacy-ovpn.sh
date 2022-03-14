#!/bin/bash

#
# OpenVPN protocol:
#   TCP -- tcp
#   UDP -- udp
#   ''  -- random
PROTO=UDP

#
# Get country names
#
# Parameter:
#   $1 -- UDP or TCP (optional)
#
function get_country_names() {
	local PROTO="${1:-*}"
	#
	# "find" utility lists *.ovpn files from current directory:
	#	Australia-Brisbane-TCP.ovpn
	#	Australia-Brisbane-UDP.ovpn
	#	Australia-Melbourne-TCP.ovpn
	#	...
	# Then "awk" command extracts country names, "sort" lists unique country names
	#
	find . -maxdepth 1 -mindepth 1 -name '*'-"$PROTO"'.ovpn' -printf '%f\n' | \
		awk -F- '{print $1}' | \
		sort -u
}

declare -a COUNTRIES=()

function fill_countries() {
	while read COUNTRY; do
		COUNTRIES+=("$COUNTRY")
	done < <(get_country_names)
}

fill_countries

#
# Select from menu
#
# Parameters are menu items
#
function menu() {
	local COUNTRY
	select COUNTRY; do
		break
	done
	echo "$COUNTRY"
}

#
# Select from menu of countries
#
# Standard input: each line is a country
#
# Parameter:
#   $1 -- UDP or TCP (optional)
#
function country_menu() {
	local PROTO="${1:-*}"
	local IFS=$'\n'
	menu $(get_country_names "$PROTO")
}

#
# Get random file from given country
#
# Parameters:
#   $1 -- country name, e,g. 'United States'
#   $2 -- UDP or TCP (optional)
#
function country_file() {
	local PROTO="${2:-*}"
	find . -maxdepth 1 -mindepth 1 -name "$1"-'*'"$PROTO"'.ovpn' -printf '%f\n' | \
		sort -R | \
		head -n1
}

#
# Run OpenVPN with given file
#
# Parameter:
#   $1 -- OpenVPN file name
#
function ovpn() {
	echo "-- File used: $1 ..."
	sudo openvpn \
		--config "$1" \
		--auth-user-pass auth.txt \
		--remote-cert-tls server \
		--data-ciphers AES-256-CBC:AES-256-GCM:AES-128-GCM \
		--allow-compression yes \
		--auth-retry nointeract
}

#
# Type a prompt
#
function type_prompt() {
	local CURR_PROTO=${PROTO:-Random TCP or UDP}
	echo 'Q -- quit'
	echo
	echo "== Protocol ($CURR_PROTO) =="
	echo 'U -- protocol: UDP'
	echo 'T -- protocol: TCP'
	echo 'R -- protocol: random TCP or UDP'
	echo
	country_menu  "$PROTO" <<<' ' | head -n-1
}

#
# Read answer and react
#
function read_answer() {
	local ANSWER LC COUNTRY

	while true; do
		type_prompt
		read ANSWER
		LC=${ANSWER,,}
		case "$LC" in
			q )
				echo '-- Bye!'
				break;;
			u )
				PROTO=UDP;;
			t )
				PROTO=TCP;;
			r )
				PROTO=;;
			* )
				if [[ "$LC" =~ ^[0-9]+$ && "$LC" -gt 0 && "$LC" -le ${#COUNTRIES[@]} ]]; then
					COUNTRY=${COUNTRIES[$((LC-1))]}
					echo "-- Country: $COUNTRY"
					echo "-- [Press Ctrl+C to interrupt VPN] --"
					ovpn "$(country_file "$COUNTRY" "$PROTO")"
				else
					echo '** Unknown: '"$LC"
				fi
		esac
	done
}


#ovpn "$(country_file $(country_menu "$PROTO") "$PROTO")"
read_answer
