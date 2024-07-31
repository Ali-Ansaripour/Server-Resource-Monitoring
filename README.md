# Local Disk Usage Monitoring Script

## Overview

This Bash script monitors the disk usage of specified directories on a local machine and sends an email alert if the disk usage exceeds a defined threshold. It helps in ensuring that your system does not run out of disk space unexpectedly.

## Features

- Monitors disk usage of specified directories
- Configurable disk usage threshold
- Sends email alerts when disk usage exceeds the threshold

## Prerequisites

- Bash shell
- `mail` utility for sending email alerts
- SSH access is not required for this local version

## Installation

1. **Clone the Repository**

    ```bash
    git clone https://github.com/Ali-Ansaripour/Remote-Disk-usage-Mon/
    cd your-repo-name
    ```

2. **Ensure Required Packages are Installed**

    Install the necessary packages using your package manager. For Termux, use:

    ```bash
    pkg update && pkg upgrade
    pkg install coreutils
    pkg install mailutils
    ```

## Configuration

1. **Edit the Script**

    Open the script file `local_disk_usage_monitor.sh` in a text editor:

    ```bash
    nano local_disk_usage_monitor.sh
    ```

2. **Customize the Variables**

    - **`DIRECTORIES`**: List the directories you want to monitor.
    - **`THRESHOLD`**: Set the disk usage percentage threshold.
    - **`ALERT_EMAIL`**: Set the email address to receive alerts.

    ```bash
    # List of directories to monitor
    DIRECTORIES=("/" "/data" "/storage")

    # Threshold percentage
    THRESHOLD=80

    # Email to send alerts to
    ALERT_EMAIL="your-email@example.com"
    ```

3. **Save and Close the File**

    Press `Ctrl + X`, then `Y`, and `Enter` to save and exit the editor.

## Usage

1. **Make the Script Executable**

    ```bash
    chmod +x local_disk_usage_monitor.sh
    ```

2. **Run the Script**

    ```bash
    ./local_disk_usage_monitor.sh
    ```

## Script Details

The script works as follows:

1. It iterates over each directory listed in the `DIRECTORIES` array.
2. For each directory, it checks the current disk usage using the `df` command.
3. If the disk usage exceeds the specified `THRESHOLD`, it sends an email alert to `ALERT_EMAIL`.
4. It prints the current disk usage status to the terminal.


