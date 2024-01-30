#!/bin/bash
set -e

ENV_FILE=env
ENV_HOME=/var

function echo_log {
  DATE='date +%Y/%m/%d:%H:%M:%S'
  echo `$DATE`" $1"
}

function download_env_variables {

  if [[ "x${CONFIGURATOR_GET_VARIABLES_FULL_URL}" = "x"  || "x${CONFIGURATOR_AUTH_HEADER}" = "x" ]]; then
    echo_log ""
    echo_log "Configurator variables are not provided. Variables will not be downloaded"
    return 0
  fi

 echo_log ""
 echo_log "starting to download environment variables"
 http_response=$(curl -s -o curl_response_file -w "%{http_code}" -H "$CONFIGURATOR_AUTH_HEADER" ${CONFIGURATOR_GET_VARIABLES_FULL_URL})

 echo_log "download status:  $http_response"
 if [ $http_response == "200" ]; then
    mv curl_response_file $ENV_HOME/$ENV_FILE
    echo_log "exporting Environment Variables"
    source $ENV_HOME/$ENV_FILE
 else

    echo_log "download response: $(cat curl_response_file)"
    echo_log "new environment variables could not be obtained from remote service"

    if [ -e $ENV_HOME/$ENV_FILE ]; then
       echo_log "exporting old env variables"
       source $ENV_HOME/$ENV_FILE
    else
       echo_log "environment file not found: $ENV_HOME/$ENV_FILE"
       echo_log "if variables will not download, don't pass CONFIGURATOR_ variables and try again."
       exit 1
    fi
 fi

}

function replace_domain {
  if [[ -n "$PREVIOUS_DOMAIN" ]]
  then
    echo "replacing previous domain: $PREVIOUS_DOMAIN to new domain: $WP_SITEURL"
    wp search-replace $PREVIOUS_DOMAIN $WP_SITEURL --precise --recurse-objects --all-tables --allow-root
  fi
}

function set_permissions {
  mkdir -p /var/log/apache2/
  chmod -R 750 /var/log/apache2/
  chown -R www-data:www-data /var/log/apache2/
}

function enable_failsafe_mode {

  if [ "$FAILSAFE_MODE" == "" ];
  then
    # FAILSAFE_MODE is not configured
    return 0
  fi

  if [ "$FAILSAFE_MODE" == "enable" ];
  then
    cp wp-failsafe/index_failsafe.php /var/www/html/index.php
  else

    if [ "$FAILSAFE_MODE" == "rollback" ];
    then
      cp wp-failsafe/index_default.php /var/www/html/index.php
    fi  
    
  fi
}

function stats {  
  echo_log "disk" 
  df -h
  echo_log "ram"
  free -h
  echo_log "internet test connection"
  curl -Is http://www.google.com | grep 200
  if [[ ! "x${CONFIGURATOR_GET_VARIABLES_FULL_URL}" = "x"  && ! "x${CONFIGURATOR_AUTH_HEADER}" = "x" ]]; then
   echo_log "configurator test connection"
   configurator_domain=$(echo ${CONFIGURATOR_GET_VARIABLES_FULL_URL} | awk -F[/:] '{print $4}')
   curl -Is "$configurator_domain" | grep 302
  fi  
  
}


function start {
  echo "starting wordpress..."
  php -v
  source /etc/apache2/envvars
  exec apache2 -DFOREGROUND
}


########################
# Scripts starts here
########################
set_permissions
stats
download_env_variables
enable_failsafe_mode
replace_domain
start
