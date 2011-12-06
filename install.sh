#! /usr/bin/env bash
# organize installer

cp organize.sh organize
chmod +x organize

echo "Installing organize to /usr/bin..."
sudo install organize /usr/bin

rm organize

echo "organize installed!"
