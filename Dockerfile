FROM hshar/webapp

WORKDIR /var/www/html

COPY . /var/www/html

RUN chown -R www-data:www-data /var/www/html || true

EXPOSE 80
