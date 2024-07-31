#!/bin/bash

#List of remote servers
SERVERS=("192.168.1.1" "192.168.1.2" "192.168.1.3")

#Directory to monitor
MONITOR_DIR="/path/to/directory/"

#Threshold percentage
THRESHOLD=80

#SSH user
SSH_USER="youre ssh user name"

#EMAIL to send alerts:
ALERT_EMAIL="youre.email@example.com"

#Function to check disk usage on a remote servers
check_dick_usage() {
  local SERVER=$1
  local USAGE=$(ssh ${SSH_USER}@${SERVER} "df -h ${MONITOR_DIR} | grep -vE '^Filesystem' | awk '{ print \$5 }' | sed 's/%//g' ")

  if [ ${USAGE} -gt ${THRESHOLD} ]; then
    echo "Alert: Disk usage on ${SERVER} is above threshold! Current usage: ${USAGE}%"
    echo "Disk usage on ${SERVER} has exceed the threshold of ${THRESHOLD}%. Current usage: ${USAGE}%. " | mail -s "Disk usage Alert for ${SERVER}" ${ALERT_EMAIL}
  else
    echo "Disk usage on ${SERVER} is under control. Current usage: ${USAGE}% "
  fi
  }

  #Iterate over the list of serers and check dick usage
  for SERVER in "${SERVERS[@]}";
    do
      echo "Cheking dick usage on ${SERVER}..."
      check_disk_usage ${SERVER}
    done

    
