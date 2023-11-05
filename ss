services:
  cachet:
    build:
      context: .
      args:
        - cachet_ver=v2.3.15
    entrypoint: /bin/sh -c "while ! nc -z mysql 3306; do sleep 1; done; php /var/www/html/artisan cachet:install"
    environment:
      - APP_ENV=production
      - APP_DEBUG=false
      - APP_KEY=base64:ZmZrc2V3b2ZkNHF1bmxxYWpqNWN0NWY0Nm14YmRmOTU=
      - DB_CONNECTION=mysql  # Change this to MySQL
      - DB_HOST=mysql  # Use the service name for the MySQL container
      - DB_DATABASE=cachet_db  # Your desired database name
      - DB_USERNAME=user  # Your MySQL username
      - DB_PASSWORD=rac  # Your MySQL password
      - APP_LOG=single
    ports:
      - "8000:80"
    depends_on:
      - mysql  # Use the service name for the MySQL container
    networks:
      - cachet-net


  mysql:
    image: mysql:5.7  # Use an appropriate MySQL version
    environment:
      - MYSQL_ROOT_PASSWORD=rac
      - MYSQL_DATABASE=cachet_db  # Should match the DB_DATABASE in the cachet service
      - MYSQL_USER=user  # Your MySQL username, should match DB_USERNAME in the cachet service
      - MYSQL_PASSWORD=rac  # Your MySQL password, should match DB_PASSWORD in the cachet service
    networks:
      - cachet-net


networks:
  cachet-net:
    driver: bridge
