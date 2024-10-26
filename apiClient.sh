#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <IP_ADDRESS> <PORT>"
    exit 1
fi

IP=$1
PORT=$2

{ 
    echo "Aloha!"
    read response
    if [ "$response" != "Oh, no." ]; then
        echo "Handshake failed"
        exit 1
    fi
    
    echo "My name is $(whoami)"
    echo "*.*.*.*"
    read ready_response
    if [ "$ready_response" != "Ready." ]; then
        echo "Handshake failed"
        exit 1
    fi
    
    echo "Enter command (e.g., GetAlbumBySong <song_name>):"
    while read command; do
        echo "$command" 
        read server_response
        echo "$server_response"
    done
} | socat - TCP:$IP:$PORT
