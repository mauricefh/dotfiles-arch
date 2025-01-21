#!/usr/bin/env bash

# Search for text in all files in the current folder
ftext() {
    if [ -z "$1" ]; then
        echo "Usage: ftext <search_term>"
        return 1
    fi
    grep -iIHrn --color=always "$1" . | less -R
}

# Copy file with a progress bar
cpp() {
    if [ $# -ne 2 ]; then
        echo "Usage: cpp <source_file> <destination_file>"
        return 1
    fi
    if command -v pv &>/dev/null; then
        pv "$1" > "$2"
    else
        echo "Error: 'pv' command not found. Install it with your package manager."
        return 1
    fi
}

# Go up a specified number of directories (e.g., `up 3`)
up() {
    limit=${1:-1}
    for ((i = 0; i < limit; i++)); do
        cd ..
    done
}

# IP address lookup
whatsmyip() {
    # Internal IP Lookup
    echo -n "Internal IP(s): "
    if command -v ip &>/dev/null; then
        ip -4 addr show scope global | grep inet | awk '{print $2}' | cut -d/ -f1 | xargs
    else
        ifconfig | grep 'inet ' | awk '{print $2}' | grep -v '127.0.0.1' | xargs
    fi

    # External IP Lookup
    echo -n "External IP: "
    curl -s ifconfig.me
}
alias whatismyip='whatsmyip'

# jq format with sprong
jqf() {
    local file="${1:-file.json}"    # Default to 'file.json' if no argument is given
    local filter="${2:-.}"          # Default to '.' if no filter is provided
    jq "$filter" "$file" | sponge "$file"
}

kak-lsp-restart() {
  pkill kak-lsp && kak-lsp
}

# dbx-upload() {
#     if [ -z "$1" ]; then
#         echo "Error: No path provided. Usage: dbx-upload <source-path> [destination-folder]" >&2
#         return 1
#     fi

#     if [ -z "$2" ]; then
#         # Only the first argument is provided
#         fd --full-path "$1" -x dbxcli put {}
#     else
#         # Both arguments are provided
#         dbxcli mkdir "$2" && fd --full-path "$1" -x dbxcli put "$2/{.}"
#     fi
# }

dbx-upload() {
    if [ -z "$1" ]; then
        echo "Error: No path provided. Usage: dbx-upload <source-path> [destination-folder]" >&2
        return 1
    fi

    # Check if the first argument is a single file
    if [ -f "$1" ]; then
        # Handle single file upload
        if [ -z "$2" ]; then
            # No destination folder provided, upload to root
            dbxcli put "$1"
        else
            # Destination folder provided
            echo "$1"
            echo "$2"
            
            dbxcli mkdir "$2" && dbxcli put "$1" "$2/"
        fi
    else
        # Handle multiple files or search pattern using fd
        if [ -z "$2" ]; then
            # No destination folder provided, upload files to root
            fd --full-path "$1" -x dbxcli put {}
        else
            # Destination folder provided
            dbxcli mkdir "$2" && fd --full-path "$1" -x echo "$2/{.}"
        fi
    fi
}

