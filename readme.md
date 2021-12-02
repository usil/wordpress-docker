# Wordpress With Docker

Wordpress  5.7.2 + Docker

> Just the file **wp-config.php** is the only difference with the official version https://wordpress.org/wordpress-5.7.2.tar.gz

# Requirements

- docker
- docker-compose

# One-Click Step

The following command will deploy tha database, import the .sql and start the wordpress:

```
docker-compose up -d
```

# Detailed Steps

- build
- variables
- run

## Build

```
docker build -t wordpress:5.7.2 .
```

## Variables

Traditionally wordpress configurations are performed with manuall modifications in **wp-config.php** file. With docker this is not acceptable anymore. This docker version use **getenv()** instead hardcoded values in wp-config. This made it possible to configure the entire wordpress with environment variables. If you find more low level convigurations, I advice to use **getenv()** and pass the value as environment variable. Currently these are the required variables:

| name  | description  |
|---|---|
|WP_SITEURL| ip or domain, when you are deploying to a real server|
|WP_HOME| ip or domain, when you are deploying to a real server|
|ENABLE_HTTPS| "true" or "false". Used when your ip or domain has a valid https certificate. |
|DB_HOST| mysql database host. If your db use another port instead 3306, append it to the host 10.10.10.20:3307|
|DB_USER| mysql database user   |
|DB_PASSWORD| password related to the mysql user  |
|DB_NAME| database name  |
|AUTH_KEY| random value  |
|SECURE_AUTH_KEY|random value |
|NONCE_KEY|random value |
|LOGGED_IN_KEY|random value |
|AUTH_SALT|random value |
|SECURE_AUTH_SALT| random value   |
|LOGGED_IN_SALT| random value  |
|NONCE_SALT| random value  |
|WP_DEBUG| "true" or "false". Used to find low level errors in wordpress  |
|DISABLE_WP_CRON| "true" or "false". Used to enable the cron |


Use this command `$(hostname -I| awk '{printf $1}')` to get the ip of the host in which database is running. If you are  using a remote mysql (gcp, aws, azure, etc) set the public domain or ip  in **DB_HOST** var

## Run


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

## Run with remote variables

Required variables could be configured remotely to avoid shell access.

```
docker run -d --name wordpress -it --rm -p 80:80 \
-e CONFIGURATOR_GET_VARIABLES_FULL_URL=http://foo.com/api/v1/variables?application=wordpress \
-e CONFIGURATOR_AUTH_HEADER=apiKey:changeme \
-e TZ=America/Lima wordpress:5.7.2
```

# Open wordpress

Finally go to `http://localhost` and enter these credentials:

- user: admin
- password: 123456

Don't forget to change the password.

# Tips

- Low level errors in /var/log/apache2/error.log
- Set your preferred timezone in TZ variable

# Contributors

<table>
  <tbody>
    <td>
      <img src="https://avatars0.githubusercontent.com/u/3322836?s=460&v=4" width="100px;"/>
      <br />
      <label><a href="http://jrichardsz.github.io/">Richard Leon</a></label>
      <br />
    </td>    
  </tbody>
</table>
