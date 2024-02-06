#!/usr/bin/env bash

# Creation of array

folders=(
    "./customers_data"
    "./inventory_data"
)

# Error function

log_error() {
    echo "$1" >&2
    echo "$1" >> backup.log
}


# Create the backups folder, archive and compress

if [[ ! -d backups ]]; then
    mkdir backups
fi
exit_code=0
date_str=$(date '+%m-%d')

for folder in "${folders[@]}"; do
    folder_basename=$(basename "${folder}")
    archive_path="backups/${folder_basename//_/-}-${date_str}.tar.bz2"
    
    if ! tar -cjf "${archive_path}" "${folder}"; then
        log_error "[ERROR]: Tar of ${folder} could not be created"
        exit_code=1
    fi
done

if ! ./backup_db.sh > "backups/orders-${date_str}.sql"; then
    log_error "[ERROR]: Creating the DB backup failed"
    exit_code=2
elif ! bzip2 -f "backups/orders-${date_str}.sql"; then
    log_error "[ERROR]: Compressing of the DB backup failed"
    exit_code=3
fi

exit ${exit_code}