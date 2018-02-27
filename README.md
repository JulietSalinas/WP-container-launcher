# Super Simple Wordpress Docker Container Launcher

## Purpose

This project makes it extremely easy to spin up docker containers running
Wordpress.  

This tool makes use of the bitnami-docker-wordpress (with modifications), found
here:  
https://github.com/bitnami/bitnami-docker-wordpress

It is also preconfigured to use jwilder's awesome automated ngnix proxy for
Docker containers:  
https://github.com/jwilder/nginx-proxy


### Prerequisites:
 * docker
 * docker-compose


## Instructions:

Clone the repo:
`git clone https://github.com/JulietSalinas/WP-container-launcher.git`

Enter the directory:
`cd WP-container-launcher/`

Start the nginx proxy (this only has to be done once):
`./proxy-setup.sh`

Spin up a container:
`./wp-setup.sh yourdomain.com email@address.com`
(if you do not provide arguments, you will be prompted for the info)

The script will copy the WP container template to a folder named after your
domain name.  It will generate a random PW for the MySQL root user, and a
random PW for the "Administrator" Wordpress user.  

It will then insert the proper values into the docker-compose.yml, and spin up
your containers.  When it is done spinning up your containers, it will spit out
info on the WP install, including your Administrator password.

Once the container is running, within a minute or two, the nginx-proxy will pick
up on the changes and add the new Virtualhost to its configuration.  If you have
DNS for your domain pointed to your server's IP, it should resolve at this
point and bring you to a fresh Wordpress install.

Additional output is logged to ./wp-setup.log

You can spin up as many containers as you like with different domain names.

### Other Tasks

If you wish to stop containers for a given domain, you can run:
`./wp-setup.sh domainname.com down`

If you wish to tear down a container and all volumes, you can run:
`./wp-setup.sh domainname.com destroy`

## TODO

Configure custom Wordpress image with a preselected set of plugins -
Specifically, a good import/export plugin, since this project is mainly focused
on migration of existing sites to Docker quickly and easily.

Created configurable backup system to track and make backups of created volumes.
