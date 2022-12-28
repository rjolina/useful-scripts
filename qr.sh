#!/bin/bash

# Get the clipboard contents
clipboard=$(xsel -b)

# Generate a QR code from the clipboard contents
qrencode "$clipboard" -o /tmp/qr.png

# Display the QR code in full screen using imgcat
sxiv -s f -f /tmp/qr.png

