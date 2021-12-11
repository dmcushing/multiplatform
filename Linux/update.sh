#!/bin/bash

source /multiplatform/Linux/functions.sh

clear
is_super_user

echo -e "Beginning Update..."
git -C /multiplatform/ config user.email "dave@davecushing.ca"
git -C /multiplatform/ config user.name "Dave Cushing"

git -C /multiplatform/ stash
git -C /multiplatform/ pull origin
chmod 755 /multiplatform/Linux/*.sh
echo -e "Done Update."