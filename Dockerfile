# Use an official Python runtime as a parent image
FROM python:3.10-slim

# Set the working directory
WORKDIR /ctf

# Install necessary tools
RUN apt-get update && apt-get install -y \
    apache2 \
    php \
    libapache2-mod-php \
    php-sqlite3 \
    sqlite3 \
    binutils \
    steghide \
    gcc \
    gdb

# Remove default index.html
RUN rm -f /var/www/html/index.html

# Copy web exploitation challenge
COPY web/ /var/www/html/

# Ensure the database is set up correctly
COPY web/database.sql /var/www/html/database.sql
RUN sqlite3 /var/www/html/database.db < /var/www/html/database.sql

# Ensure the default Apache configuration uses PHP index files
RUN echo "<Directory /var/www/html/> \n\
    Options Indexes FollowSymLinks \n\
    AllowOverride None \n\
    Require all granted \n\
</Directory> \n\
\n\
DirectoryIndex index.php \n\
\n\
<FilesMatch \.php$> \n\
    SetHandler application/x-httpd-php \n\
</FilesMatch>" > /etc/apache2/sites-available/000-default.conf

# Debug: List contents of /var/www/html
RUN ls -la /var/www/html

# Copy reverse engineering challenge source
COPY reverse/reverseme.c /ctf/reverseme.c

# Compile reverse engineering challenge and clean up
RUN gcc -g -o /ctf/reverseme /ctf/reverseme.c && rm /ctf/reverseme.c

# Copy forensics challenge
COPY forensics/not_a_flag.jpg /ctf/not_a_flag.jpg

# Copy cryptography challenge
COPY crypto/crypto.txt /ctf/crypto.txt

# Copy binary exploitation challenge source
COPY binary/vuln.c /ctf/vuln.c

# Compile binary exploitation challenge and clean up
RUN gcc -o /ctf/vuln /ctf/vuln.c -fno-stack-protector -z execstack && rm /ctf/vuln.c

# Expose web server port
EXPOSE 80

# Start Apache in the foreground
CMD ["apachectl", "-D", "FOREGROUND"]
