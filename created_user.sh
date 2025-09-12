  GNU nano 7.2                 created_user.sh *                        #!/bin/bash

# Script to create 5 new users for devteam
# Requires sudo/root privileges

# Define variables
GROUP_NAME="devteam"
USERS=("Francis" "Blessing" "Manjaws" "Zipporah" "emma")
DEFAULT_PASSWORD="ChangeMe123!"  # Users will be forced to change this >
# Function to check if script is run as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root or with sudo privileges"
        exit 1
    fi
}

# Function to create group if it doesn't exist
create_group() {
    if ! getent group "$GROUP_NAME" > /dev/null; then
        echo "Creating group: $GROUP_NAME"
        groupadd "$GROUP_NAME"
    else
        echo "Group $GROUP_NAME already exists"
    fi
}

# Function to create users
create_users() {
      for user in "${USERS[@]}"; do
        # Check if user already exists
        if id "$user" &>/dev/null; then
            echo "User $user already exists. Skipping..."
            continue
        fi

        # Create user with home directory and add to devteam group
        6Cecho "Creating 1;6Cuser: $user"
        useradd -m -G "$GROUP_NAME" "$user"

        # Set password
        echo "Setting password for $user"
        echo "$user:$DEFAULT_PASSWORD" | chpasswd

        # Force password change on first login
        echo "Forcing password change on first login for $user"
        chage -d 0 "$user"

        echo "User $user created successfully and added to $GROUP_NAME"
        echo "----------------------------------------"
    done
}

# Function to display summary
display_summary() {
    echo ""
    echo "=== SETUP SUMMARY ==="
    echo "Group created: $GROUP_NAME"
      echo "Users created: ${USERS[*]}"
    echo "Default password: $DEFAULT_PASSWORD"
    echo ""
    echo "All users are required to change their password on first logi>    echo "To test a user login: su - username"
    echo "========================================"
}

# Main execution
main() {
    echo "Starting user creation script..."
    echo "========================================"

    check_root
    create_group
    create_users
    display_summary

    echo "Script completed successfully!"
}

# Run main function
main "$@"
