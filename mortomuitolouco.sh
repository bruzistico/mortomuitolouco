#!/usr/bin/env bash
#-Metadata----------------------------------------------------#
#  Filename: mortomuitolouco (v1.0)      (update: 2023-03-17) #
#-Info--------------------------------------------------------#
#  Scanner and analysis of subdomains/domains dead            #
#-Author(s)---------------------------------------------------#
#  Bruzistico ~ @bruzistico                                   #
#-Operating System--------------------------------------------#
#  Designed for & tested on: Linux	 	                      #
#  Reported working : Ubuntu 20                               #
#	   	    : Parrot 				      					  #
#           : Kali Linux 								      #
#		    : WSL Windows (10.0.17134 N/A Build 17134		  #
#		    : MacOS (Mojave)			      				  #
#-Licence-----------------------------------------------------#
#  MIT License ~ http://opensource.org/licenses/MIT           #
#-------------------------------------------------------------#

#clear
### Variable Name and Version ------------------------------------------------------------------------

APPNAME="mortomuitolouco.sh"
VERSION="1.0#dev"

#### Colors Outputs -----------------------------------------------------------------------------------

RESET="\033[0m"			# Normal Colour
RED="\033[0;31m" 		# Error / Issues
GREEN="\033[0;32m"		# Successful       
BOLD="\033[01;01m"    	# Highlight
YELLOW="\033[0;33m"		# Warning
PADDING="  "
DPADDING="\t\t"
RPADDING="\t"
LGRAY="\033[0;37m"		# Light Gray
LRED="\033[1;31m"		# Light Red
LGREEN="\033[1;32m"		# Light GREEN
LBLUE="\033[1;34m"		# Light Blue
LPURPLE="\033[1;35m"	# Light Purple
LCYAN="\033[1;36m"		# Light Cyan
SORANGE="\033[0;33m"	# Standar Orange
IORANGE="\033[3;33m" 	# Italic Orange
SBLUE="\033[0;34m"		# Standar Blue
SPURPLE="\033[0;35m"	# Standar Purple      
SCYAN="\033[0;36m"		# Standar Cyan
DGRAY="\033[1;30m"		# Dark Gray


#### Banner ---------------------------------------------------------------------------------------------
goBanner(){

echo -e "       __---------___                          ${LRED} _ ${RESET}                    "
echo -e "     _/              \    ${RED} _ __ ___   ___  _ __| |_ ___${RESET}                "
echo -e "    /                 \   ${RED}| '_ ' _ \ / _ \| '__| __/ _ \ ${RESET}              "
echo -e "   /         /  _    _ |  ${SORANGE}| | | | | | (_) | |  | || (_) | ${RESET}         "
echo -e "  /          | / \  / \ \ ${YELLOW}|_| |_| |_|\___/|_|   \__\___/ ${RESET}           "
echo -e " |           ||   ||   ||                   ${LRED}_ _${RESET}                       "
echo -e " |           | \_//\\_/ |    ${RED}_ __ ___  _   _(_) |_ ___${RESET}                 "
echo -e " |   |_______|   (||) |_|${RED}  | '_ ' _ \| | | | | __/ _ \ ${RESET}                "
echo -e " |   \ \  _ |     ||  |  ${SORANGE}  | | | | | | |_| | | || (_) | ${RESET}           "
echo -e "  \   \ \/ ||_________|  ${YELLOW}  |_| |_| |_|\__,_|_|\__\___/  ${RESET}            "
echo -e "   \___\_  |\|_|_|_|_|   ${LRED} _ ${RESET}                                          "
echo -e "         |  \ _ _ _\_    ${RED}| | ___  _   _  ___ ___ ${RESET}                      "
echo -e "         |   |_|_|_|_|.  ${RED}| |/ _ \| | | |/ __/ _ \ ${RESET}                     "
echo -e "          \           |  ${SORANGE}| | (_) | |_| | (_| (_) | ${RESET}                "
echo -e "           \__________|  ${YELLOW}|_|\___/ \__,_|\___\___/ ${RESET}                  "
echo -e "				                                                                      "
echo -e "   Scanner subdomains/domains ${RED}dead ${RESET}\xE2\x98\xA0  [Search Virtual Hosts]"
echo -e "                                   V{${VERSION}} by ${GREEN}@bruzistico${RESET}      "
echo -e "               ${SBLUE}https://github.com/bruzistico/mortomuitolouco${RESET}         "


 }

