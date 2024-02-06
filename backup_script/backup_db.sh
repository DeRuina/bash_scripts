#!/usr/bin/env bash

# Declare arrays for each column of data

order_ids=(1001 1002 1003 1004 1005 1006 1007 1008)
product_ids=(4001 4002 4003 4002 4004 4001 4003 4004)
user_ids=(3001 3002 3003 3004 3001 3005 3002 3004)
quantities=(2 1 5 3 1 2 1 1)
prices=(29.99 19.99 9.99 19.99 49.99 29.99 9.99 49.99)
dates=('2048-08-01' '2049-04-15' '2040-11-23' '2041-03-09' '2042-07-05' '2043-12-12' '2044-02-21' '2045-06-18')

# Output table creation

echo "-- Create the orders table"
echo "CREATE TABLE orders ("
echo "    order_id INT AUTO_INCREMENT PRIMARY KEY,"
echo "    product_id INT NOT NULL,"
echo "    user_id INT NOT NULL,"
echo "    quantity INT NOT NULL,"
echo "    price DECIMAL(10, 2) NOT NULL,"
echo "    date DATE NOT NULL"
echo ");"
echo ""

# Start the insert statement

echo "-- Insert data into the orders table"
echo -n "INSERT INTO orders (order_id, product_id, user_id, quantity, price, date) VALUES"

# Loop through the arrays and generate the insert data

for (( i=0; i<${#order_ids[@]}; i++ ))
do
    echo -n "(${order_ids[$i]}, ${product_ids[$i]}, ${user_ids[$i]}, ${quantities[$i]}, ${prices[$i]}, '${dates[$i]}')"

# Add a comma if it's not the last record, otherwise end with a semicolon

    if [[ $i -lt $((${#order_ids[@]} - 1)) ]]; then
        echo ","
    else
        echo ";"
    fi
done
