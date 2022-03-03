#!/bin/bash

akeyless get-dynamic-secret-value -n "/Azure MongoDB Atlas - Admin" --json true >| creds.json

for i in `seq 30 -1 1` ; do echo -e "$i " ; sleep 1 ; done

echo -e "\n\nCommand to execute :\n"
echo "mongosh \"mongodb+srv://cluster0.o8nlo.mongodb.net/admin\" --apiVersion 1 --username \"$(cat creds.json | jq -r '.user')\" --password \"$(cat creds.json | jq -r '.password')\""
