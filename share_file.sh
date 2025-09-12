#!/bin/bash                                                                                                                                     # Script to create shared directory with specific permissions and ACL   # Requires sudo/root privileges                                                                                                                 # Variables                                                             SHARED_DIR="/shared_data"                                               GROUP_NAME="devteam"                                                    EXTRA_USER="auditor"  # Example extra user with read-only access                                                                                # Function to check if script is run as root                            check_root() {                                                              if [[ $EUID -ne 0 ]]; then                                                  echo "This script must be run as root or with sudo privileges"          exit 1                                                              fi                                                                  }                                                                                                                                               # Function to check if group exists                                     check_group() {                                                             if ! getent group "$GROUP_NAME" > /dev/null; then                           echo "Error: Group $GROUP_NAME does not exist. Please create it>        exit 1                                                              fi                                                                  }                                                                                                                                               # Function to check if extra user exists                                check_extra_user() {                                                        if ! id "$EXTRA_USER" &>/dev/null; then
        echo "Warning: Extra user $EXTRA_USER does not exist. Creating >
          useradd -m "$EXTRA_USER"
        echo "Please set a password for $EXTRA_USER using: passwd $EXTR>    fi                                                                  }

# Function to create shared directory
create_shared_dir() {
    echo "Creating shared directory: $SHARED_DIR"

    # Create directory if it doesn't exist
    if [[ ! -d "$SHARED_DIR" ]]; then
        mkdir -p "$SHARED_DIR"
        echo "Directory created: $SHARED_DIR"
    else
        echo "Directory already exists: $SHARED_DIR"
    fi

    # Set ownership and group
    chown root:"$GROUP_NAME" "$SHARED_DIR"

    # Set permissions: rwx for owner, rwx for group, --- for others
    chmod 770 "$SHARED_DIR"

    # Set SGID bit so new files inherit group ownership
    chmod g+s "$SHARED_DIR"

    # Set sticky bit to prevent users from deleting others' files
    chmod +t "$SHARED_DIR"
    
    echo "Set ownership and permissions for $SHARED_DIR"
}

# Function to set ACL for extra user
set_acl() {
    echo "Setting ACL permissions for extra user: $EXTRA_USER"

    # Grant read and execute permissions to extra user using ACL
    setfacl -m u:"$EXTRA_USER":rx "$SHARED_DIR"

    # Set default ACL for new files/directories (optional)
    setfacl -d -m u:"$EXTRA_USER":rx "$SHARED_DIR"

    echo "ACL permissions set for $EXTRA_USER"
}

# Function to verify permissions
verify_permissions() {
    echo ""
    echo "=== VERIFYING PERMISSIONS ==="

    # Check directory permissions
    echo "Directory permissions:"
    ls -ld "$SHARED_DIR"

    # Check ACL settings
      echo ""
    echo "ACL settings:"
    getfacl "$SHARED_DIR"

    # Create test files to verify behavior
    echo ""
    echo "Creating test files to verify permissions..."

    # Create a test file as root
    touch "$SHARED_DIR/test_file_root"
    echo "Test content" > "$SHARED_DIR/test_file_root"
    chown root:"$GROUP_NAME" "$SHARED_DIR/test_file_root"
    chmod 660 "$SHARED_DIR/test_file_root"

    echo "Test files created. Permissions should be:"
    echo "- Group members can read/write but not delete others' files"
    echo "- Extra user $EXTRA_USER can read only"
    echo "- Others have no access"
}

# Function to display usage instructions
display_instructions() {
    echo ""
    echo "=== USAGE INSTRUCTIONS ==="
    echo "Shared directory: $SHARED_DIR"
    echo "Group with read/write access: $GROUP_NAME"
    echo "Extra user with read-only access: $EXTRA_USER"
    echo ""
    echo "To test permissions:"
    echo "1. Login as a devteam user: su - devuser1"
   echo "2. Try to create a file: touch $SHARED_DIR/test_file"
    echo "3. Try to delete someone else's file (should fail)"
    echo "4. Login as $EXTRA_USER: su - $EXTRA_USER"
    echo "5. Try to read files: cat $SHARED_DIR/test_file_root"
    echo "6. Try to create files (should fail)"
    echo ""
    echo "Note: The sticky bit (+t) prevents users from deleting others>    echo "      even if they have write permission to the directory."
}

# Main execution
main() {
    echo "Starting shared directory setup..."
    echo "========================================"

    check_root
    check_group
    check_extra_user
    create_shared_dir
    set_acl
    verify_permissions
    display_instructions

    echo "========================================"
    echo "Setup completed successfully!"
}

# Run main function
main "$@" 