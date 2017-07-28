#!/bin/bash

if [ "$EUID" -eq 0 ]; then
   echo "You have just launched script from unknown source as a root without even looking what it does."
   echo "For what it worth we might be compromising your system right now."
   echo "Please, consider your safety. Further reading: http://tserong.github.io/sudo-wget/, https://www.seancassidy.me/dont-pipe-to-your-shell.html"
   echo "(Once you are condifent with this script, just re-run it as user)"
   exit 1
fi

set -e

mkdir poscaster
cd poscaster

git clone git@github.com:poscaster/backend.git
git clone git@github.com:poscaster/frontend.git

echo "Your clone is now ready at ./poscaster/{back,front}end"