#### Help --------------------------------------------------------------------------------------------------
goHelp() {
  echo -e ""	
  echo -e " ${BOLD}Basic usage${RESET}:"
  echo -e "${PADDING}${SORANGE}$0${RESET} ${GREEN}-s${RESET} subdomain.example.com ${GREEN}-i${RESET} 192.168.0.10"
  echo -e "${PADDING}${SORANGE}$0${RESET} ${GREEN}-s${RESET} subdomain.example.com ${GREEN}-iL${RESET} listips.txt"
  echo -e "${PADDING}${SORANGE}$0${RESET} ${GREEN}-sL${RESET} subdomainlist.txt ${GREEN}-i${RESET} 192.168.0.10"
  echo -e "${PADDING}${SORANGE}$0${RESET} ${GREEN}-sL${RESET} subdomainlist.txt ${GREEN}-iL${RESET} listip.txt"
  echo -e ""
  echo -e " ${RED}[INFO]${RESET} It is mandatory to inform Dead targets [${GREEN}-s${RESET} or ${GREEN}-sL${RESET}] ${BOLD}${LPURPLE}and${RESET} IP targets [${GREEN}-i${RESET} or ${GREEN}-iL${RESET}]"
  echo -e ""
  echo -e " ${BOLD}Options:${RESET}"
  echo -e "${PADDING}${BOLD}${GREEN}-s, ${RESET} --subdomain${RPADDING} Scan only one target subdomain/domain (e.g subdomain.example.com)"
  echo -e "${PADDING}${BOLD}${GREEN}-sL,${RESET} --subdomain-list\t Scan multiple targets in a text file "
  echo -e "${PADDING}${BOLD}${GREEN}-i, ${RESET} --ip${DPADDING} Scan only one virtual host IP (e.g 192.168.0.10)"
  echo -e "${PADDING}${BOLD}${GREEN}-iL,${RESET} --ip-list${RPADDING} Scan multiple virtual host IP in a text file"
  echo -e "${PADDING}${BOLD}${GREEN}-o, ${RESET} --output${DPADDING} Output (eg. output.txt)"
  echo -e "${PADDING}${BOLD}${GREEN}-v, ${RESET} --verbose${RPADDING} Verbose"
  echo -e "${PADDING}${BOLD}${GREEN}-h, ${RESET} --help${DPADDING} Help [Usage]"
}

[[ "${#}" == 0 ]] && {
	goBanner
	goHelp && exit 1
}

##=======================================================================================================================
##
## FUNCTIONS
##
##=======================================================================================================================

checkArguments(){
    options+=(-s --subdomain-list -sL --ip-list -i --ip -iL -listip -p --port -o --output)
    if [[ "${options[@]}" =~ "$2" ]]; then
            echo -e ""
            echo -e " The argument of \"${GREEN}$1${RESET}\" it can not be ${RED}\"$2\"${RESET}, please, ${SORANGE}specify a valid one${RESET}."
            goHelp
    fi
}

msg_File(){
	echo -e " ${SORANGE}[i]${RESET} Invalid file: The file ${RED}"${2}"${RESET}"
	echo -e " ${RED}"${2}"${RESET} [not found - invalid - read permissions]"
	echo -e " Please insert a valid file for the option ${GREEN}${1}${GREEN}"
}

msg_subHeader(){
	
	echo ""
	echo -e "${BOLD} Scanning if virtual host exists:"
	echo -e "${DPADDING}"
	echo -e "${BOLD} [STATUS][SCODE][SIZE]  SUBDOMAIN/DOMAIN >> IP RESOLVE"
}

status_Code(){

	case $status in
	    200) status="$( echo -e "${GREEN}${status}${RESET}" )"    ;;    
		401) status="$( echo -e "${RED}${status}${RESET}" )"      ;;
		403) status="$( echo -e "${RED}${status}${RESET}" )"      ;;
		404) status="$( echo -e "${SBLUE}${status}${RESET}" )"    ;;
		503) status="$( echo -e "${YELLOW}${status}${RESET}" )"   ;;
		530) status="$( echo -e "${YELLOW}${status}${RESET}" )"   ;;
	      *) status="$( echo -e "${status}")"				      ;;
	esac 
}

size_Correct(){
	count=${#size}

	case $count in
		3) size="$(echo -e "${size}\t")"     ;; 
		2) size="$(echo -e "${size}\t\t")"   ;;
		1) size="$(echo -e "${size}\t\t\t")" ;;
		*) size="$(echo -e "${size}")"    	 ;;
	esac
}

error_IP(){

	msg_error_ip="$(echo -e " [${SORANGE} ERROR${RESET}][ --- ][----]  ${IP} - ${SORANGE}[i]${IORANGE} No default ports open ${RESET}[80,443]${RESET}")"
	echo "${msg_error_ip}"
}

