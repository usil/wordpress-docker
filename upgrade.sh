#!/bin/bash
set -e

workspace_id=$(uuidgen)
mkdir -p /tmp/$workspace_id
git clone git@github.com:usil/wordpress-docker.git /tmp/$workspace_id


rm -rf /tmp/$workspace_id/wordpress
mkdir /tmp/$workspace_id/wordpress

# download the latest wordpress
curl https://wordpress.org/latest.zip -o /tmp/wp-latest.zip
unzip /tmp/wp-latest.zip -d /tmp/$workspace_id
rm /tmp/wp-latest.zip

cp /tmp/$workspace_id/index.php /tmp/$workspace_id/wp-failsafe/index_default.php

echo "workspace : /tmp/$workspace_id"
