#!/bin/bash
set -e

function start {
  php -v
  source /etc/apache2/envvars
  exec apache2 -DFOREGROUND
}

start
