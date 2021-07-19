FROM php:7.4-apache

RUN apt-get update && apt-get install -y \
        libzip-dev \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install \
        pdo_mysql \
        zip
RUN a2enmod rewrite headers

# change document root directory
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf \
    && sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# change expose port
ENV PORT 8080
RUN sed -ri -e 's!80!${PORT}!g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf

# install composer
COPY --from=composer:1.10.20 /usr/bin/composer /usr/bin/composer

COPY ./ /var/www/html

RUN composer install
RUN chown -R www-data /var/www/html

# run as non-root user
USER 33
