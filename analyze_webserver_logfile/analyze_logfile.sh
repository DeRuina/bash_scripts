#! /usr/bin/env bash

# Analyzing A Log File From An Apache Webserver

# How many requests have been answered with status "200" (successfully)?

success=$(grep --color -E -c '( 200 )' "$1")
echo "1. Successful requests: ${success}"

# How many GET requests have been issued to .zip files?

zip=$(grep --color -c '.zip' "$1")
echo "2. zip files requests issued: ${zip}"

# Extraxt IPv4 & IPv6 addresses and check if same addresses request multiple time or all requests come from unique IP?

# IPv4
ipv4=$(grep --color -oE '^([0-9]{1,3}\.){3}[0-9]{1,3}' "$1")
echo -e "IPv4\n${ipv4}" > IPv4.txt

 
# IPv6
ipv6=$(grep --color -oE '^([[:alnum:]]{1,4}:){7}[[:alnum:]]{1,4}' "$1")
echo -e "IPv6\n${ipv6}" > IPv6.txt


# check for duplicates
echo "3. IPv4 & IPv6 address can be found in the files."
for duplicated in IPv4.txt IPv6.txt; do
  found=$(uniq -dc "${duplicated}" | sort)
  base=$(basename -s .txt "${duplicated}")
  if [[ -n "${found}" ]]; then
    echo "There are multiple ${base} requests done by:${found}"
  else 
    echo "There are no ${base} multiple requests by the same address"
  fi
done

# What is the most requested URL from Firefox browsers?

value=$(uniq -c <  <(grep --color -E 'Firefox' "$1" | grep --color -oE ' /[a-z]*/[a-z]*\.[a-z]* ' | sort) |
 grep --color -E '[0-9]' | sort | tail -1 | grep -oE '[[:digit:]]*')
url=$(uniq -c <  <(grep --color -E 'Firefox' "$1" | grep --color -oE ' /[a-z]*/[a-z]*\.[a-z]* ' | sort) |
 grep --color -E '[0-9]' | sort | tail -1 | grep -oE '[[:lower:]]*/[[:lower:]]*/[[:lower:]]*')
 echo "4. The most requested URL is ${url}. It was requested ${value} times" 