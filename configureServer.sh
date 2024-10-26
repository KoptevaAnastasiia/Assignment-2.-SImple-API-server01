#!/bin/bash


apt-get update
apt-get install -y socat


cat << 'EOF' > /usr/bin/apiServer.sh
#!/bin/bash 

log_file="/var/log/apiServer.log"
touch $log_file

while true; do
    { 
        echo "Oh, no."
        read client_name
        echo "And broadcast address of your network?"
        read broadcast_address
        echo "Ready."
        
       
        while read command; do 
            if [[ $command == GetAlbumBySong* ]]; then
                song=${command#GetAlbumBySong }
                album=$(grep "$song" db.txt | cut -d';' -f3)
                if [ -z "$album" ]; then
                    echo "No data"
                else
                    echo "Album for $song: $album"
                fi
            fi
             
        done

        echo "May the Force be with you!"
    } | socat -v TCP-LISTEN:4242,fork -
done >> $log_file 2>&1
EOF

chmod +x /usr/bin/apiServer.sh


cat << EOF > /etc/systemd/system/apiService.service
[Unit]
Description=API Server

[Service]
ExecStart=/usr/bin/apiServer.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl enable apiService
systemctl start apiService
