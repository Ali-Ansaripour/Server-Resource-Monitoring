# Server Resource Monitoring and Alert Script


## Contents

1. [Introduction](#introduction)
2. [Features](#features)
3. [Prerequisites](#prerequisites)
   - [Installation Commands](#installation-commands)
4. [Configuration](#configuration)
   - [Variables to Customize](#variables-to-customize)
5. [Setting Up `msmtp` for Email Alerts](#setting-up-msmtp-for-email-alerts)
6. [Usage](#usage)
7. [Outputs](#outputs)
8. [Troubleshooting](#troubleshooting)
9. [Contributing](#contributing)
10. [Author](#author)


## Introduction
This Bash script monitors `DISK`, `CPU`, and `RAM` usage on remote servers and generates alerts via email when usage exceeds specified thresholds. Additionally, the script generates graphs for these metrics over time and sends them as email attachments. Logs are also saved locally for servers that are operating within acceptable limits.

## Features

- **Monitor Disk, CPU, and RAM Usage**: Periodically check disk, CPU, and RAM usage on remote servers.
- **Threshold-Based Alerts**: Send email alerts when any of the metrics exceed specified thresholds.
- **Graph Generation**: Generate time-series graphs for disk, CPU, and RAM usage.
- **Logging**: Log usage details for servers that are within acceptable limits.

## Prerequisites

Before running the script, ensure your environment meets the following requirements:

1. **SSH Access**: The script uses SSH to connect to remote servers. Ensure that SSH access is configured and working.
2. **Dependencies**:
   - **OpenSSH Client**: For SSH access to remote servers.
   - **Gnuplot**: For generating graphs.
   - **msmtp**: For sending email alerts.

### Installation Commands

- **Debian/Ubuntu**:
    ```bash
    sudo apt-get update
    sudo apt-get install openssh-client gnuplot msmtp
    ```

- **CentOS/RHEL**:
    ```bash
    sudo yum install openssh-clients gnuplot msmtp
    ```

- **macOS**:
    ```bash
    brew install openssh gnuplot msmtp
    ```

## Configuration

You need to customize several variables in the script before using it. Open the script in a text editor and adjust the following parameters:

### Variables to Customize

1. **Server List**:
    ```bash
    SERVERS=("192.168.1.1" "192.168.1.2" "192.168.1.3")
    ```
    - Replace these with the IP addresses or hostnames of the servers you wish to monitor.

2. **Monitoring Directory**:
    ```bash
    MONITOR_DIR="/path/to/directory/"
    ```
    - Set this to the directory you want to monitor for disk usage.

3. **Thresholds**:
    ```bash
    DISK_THRESHOLD=80
    CPU_THRESHOLD=80
    RAM_THRESHOLD=80
    ```
    - Adjust these values to set the percentage thresholds for disk, CPU, and RAM usage.

4. **SSH User**:
    ```bash
    SSH_USER="your_ssh_username"
    ```
    - Set this to the username you use to SSH into the remote servers.

5. **Email Configuration**:
    ```bash
    EMAIL_FROM="your_email@gmail.com"
    EMAIL_TO="recipient_email@gmail.com"
    ```
    - Set `EMAIL_FROM` to the Gmail address you want to send emails from.
    - Set `EMAIL_TO` to the recipient's email address.

## Setting Up msmtp for Email Alerts

To send emails using Gmail, you'll need to configure `msmtp` with your Gmail credentials:

1. **Create msmtp Config File**:
   - Create a configuration file at `~/.msmtprc`:
     ```bash
     touch ~/.msmtprc
     chmod 600 ~/.msmtprc
     ```

2. **Add the Following Configuration**:
   ```bash
   account default
   host smtp.gmail.com
   port 587
   auth on
   user your_email@gmail.com
   password your_app_specific_password
   tls on
   tls_trust_file /etc/ssl/certs/ca-certificates.crt
   from your_email@gmail.com

   # Set a default account
   account default : default

3. **App-Specific Password:**
   - For security reasons, you should use an app-specific password from Google for msmtp. Generate one [here](https://support.google.com/mail/answer/185833?hl=en).
   - After generating your app-specific password, replace `your_app_specific_password` in the `~/.msmtprc` file with the password you generated.
   - `user`: Change `your_email@gmail.com` to the same email address you just updated in from.
   - `from`: Change `your_email@gmail.com` to the email address you want to use to send alerts 

## Usage
**Running the Script**
Once you've configured the script and installed the necessary dependencies, you can run the script manually or set it up as a cron job for periodic monitoring.

1. **Manual Execution:**
  ```bash
  ./main.sh
  ```

2. **Set Up a Cron Job:**
   - To run the script every hour, for example, add the following line to your crontab:
    ```bash
    0 * * * * /path/to/main.sh 
    ```
   - Open the crontab file with:
    ```bash
    crontab -e 
    ```

## Outputs
1.**Alerts:**
   - If any server exceeds the defined thresholds, an email alert is sent with usage details and attached graphs.

2.**Graphs:**
   - The generated graphs show the resource usage over time for disk, CPU, and RAM.

3.**Logs:**
   - The script saves logs of normal server operations in a file, allowing you to review server health even when no alerts are triggered.


## Troubleshooting 
   - `SSH Issues:` Ensure you can SSH into your servers without being prompted for a password. Consider setting up SSH keys for passwordless login.

**Setting It Up**

   - To set up passwordless SSH, you can follow these steps:
1. Generate an SSH key pair on your local machine (if you haven't already) :
     ```bash
     ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
     ```
3. Copy your public key to the remote server :
     ```bash
     ssh-copy-id username@remote_server_ip
     ```  
5. Test the connection :
     ```bash
     ssh username@remote_server_ip
     ```
     
   - If everything is set up correctly, you should be able to SSH into the server without being prompted for a password.


   - `msmtp Errors:` If emails aren't sending, check your `~/.msmtprc` configuration and make sure you're using an app-specific password for Gmail.
   - `Gnuplot Errors:` If graphs aren't generating, verify that gnuplot is installed and check for any syntax errors in the graphing section of the script.

## Contributing
If you'd like to contribute, please fork the repository and use a feature branch. Pull requests are welcome.


## Author

**Created by Ali Ansaripour.** 
- For any questions or support, feel free to reach out to me at `ansaripourali.org@gmail.com`












