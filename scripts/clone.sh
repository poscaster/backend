#!/bin/bash

set -e

mkdir poscaster
cd poscaster

git clone git@github.com:poscaster/backend.git
git clone git@github.com:poscaster/frontend.git

echo "Your clone is now ready at ./poscaster/{back,front}end"
