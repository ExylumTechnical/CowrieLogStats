#!/bin/bash
# created by Nicholas Howland on 10/29/2023
# Published without warrenty or guarentee
# Anyone is free to use, modify, or add to this code as desired.

# some beautification stuff
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURP='\033[0;35m'
END='\033[0m'

# log parsing stuff
if [ -f $1 ] && [ $1 ]; then
#LOGFILE="/media/backup/honeypot/CURRENT/cowrie.txt"
LOGFILE=$1
STARTTIME=$(head -n 1 $LOGFILE | awk '{print $1}' | awk -F. '{print $1}' | awk -F"T" '{print $1" "$2}')
ENDTIME=$(tail -n 1 $LOGFILE | awk '{print $1}' | awk -F. '{print $1}' | awk -F"T" '{print $1" "$2}' )
TOTALCONNECTIONS=$(grep -a connection $LOGFILE | nl | tail -n 1 |awk '{print $1}')
TOTALCOMMANDS=$(grep -a CMD $LOGFILE | nl | tail -n 1 | awk '{print $1}')
UNIQEIPS=$(grep -a "New connection" $LOGFILE | awk '{print $5}' | awk -F\: '{print $1}' | sort | uniq | nl | tail -n 1 | awk '{print $1}')
FILES=$(grep -a "contents with" $LOGFILE | awk '{print $8}' | sort | uniq)
MOSTAGGRESSIVE=$(grep -a "New connection" $LOGFILE | awk '{print $5}' | awk -F\: '{print $1}' | sort | uniq -c | sort -n | tail -n 1 | awk '{print $2}')
AGGRESSORCOUNT=$(grep -a "New connection" $LOGFILE | awk '{print $5}' | awk -F\: '{print $1}' | sort | uniq -c | sort -n | tail -n 1 | awk '{print $1}')

# output stuff
echo
echo -e ${PURP}\########################################################
echo "_________                       .__
\_   ___ \  ______  _  _________|__| ____
/    \  \/ /  _ \ \/ \/ /\_  __ \  |/ __ \
\     \___(  <_> )     /  |  | \/  \  ___/
 \______  /\____/ \/\_/   |__|  |__|\___  >
        \/                              \/
  .__                            __          __
  |  |   ____   ____     _______/  |______ _/  |_  ______
  |  |  /  _ \ / ___\   /  ___/\   __\__  \\   __\/  ___/
  |  |_(  <_> ) /_/  >  \___ \  |  |  / __ \|  |  \___ \
  |____/\____/\___  /  /____  > |__| (____  /__| /____  >
             /_____/        \/            \/          \/ "
echo
echo -e  ${PURP}\########################################################${END}
echo "Disclaimer: file supplied must be a text log produced from a Cowrie Honypot using the default log format"
echo
echo -e "Gathering info from the log file: ${CYAN}$LOGFILE${END}"
echo -e "Log covers from $STARTTIME to $ENDTIME"
echo -e "Total New Connections: ${GREEN}$TOTALCONNECTIONS${END}"
echo -e "Lines of Commands Issues by Attackers: ${GREEN}$TOTALCOMMANDS${END}"
echo -e "Total Uniqe Atackking IP Addresses: ${GREEN}$UNIQEIPS${END}"
echo -e "The most aggresive attacker from the log was: ${RED}$MOSTAGGRESSIVE${END}"
echo -e "Connection count by most agressive attacker: ${GREEN}$AGGRESSORCOUNT${END}"
echo "File SHA-256 hashes of files uploaded by attackers:"
for i in $FILES; do
        echo -e "     ${CYAN}$i${END}"
done;
echo
else
echo
echo "Useage: CowrieLogStats.sh [FILE]"
echo "  This script will produce some pretty output from a cowrie honeypot log."
echo "  Information obtained using this tool can be used as a launching point for further "
echo "  research and analysis."
echo -e "       ${RED}It seems either a file was not supplied, or an invalid path was supplied${END}"
echo
fi
