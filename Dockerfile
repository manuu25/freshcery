# Freshcery — PHP + Apache image for Render (Docker runtime)
FROM php:8.1-apache

# PDO MySQL driver (the app talks to MySQL only through PDO)
RUN docker-php-ext-install pdo_mysql

# This is legacy PHP-7 code: on PHP 8 it emits "undefined array key" warnings
# that would otherwise leak into the HTML. Hide them in production, keep logging.
RUN { \
      echo "display_errors = Off"; \
      echo "error_reporting = E_ERROR | E_PARSE"; \
      echo "log_errors = On"; \
    } > /usr/local/etc/php/conf.d/zz-app.ini

# App code
COPY . /var/www/html/
RUN chown -R www-data:www-data /var/www/html

# Render assigns the listening port via $PORT; rewrite Apache to use it at boot.
COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
CMD ["apache2-foreground"]
