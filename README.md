#Wordpress to Docker Container Import Tool

##Purpose

This is a project to automate the creation of Wordpress Docker containers and
the subsequent import of site content, configuration, and other data from a WP
installation hosted elsewhere.

This tool makes use of the bitnami-docker-wordpress (with modifications), found
here:  
https://github.com/bitnami/bitnami-docker-wordpress

It is also preconfigured to use jwilder's awesome automated ngnix proxy for
Docker containers:  
https://github.com/jwilder/nginx-proxy


###Required Information:
 * Virtualhost - the URL you want your new container to use.
 * Remote WP install URL
 * MySQL credentials, DB name, hostname
 * ssh/ftp credentials for remote host
 * Path to WP install on remote host


This is currently a non-functional work-in-progress
