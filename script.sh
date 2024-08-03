#!/bin/bash

# Configuration
SERVERS=("192.168.1.1" "192.168.1.2" "192.168.1.3")
MONITOR_DIR="/path/to/directory/"
DISK_THRESHOLD=80
CPU_THRESHOLD=80
RAM_THRESHOLD=80
SSH_USER="your_ssh_username"
EMAIL_FROM="aliansaripour69@gmail.com"
EMAIL_TO="ansaripourali.org@gmail.com"
LOG_FILE="/tmp/server_monitor_$(date +%F_%T).log"

# Create data files
for SERVER in "${SERVERS[@]}"; do
  mkdir -p /tmp/${SERVER}
  touch /tmp/${SERVER}/disk_usage.txt
  touch /tmp/${SERVER}/cpu_usage.txt
  touch /tmp/${SERVER}/ram_usage.txt
done

# Function to check disk usage
check_disk_usage() {
  local SERVER=$1
  local TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
  local USAGE=$(ssh ${SSH_USER}@${SERVER} "df -h ${MONITOR_DIR} | grep -vE '^Filesystem' | awk '{ print \$5 }' | sed 's/%//g'")
  echo "${TIMESTAMP} ${USAGE}" >> /tmp/${SERVER}/disk_usage.txt
  echo "Disk Usage on ${SERVER}: ${USAGE}%"
  if [ ${USAGE} -gt ${DISK_THRESHOLD} ]; then
    echo "Alert: Disk usage on ${SERVER} is above threshold! Current usage: ${USAGE}%"
    return 1
  fi
  return 0
}

# Function to check CPU usage
check_cpu_usage() {
  local SERVER=$1
  local TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
  local USAGE=$(ssh ${SSH_USER}@${SERVER} "top -bn1 | grep 'Cpu(s)' | sed 's/.*, *\([0-9.]*\)%* id.*/\1/' | awk '{print 100 - $1}'")
  echo "${TIMESTAMP} ${USAGE}" >> /tmp/${SERVER}/cpu_usage.txt
  echo "CPU Usage on ${SERVER}: ${USAGE}%"
  if [ ${USAGE} -gt ${CPU_THRESHOLD} ]; then
    echo "Alert: CPU usage on ${SERVER} is above threshold! Current usage: ${USAGE}%"
    return 1
  fi
  return 0
}

# Function to check RAM usage
check_ram_usage() {
  local SERVER=$1
  local TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
  local USAGE=$(ssh ${SSH_USER}@${SERVER} "free | grep Mem | awk '{print \$3/\$2 * 100.0}'")
  echo "${TIMESTAMP} ${USAGE}" >> /tmp/${SERVER}/ram_usage.txt
  echo "RAM Usage on ${SERVER}: ${USAGE}%"
  if [ ${USAGE} -gt ${RAM_THRESHOLD} ]; then
    echo "Alert: RAM usage on ${SERVER} is above threshold! Current usage: ${USAGE}%"
    return 1
  fi
  return 0
}

# Function to generate graphs
generate_graphs() {
  local SERVER=$1
  local OUTPUT_PREFIX="/tmp/${SERVER}_usage"
  local DATA_DIR="/tmp/${SERVER}"

  # Generate Disk Usage Graph
  echo "Generating Disk Usage graph for ${SERVER}..."
  gnuplot << EOF
set terminal pngcairo size 800,600
set output '${OUTPUT_PREFIX}_disk.png'
set title "Disk Usage on ${SERVER}"
set xlabel "Time"
set ylabel "Usage (%)"
set xdata time
set timefmt "%Y-%m-%d %H:%M:%S"
set format x "%H:%M"
set grid
plot '${DATA_DIR}/disk_usage.txt' using 1:2 with linespoints title 'Disk Usage'
EOF

  # Generate CPU Usage Graph
  echo "Generating CPU Usage graph for ${SERVER}..."
  gnuplot << EOF
set terminal pngcairo size 800,600
set output '${OUTPUT_PREFIX}_cpu.png'
set title "CPU Usage on ${SERVER}"
set xlabel "Time"
set ylabel "Usage (%)"
set xdata time
set timefmt "%Y-%m-%d %H:%M:%S"
set format x "%H:%M"
set grid
plot '${DATA_DIR}/cpu_usage.txt' using 1:2 with linespoints title 'CPU Usage'
EOF

  # Generate RAM Usage Graph
  echo "Generating RAM Usage graph for ${SERVER}..."
  gnuplot << EOF
set terminal pngcairo size 800,600
set output '${OUTPUT_PREFIX}_ram.png'
set title "RAM Usage on ${SERVER}"
set xlabel "Time"
set ylabel "Usage (%)"
set xdata time
set timefmt "%Y-%m-%d %H:%M:%S"
set format x "%H:%M"
set grid
plot '${DATA_DIR}/ram_usage.txt' using 1:2 with linespoints title 'RAM Usage'
EOF
}

# Function to send email
send_email() {
  local SERVER=$1
  local SUBJECT="Server ${SERVER} Usage Alert"
  local MESSAGE="Disk, CPU, or RAM usage on ${SERVER} has exceeded the threshold. Attached are the details and graphs."
  
  echo -e "Subject: ${SUBJECT}\n\n${MESSAGE}" | msmtp --from=${EMAIL_FROM} -t ${EMAIL_TO} -a /tmp/${SERVER}_disk.png -a /tmp/${SERVER}_cpu.png -a /tmp/${SERVER}_ram.png
}

# Monitor each server
for SERVER in "${SERVERS[@]}"; do
  echo "Checking server ${SERVER}..."

  # Check Disk Usage
  check_disk_usage ${SERVER}
  DISK_STATUS=$?

  # Check CPU Usage
  check_cpu_usage ${SERVER}
  CPU_STATUS=$?

  # Check RAM Usage
  check_ram_usage ${SERVER}
  RAM_STATUS=$?

  # Generate Graphs
  generate_graphs ${SERVER}

  # Send Email if any threshold is exceeded
  if [ ${DISK_STATUS} -ne 0 ] || [ ${CPU_STATUS} -ne 0 ] || [ ${RAM_STATUS} -ne 0 ]; then
    send_email ${SERVER}
  else
    # Log details for servers that are okay
    echo "Disk, CPU, and RAM usage on ${SERVER} are within acceptable limits." >> ${LOG_FILE}
  fi
done