msg_Done(){

	msg="$(
		echo ""
		echo -e " Done! \xE2\x98\xA0"
		echo "${re}"
		)"
	echo "${msg}"
}

##=======================================================================================================================
## 
##FUNCTIONS CONSULT / COMPARE
##
##=======================================================================================================================

consult_Original(){
	
	original="$(timeout --signal=9 1 curl -siLk -o /dev/null -w "%{response_code}","%{size_download}" "$IP" --no-keepalive)"
}

consult_Dead(){
	
	#technique using DNS
	dead_dns="$(timeout --signal=9 8 curl -siLk $SUBDOMAIN --resolve $SUBDOMAIN:80:"$IP" --resolve $SUBDOMAIN:443:"$IP" -o /dev/null -w "%{response_code}","%{size_download}")"
	
	#techinique using Header Host
	#dead_header_host="$(timeout --signal=9 5 curl -siLk -o /dev/null -w "%{response_code}","%{size_download}" http://"$IP" -H 		host:"$SUBDOMAIN")"
}

compare_Original_with_Dead(){

	size="$(echo "${dead_dns}" | cut -d , -f 2 )"
	status="$(echo "${dead_dns}" | cut -d , -f 1 )"

	if [[ -n "${original}" && "${original}" != "" && "${original}" != "000,0" && "${size}" != 0 ]] && \
       [[ -n "${dead_dns}" && "${dead_dns}" != "" && "${dead_dns}" != "000,0" && "${size}" != 0 ]] && \
	   [[ "${original}" != "${dead_dns}" ]] && \
	   [[ "${original}" != "${dead_header_host}" ]] && \
	   [[ "$(echo "${dead_dns}" | cut -d , -f 1 | cut -c 1)" != "5" ]]; then
		status_Code "${status}"
		size_Correct "${size}"
		msg="$(echo -en " [ ${GREEN}LIVE${RESET} ][ "${status}" ][${LPURPLE}"${size}"${RESET}] ${SBLUE} ${SUBDOMAIN} ${RESET} "${YELLOW}">>${RESET} "${IP}"")"
		echo "$msg"

		if [[ "${KEY_OUTPUT}" == true ]]; then
			echo "${SUBDOMAIN} | ${IP}" >> "${OUTPUT}"
		fi
	else
		status="$(echo "${dead_dns}" | cut -d , -f 1 )"
		status_Code "${status}"
		size="$(echo "${dead_dns}" | cut -d , -f 2 )"
		size_Correct "${size}"
	
		if [[ "${KEY_VERBOSE}" == true ]] || [[ "${KEY_SUBDOMAIN}" == true && -n "${SUBDOMAIN}" ]]; then
			msg="$(echo -en " [ ${RED}DEAD${RESET} ][ "${status}" ][${LPURPLE}"${size}"${RESET}] ${SBLUE} "${SUBDOMAIN}" ${RESET} "${YELLOW}">>${RESET} "${IP}"")"
			echo "${msg}"
		fi
		
	fi

}

##=======================================================================================================================
##
## COMMAND LINE SWITCHES
##
##=======================================================================================================================

while [[ "${#}" -gt 0 ]]; do
 	args="${1}"
 	case "$(echo ${args})" in
 		# Subdomain/Domain unique
 		"-s" | "--subdomain")
		  checkArguments $1 $2
 		  SUBDOMAIN="${2}"
 		  KEY_SUBDOMAIN=true
 		  shift
 		  shift
 		  ;;
 		# List Subdomain/Domain [file]
 		"-sL" | "--subdomain-list")
		  checkArguments $1 $2
		  if [[ -f ${2} ]] && [[ -r ${2} ]]; then
		    LISTSUBDOMAIN="${2}"
		    KEY_LISTSUBDOMAIN=true
		  else
		  	echo ""
		  	echo -e " ${SORANGE}[i]${RESET} Invalid file: The file ${RED}"${2}"${RESET}"
			echo -e "${PADDING} ${RED}"${2}"${RESET} [not found - invalid - read permissions]"
			echo -e "${PADDING} Please insert a valid file for the option ${GREEN}${1}${GREEN}"
		  fi
 		  shift
 		  shift
 		  ;;
 		# IP unique
 		"-i" | "--ip")
		  checkArguments $1 $2
 		  IP="${2}"
 		  KEY_IP=true
 		  shift
 		  shift
 		  ;;
 		# List IP [file] 
 		"-iL" | "--ip-list")
		  checkArguments $1 $2
		  if [[ -f ${2} ]] && [[ -r ${2} ]]; then
		    LISTIP="${2}"
		    KEY_LISTIP=true
		  else
		  	echo -e " ${SORANGE}[i]${RESET} Invalid file: The file ${RED}"${2}"${RESET}"
			echo -e "${PADDING} ${RED}"${2}"${RESET} [not found - invalid - read permissions]"
			echo -e "${PADDING} Please insert a valid file for the option ${GREEN}${1}${GREEN}"
		  fi
 		  shift
 		  shift
 		  ;;
 		# Port unique 
 		"-o" | "--output")
		  checkArguments $1 $2
 		  OUTPUT="${2}"
 		  KEY_OUTPUT=true
 		  shift
 		  shift
 		  ;;  
 		# Verbose
 		"-v" | "--verbose")
 		  KEY_VERBOSE=true
 		  shift
 		  ;;
 		# Help
 		"-h" | "--help" )
		goBanner;
		goHelp;
		shift
		shift
		;;
 		"-"*)
 		  echo -e " ${SORANGE}[i]${RESET} Invalid option: ${RED}${1}${RESET}" && goHelp && shift && exit 1
 		  ;;
 		*)
 		  echo -e " ${SORANGE}[i]${RESET} Invalid: Unknown option ${RED}${1}${RESET}" && goHelp && shift && exit
 		  exit
 		  ;;
 	esac	
