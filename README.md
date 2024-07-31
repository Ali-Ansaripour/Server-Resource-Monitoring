# Multi-Server Disk Usage Monitoring Script

## Overview

This Bash script monitors the disk usage of a specified directory on multiple remote servers via SSH. If the disk usage on any server exceeds a defined threshold, the script sends an email alert. This is useful for maintaining the health of multiple servers and ensuring they do not run out of disk space unexpectedly.

## Features

- Monitors disk usage of a specified directory on multiple servers
- Configurable disk usage threshold
- Sends email alerts when disk usage exceeds the threshold on any server

## Prerequisites

- Bash shell
- SSH access to the remote servers
- `mail` utility for sending email alerts

## Installation

1. **Clone the Repository**

    ```bash
    git clone https://github.com/Ali-Ansaripour/Remote-Disk-usage-Mon/
    cd /Remote-Disk-usage-Mon/
    ```

2. **Ensure Required Packages are Installed**

    Install the necessary packages using your package manager.

    ```bash
    pkg update && pkg upgrade
    pkg install openssh
    pkg install mailutils
    ```

## Configuration

1. **Edit the Script**

    Open the script file `script.sh` in a text editor:

    ```bash
    nano script.sh
    ```

2. **Customize the Variables**

    - **`SERVERS`**: List the servers to monitor.
    - **`MONITOR_DIR`**: Specify the directory to monitor.
    - **`THRESHOLD`**: Set the disk usage percentage threshold.
    - **`SSH_USER`**: Set the SSH username for remote access.
    - **`ALERT_EMAIL`**: Set the email address to receive alerts.

    ```bash
    # List of remote servers
    SERVERS=("192.168.1.1" "192.168.1.2" "192.168.1.3")

    # Directory to monitor
    MONITOR_DIR="/path/to/directory/"

    # Threshold percentage
    THRESHOLD=80

    # SSH user
    SSH_USER="your_ssh_username"

    # Email to send alerts to
    ALERT_EMAIL="your.email@example.com"
    ```

3. **Save and Close the File**

    Press `Ctrl + X`, then `Y`, and `Enter` to save and exit the editor.

## Usage

1. **Make the Script Executable**

    ```bash
    chmod +x script.sh
    ```

2. **Run the Script**

    ```bash
    ./script.sh
    ```

## Script Details

The script works as follows:

1. It iterates over each server listed in the `SERVERS` array.
2. For each server, it checks the current disk usage of the specified directory using the `df` command over SSH.
3. If the disk usage exceeds the specified `THRESHOLD`, it sends an email alert to `ALERT_EMAIL`.
4. It prints the current disk usage status to the terminal.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request if you have any suggestions for improvements or new features.




