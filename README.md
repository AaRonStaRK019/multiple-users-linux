Here is a README for the `create_users.sh` script:

---

# Create Users Script

This bash script, `create_users.sh`, reads a text file containing employee usernames and group names, creates users and groups as specified, sets up home directories with appropriate permissions and ownership, generates random passwords for the users, and logs all actions to `/var/log/user_management.log`. Additionally, the generated passwords are securely stored in `/var/secure/user_passwords.csv`.

## Features

- Reads a text file with usernames and group names.
- Creates users with personal groups.
- Adds users to specified groups.
- Sets up home directories with proper permissions.
- Generates random passwords for users.
- Logs all actions performed.
- Stores generated passwords securely.

## Prerequisites

- You need to have sudo privileges to run this script.
- Ensure you have `openssl` installed for generating random passwords.

## Usage

1. **Prepare the text file**:
   - Create a text file with the format `username; groups` where groups are separated by commas. 
   - Example `user_groups.txt`:

     ```
     alice; sudo,developers,web
     bob; admin,devops
     charlie; www-data
     dave; sudo
     eve; dev,admin,www-data
     ```

2. **Run the script**:
   - Ensure the script is executable:

     ```bash
     chmod +x create_users.sh
     ```

   - Run the script with your text file as an argument:

     ```bash
     sudo ./create_users.sh user_groups.txt
     ```

## Script Details

### Log File

- The script logs all actions to `/var/log/user_management.log`.

### Password File

- The generated passwords are stored securely in `/var/secure/user_passwords.csv`.

### Error Handling

- The script checks for existing users and skips their creation if they already exist.

### Adding Users to Groups

- Each user is added to their own group (same as their username) in addition to any groups specified in the text file.

### Home Directory Setup

- Each user’s home directory is created with `700` permissions and proper ownership.

## Example Output

Upon running the script, check the following files:

1. **Log file**: `/var/log/user_management.log` for the log of all actions performed.
2. **Password file**: `/var/secure/user_passwords.csv` to view the usernames and their generated passwords (only accessible by the root user).

## Sample Commands

### Creating Users from Text File

```bash
sudo bash create_users.sh user_groups.txt
```

### Viewing the Log File

```bash
sudo cat /var/log/user_management.log
```

### Viewing the Password File

```bash
sudo cat /var/secure/user_passwords.csv
```
---