done


##=======================================================================================================================
##
## IFS ARGUMENTS
##
##========================================================================================================================
##
## IF -s [Subdomain/Domain unique] ---------------------------------------------------------------------------------------
##
if [[ "${KEY_SUBDOMAIN}" == true ]] && [[ -n "${SUBDOMAIN}" ]]; then
	###############################################################
	## Case -s -i [IP unique]---------------------------------------
	################################################################
	if [[ "${KEY_IP}" == true ]] && [[ -n "${IP}" ]]; then
		goBanner
		msg_subHeader
		consult_Original
		if [[ -n "${original}" ]] && [[ "${original}" != "" ]] && [[ "${original}" != "000,0" ]]; then
			consult_Dead
			compare_Original_with_Dead
		#else
	 	#	echo -e " [${SORANGE}ERROR${RESET} ][ --- ][----]  ${IP} - ${SORANGE}[i]${IORANGE} No default ports open ${RESET}[80,443]${RESET}"
		fi
		msg_Done
		exit 0
	fi
	#################################################################

	##################################################################
	## Case -s -iL [List IP [file]]------------------------------------
	##################################################################

	if [[ "${KEY_LISTIP}" == true ]] && [[ -n "${LISTIP}" ]]; then
		goBanner
		msg_subHeader
	 		for line in $(cat ${LISTIP}); do
	 			IP="${line}"
	 			consult_Original
	 			if [[ -n "${original}" ]] && [[ "${original}" != "" ]] && [[ "${original}" != "000,0" ]]; then
					consult_Dead
					compare_Original_with_Dead
				fi
	 		done
	 	msg_Done
		exit 0
	fi
	####################################################################
fi

##------------------------------------------------------------------------------------------------------------------------
##
##IF -sL [List Subdomain/Domain [file]]----------------------------------------------------------------------------
##
if [[ "${KEY_LISTSUBDOMAIN}" == true ]] && [[ -n "${LISTSUBDOMAIN}" ]]; then
	##########################################################################
	## IF -sL -i [IP unique]--------------------------------------------------
	##########################################################################
	if [[ "${KEY_IP}" == true ]] && [[ -n "${IP}" ]]; then
		goBanner
		msg_subHeader
		consult_Original
		if [[ -n "${original}" ]] && [[ "${original}" != "" ]] && [[ "${original}" != "000,0" ]]; then
			for line in $(cat ${LISTSUBDOMAIN}); do	
				SUBDOMAIN="$(echo "$line" | sed 's/\r//g')"
				consult_Dead
				compare_Original_with_Dead
			done
		fi
		msg_Done
		exit 0
	fi
	############################################################################

	#############################################################################
	## IF -sL -iL [List IP [file]]-----------------------------------------------
	#############################################################################
	if [[ "${KEY_LISTIP}" == true ]] && [[ -n "${LISTIP}" ]]; then
		goBanner
		msg_subHeader
		for ip in $(cat ${LISTIP}); do
			IP="${ip}"
			consult_Original
			if [[ -n "${original}" ]] && [[ "${original}" != "" ]] && [[ "${original}" != "000,0" ]]; then
				for line in $(cat ${LISTSUBDOMAIN}); do
					SUBDOMAIN="$(echo "$line" | sed 's/\r//g')"
					consult_Dead
					compare_Original_with_Dead
				done
			fi
		done
		msg_Done 
		exit 0
	fi
	################################################################################
fi

##----------------------------------------------------------------------------------------------------------------------
##
## END
##====================================================================================================================