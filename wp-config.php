<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

//move wordpress from localhost to another wordpress's domain
//https://stackoverflow.com/q/68232620/3957754
if (getenv('WP_SITEURL')!=null){
  define('WP_SITEURL', getenv('WP_SITEURL'));
}
if (getenv('WP_HOME')!=null){
  define('WP_HOME', getenv('WP_HOME'));
}

if ( getenv('ENABLE_HTTPS')  === "true" ) {
  define( 'FORCE_SSL_ADMIN', true );
  $_SERVER['HTTPS']='on';
}


// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', getenv('DB_NAME'));

/** MySQL database username */
define('DB_USER', getenv('DB_USER'));

/** MySQL database password */
define('DB_PASSWORD', getenv('DB_PASSWORD'));

/** MySQL hostname */
define('DB_HOST', getenv('DB_HOST'));

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         getenv('WP_AUTH_KEY'));
define('SECURE_AUTH_KEY',  getenv('WP_SECURE_AUTH_KEY'));
define('LOGGED_IN_KEY',    getenv('WP_LOGGED_IN_KEY'));
define('NONCE_KEY',        getenv('WP_NONCE_KEY'));
define('AUTH_SALT',        getenv('WP_AUTH_SALT'));
define('SECURE_AUTH_SALT', getenv('WP_SECURE_AUTH_SALT'));
define('LOGGED_IN_SALT',   getenv('WP_LOGGED_IN_SALT'));
define('NONCE_SALT',       getenv('WP_NONCE_SALT'));

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
if (getenv('TABLES_PREFIX')!=null){
  $table_prefix  = getenv('TABLES_PREFIX');
}else{
  $table_prefix  = 'wp_';
}

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
if ( getenv('WP_DEBUG')  === "true" ) {
  define( 'WP_DEBUG', true );
}else{
  define( 'WP_DEBUG', false );
}

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
  define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');

//Disable WP Cron
if ( getenv('DISABLE_WP_CRON')  === "true" ) {
  define( 'DISABLE_WP_CRON', true );
}else{
  define( 'DISABLE_WP_CRON', false );
}
