# bash_scripts

This repository contains a collection of bash scripts for various tasks such as downloading images, playing a trivia game, backing up data, and analyzing web server logs. Each script is designed to perform a specific function and can be run independently or together depending on the needs of the user.

## Scripts Included

###  1. `analyze_logfile.sh`

An analysis script for Apache web server log files. It extracts and reports various statistics such as successful requests, requests for .zip files, IP addresses, and the most requested URL from Firefox browsers.

Usage: `./analyze_logfile.sh <path_to_logfile>`
Permissions: `chmod +x analyze_logfile.sh`

###  2. `backup_script.sh`

A backup script that creates compressed archives of specified directories and also backs up a database using a separate script (`backup_db.sh` which is a replica for **mysqldump**). The script logs errors and exits with a specific exit code indicating the type of failure.

Usage: `./backup_script.sh`
Permissions: `chmod +x backup_script.sh`

###  3. `trivia.sh`

A trivia game script that fetches questions from the Open Trivia Database API and presents them to the user. The user can answer questions and earn points based on the difficulty of the question.

Usage: `./trivia.sh`
Permissions: `chmod +x trivia.sh`

###  4. `image_thumbnail.sh`

This script attempts to download images from a specified API endpoint and creates thumbnails for each downloaded image. It stops after  10 unsuccessful attempts to download an image.

Usage: `./image_thumbnail.sh`
Permissions: `chmod +x image_thumbnail.sh`


## Prerequisites

- **Bash**: Ensure that you have Bash installed on your system to execute these scripts.
- **jq**: The `trivia.sh` script uses `jq` to parse JSON responses from the API. Make sure `jq` is installed.
- **dialog**: The `trivia.sh` script uses `dialog` for creating menus and message boxes. Install `dialog` if you plan to use this script.
- **tar**: The `backup_script.sh` script uses `tar` to create archives. Ensure `tar` is available on your system.
- **bzip2**: The `backup_script.sh` script uses `bzip2` to compress files. Make sure `bzip2` is installed.
- **grep**: The `analyze_logfile.sh` script uses `grep` to analyze log files. Confirm that `grep` is installed.

## Usage

To use any of the scripts, navigate to the directory containing the script and execute it with the appropriate permissions. For example: `chmod +x image_thumbnail.sh`