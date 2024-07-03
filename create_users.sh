#!/bin/bash

# Log file location
LOG_FILE="/var/log/user_management.log"
PASSWORD_FILE="/var/secure/user_passwords.csv"

# Ensure the log file exists
touch $LOG_FILE
chmod 600 $LOG_FILE

# Ensure the password file exists and set appropriate permissions
mkdir -p /var/secure
touch $PASSWORD_FILE
chmod 600 $PASSWORD_FILE

# Function to generate random passwords
generate_password() {
    openssl rand -base64 12
}

# Log a message
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> $LOG_FILE
}

# Check if the script is run with an argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <name-of-text-file>"
    exit 1
fi

# Read the file line by line
while IFS=';' read -r username groups; do
    # Remove leading/trailing whitespace from username and groups
    username=$(echo $username | xargs)
    groups=$(echo $groups | xargs)

    # Check if user already exists
    if id -u $username >/dev/null 2>&1; then
        log "User $username already exists. Skipping creation."
        continue
    fi

    # Create user with a personal group
    useradd -m -s /bin/bash $username
    log "User $username created."

    # Set up home directory permissions
    chmod 700 /home/$username
    chown $username:$username /home/$username
    log "Set up home directory for $username."

    # Generate random password and set it
    password=$(generate_password)
    echo "$username:$password" | chpasswd
    echo "$username,$password" >> $PASSWORD_FILE
    log "Password set for $username."

    # Assign user to additional groups
    if [ -n "$groups" ]; then
        IFS=',' read -r -a group_array <<< "$groups"
        for group in "${group_array[@]}"; do
            # Remove whitespace from group name
            group=$(echo $group | xargs)

            # Create group if it doesn't exist
            if ! getent group $group >/dev/null; then
                groupadd $group
                log "Group $group created."
            fi

            # Add user to group
            usermod -aG $group $username
            log "User $username added to group $group."
        done
    fi

done < "$1"

# Ensure password file is only readable by the owner
chmod 600 $PASSWORD_FILE

echo "User creation process completed. Check $LOG_FILE for details."
