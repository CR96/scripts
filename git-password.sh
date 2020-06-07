#!/bin/sh

# Print GitHub password to the terminal using bitwarden-cli
bw login $(git config user.email)
bw get password github.com
