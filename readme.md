# Wordpress With Docker

Wordpress 6.4.2 + Php 7.4.33 + Apache 2.0 + Mysql 5.7 + Docker

![image](https://github.com/usil/wordpress-docker/assets/3322836/a142012f-a21a-4fe0-88fc-de4bfc5b69be)

> Just the file wp-config.php, docker files and readme.md are the only difference with the official version https://wordpress.org/download/

## Requirements

- docker
- docker compose

## One Click Step

The following command will deploy the database, import the .sql and start the wordpress:

```
docker compose up -d --build
```

For manually docker build and run, read this [document](https://github.com/usil/wordpress-docker/wiki/Run-with-docker)

## Try it

Finally go to `http://localhost/wp-admin` and enter these credentials:

- user: admin
- password: ohUCE0BX2t5TFT9Ygw

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
|TABLES_PREFIX| used if your tables has another prefix than **wp_** |
|PREVIOUS_DOMAIN| used to fix urls which are hardcoded into files or db. Example if developer used http://localhost/xamp/foo but the real domain will be http://enterprise.com put this value http://localhost/xamp/foo into PREVIOUS_DOMAIN and http://enterprise.com in WP_SITEURL. If database is not hardcoded, don't use this value|
|FAILSAFE_MODE| enabe or rollback. This will replace the default index.php with a version in which some validations are performed and its error are showed in the html to help the debuggers in case of 502 similar errors|


## Tips

- Low level errors in /var/log/apache2/error.log
- Set your preferred timezone in TZ variable

## Upgrade

To update this wordpress with the official latest wordpress follow this [document](https://github.com/usil/wordpress-docker/wiki/Upgrade-for-contribution)

## Prodcuction usage

For production usage I advice you:

- Don't use docker compose.
- :warning: Change the admin password and mail in the first login :warning:
- Build this docker wordpress image and push it to your private docker registry
- Create your mysql database as a service like AWS RDS (automatic backups)
- In the wordpress server just download the docker image (docker pull ...) and run it with the desired variables.
- Use a s3 plugin for user uploads. If you don't to that, if the docker container dies , al your images, videos will die too. With s3 or similar plugin, you will have the maximun portability opening the possibility to an easy and clean verticall scaling
  - Suggested AWS S3 plugin: https://wordpress.org/plugins/amazon-s3-and-cloudfront/
  - An option could be use docker volumes to mount a folder in the host with the ** /wp-content/uploads** in the container.
- Use remote variables with some configuration manager like [configurator](https://github.com/jrichardsz-software-architect-tools/configurator) or [similars](https://github.com/jrichardsz-software-architect-tools/configurator/wiki/Alternatives)
- To avoid manually docker runs, use some CI server like [Jenkins](https://www.jenkins.io/) and a container orchestrator like [AWS Elastic Beanstalk](https://aws.amazon.com/elasticbeanstalk/) or Kubernetes.

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
