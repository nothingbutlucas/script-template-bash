#!/usr/bin/bash -e

# Note: The -e flag will cause the script to exit if any command fails.

# Description: {{cookiecutter.description}}
# Author: {{cookiecutter.author}}
# Version: {{cookiecutter.version}}
# License: {{cookiecutter.license}}

# Colours and uses

red='\033[0;31m'    # Something went wrong
green='\033[0;32m'  # Something went well
yellow='\033[0;33m' # Warning
blue='\033[0;34m'   # Info
purple='\033[0;35m' # When asking something to the user
cyan='\033[0;36m'   # Something is happening
grey='\033[0;37m'   # Show a command to the user
nc='\033[0m'        # No Color

sign_wrong="${red}[-]${nc}"
sign_good="${green}[+]${nc}"
sign_warn="${yellow}[!]${nc}"
sign_info="${blue}[i]${nc}"
sign_ask="${purple}[?]${nc}"
sign_doing="${cyan}[~]${nc}"
sign_cmd="${grey}[>]${nc}"

wrong="${red}"
good="${green}"
warn="${yellow}"
info="${blue}"
ask="${purple}"
doing="${cyan}"
cmd="${grey}"

trap ctrl_c INT

function ctrl_c() {
	exit_script
}

function error() {
	echo -e "${sign_wrong} ERROR: $*" >/dev/stderr
}

function exit_script() {
	echo -e "${sign_good} Exiting script"
	tput cnorm
	exit 0
}

function start_script() {
	tput civis
	echo ""
	echo -e "${sign_good} Starting script"
}

function verify_root() {
	root_or_not={{cookiecutter.run_as_root}}
	if [[ $root_or_not == "y" ]]; then
		if [[ $(id -u) -ne 0 ]]; then
			error "This script must be run as root"
			exit_script
		else
			echo -e "${sign_good} Running as root"
		fi
	else
		if [[ $(id -u) == 0 ]]; then
			error "This script must not be run as root"
			exit_script
		else
			echo -e "${sign_good} Not running as root"
		fi
	fi
}

function help_panel() {
	echo -e "\n${sign_warn} Usage: ${good}$0\n"
	echo -e "${sign_info} The script will {{cookiecutter.description}}"
	echo -e "\n${sign_warn} Example: ${good}$0 ${info} -h ${nc}\n"
	echo -e "\n${sign_warn} Options:\n"
	echo -e "\t${info} -a ${nc}Set the option_a"
	echo -e "\t${info} -b ${nc}Set the option_b"
	echo -e "\t${info} -h ${nc}Show this help panel"
	echo -e "\n"

	exit_script
}

function wait_for_confirmation() {
	echo -ne "\n${sign_ask} Press ${ask}enter${nc} to continue..." && read enter
	if [[ $enter != "" ]]; then
		exit_script
	fi
}

function case_a() {
	echo -e "${sign_doing} Doing something with case a..."
	wait_for_confirmation
}

function case_b() {
	echo -e "${sign_doing} Doing something with case b..."
	wait_for_confirmation
}

function case_c() {
	echo -e "${sign_doing} Doing something with case c..."
	wait_for_confirmation
	exit_script
}

function case_d() {
	echo -e "${sign_doing} Doing something with case d..."
	wait_for_confirmation
}

# Main function

function main() {
	if [ $option_a == alpha ]; then
		case_a
	elif [ $option_b == beta ]; then
		case_b
	else
		case_d
	fi
}

# Script starts here

start_script

option_a=a
option_b=b

while getopts ":a:b:hc" arg; do
	case $arg in
	a) option_a=$OPTARG ;;
	b) option_b=$OPTARG ;;
	c) case_c ;;
	h) help_panel ;;
	?)
		error "Invalid option: -$OPTARG\n"
		help_panel
		;;
	esac
done

verify_root
main
exit_script
