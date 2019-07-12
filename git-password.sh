#!/bin/sh

# Print GitHub password to the terminal using lastpass-cli
lpass login --color=auto $(git config user.email)
lpass show Developer/GitHub
