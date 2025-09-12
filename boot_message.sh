[Unit]
Description=Log message at system boot
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/boot_message.sh
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
