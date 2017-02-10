#/bin/bash

if [ -z $1 ]; then
	echo "What is the name (URL) of your site?"
	read SITENAME
else
	SITENAME=$1
fi

if [ -z $2 ]; then
	echo "What email address would you like for the admin user of your site?"
	read EMAILADDR
elif [ $2 = "down" ]; then
        echo "Shutting down $SITENAME"
        docker-compose -f $SITENAME/docker-compose.yml down
	exit 0
elif [ $2 = "destroy" ]; then
	echo "Destroying container and volumes"
	docker-compose -f $SITENAME/docker-compose.yml down
	VOLNAME=`echo $SITENAME|tr -d '.'`
	docker volume rm ${VOLNAME}_apache_data 
	docker volume rm ${VOLNAME}_mariadb_data
	docker volume rm ${VOLNAME}_php_data
	docker volume rm ${VOLNAME}_wordpress_data
	rm -rf $SITENAME
	exit 0
else
	EMAILADDR=$2
	fi

echo "Generating secure passwords."
MYSQLPASS=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w12 | head -n1)
WPPASS=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w12 | head -n1)

echo "Copying container template."
rsync -avz --exclude .git ./wp-template/* $SITENAME  >> ./wp-setup.log 2>&1

echo "Writing variables to docker-compose.yml"
sed -i "s/- VIRTUAL_HOST=/- VIRTUAL_HOST=$SITENAME/g" $SITENAME/docker-compose.yml
sed -i "s/- WORDPRESS_BLOG_NAME=/- WORDPRESS_BLOG_NAME=$SITENAME/g" $SITENAME/docker-compose.yml
sed -i "s/- WORDPRESS_PASSWORD=/- WORDPRESS_PASSWORD=$WPPASS/g" $SITENAME/docker-compose.yml
sed -i "s/- WORDPRESS_EMAIL=/- WORDPRESS_EMAIL=$EMAILADDR/g" $SITENAME/docker-compose.yml
sed -i "s/- MARIADB_PASSWORD=/- MARIADB_PASSWORD=$MYSQLPASS/g" $SITENAME/docker-compose.yml
sed -i "s/- MARIADB_ROOT_PASSWORD=/- MARIADB_ROOT_PASSWORD=$MYSQLPASS/g" $SITENAME/docker-compose.yml

echo "Spinning up containers..."
docker-compose -f $SITENAME/docker-compose.yml up -d >> ./wp-setup.log 2>&1

echo "If you've already pointed your DNS here, you should be able to log into your WP dashboard with the info below"
echo "URL: http://$SITENAME/wp-admin/"
echo "Username: Administrator"
echo "Password: $WPPASS"
echo "Administrator email: $EMAILADDR"


