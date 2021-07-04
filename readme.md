# Wordpress With Docker

Current version 5.7.2

# Requirements

- Docker latest version (php 7.4)
- Mysql >= 5.6
  - Load the initial dump located in: database/dump-wordpress-5.7.2.sql
- clone this repository

# Steps

- build
- variables
- run

## Build

```
docker build -t wordpress:5.7.2 .
```

## Variables

I will not use docker compose to show the real configurations and be prepared to deploy in real environments in which wordpress and database are on different hosts. To have them in the same host is used in development or testing but is not recommended in  real scenarios.

Traditionally wordpress configurations are performed with manuall modifications in **wp-config.php** file. With docker this is not acceptable anymore. This docker version use **getenv()** instead hardcoded values in wp-config. This made it possible to configure the entire wordpress with environment variables. If you find more low level convigurations, I advice to use **getenv()** and pass the value as environment variable. Currently these are the required variables:

| name  | description  |
|---|---|
|DB_HOST| mysql database host  |
|DB_USER| database connection user   |
|DB_PASSWORD| password related to the user  |
|DB_NAME| database name  |
|AUTH_KEY| random value  |
|SECURE_AUTH_KEY|random value |
|NONCE_KEY|random value |
|LOGGED_IN_KEY|random value |
|AUTH_SALT|random value |
|SECURE_AUTH_SALT| random value   |
|LOGGED_IN_SALT| random value  |
|NONCE_SALT| random value  |
|WP_DEBUG| true or false. Used to find low level errors in wordpress  |
|DISABLE_WP_CRON| true or false. Used to enable the cron |
|WP_SITEURL| ip or domain. Used to deploy your wordpress from local to another domain|
|WP_HOME| ip or domain. Used to deploy your wordpress from local to another domain|


Use this command `$(hostname -I| awk '{printf $1}')` to get the ip of the host in which database is running. If you are  using a remote mysql (gcp, aws, azure, etc) set the public domain or ip  in **DB_HOST** var

### Run


```
export RANDOM_KEY=$(uuidgen)
```

```
docker run -d --name wordpress -it --rm -p 80:80 \
-e DB_HOST=10.10.10.10:3306 \
-e DB_USER=root \
-e DB_PASSWORD=secret \
-e DB_NAME=wordpress \
-e AUTH_KEY=$RANDOM_KEY \
-e SECURE_AUTH_KEY=$RANDOM_KEY \
-e NONCE_KEY=$RANDOM_KEY \
-e LOGGED_IN_KEY=$RANDOM_KEY \
-e AUTH_SALT=$RANDOM_KEY \
-e SECURE_AUTH_SALT=$RANDOM_KEY \
-e LOGGED_IN_SALT=$RANDOM_KEY \
-e NONCE_SALT=$RANDOM_KEY \
-e WP_DEBUG=true \
-e DISABLE_WP_CRON=true \
-e TZ=America/Lima wordpress:5.7.2
```

Finally go to `http://localhost` and enter these credentials:

- user: admin
- password: 123456

Don't forget to change the password.

# Tips

- Low level errors in /var/log/apache2/error.log
