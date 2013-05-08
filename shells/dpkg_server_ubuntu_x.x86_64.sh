#!/usr/bin/env sh
apt-get -y -q install libcairo2 libcairo2-dev make automake autoconf libtool libxml2 libxml2-dev libxslt1-dev libpango1.0-0 libpango1.0-dev g++ g++-4.7 gettext cacti ganglia-modules-linux \
ganglia-monitor ganglia-webfrontend gmetad libganglia1 libganglia1-dev cacti-spine php5-ldap moreutils snmp-mibs-downloader snmpd libsnmp-base libsnmp-dev libsnmp15 nagios-plugins-standard \
nagios-images nagios3 nagios3-cgi nagios3-common nagios3-core nagios-snmp-plugins php5-cli apache2

chown -R www-data:www-data /var/lib/cacti

sed -i "s/AuthName \"Nagios Access\"/#AuthName \"Nagios Access\"/g" /etc/apache2/conf.d/nagios3.conf
sed -i "s/AuthType Basic/#AuthType Basic/g" /etc/apache2/conf.d/nagios3.conf
sed -i "s/AuthUserFile \/etc\/nagios3\/htpasswd.users/#AuthUserFile \/etc\/nagios3\/htpasswd.users/g" /etc/apache2/conf.d/nagios3.conf
sed -i "s/AuthUserFile \/etc\/nagios\/htpasswd.users/#AuthUserFile \/etc\/nagios\/htpasswd.users/g" /etc/apache2/conf.d/nagios3.conf
sed -i "s/require valid-user/#require valid-user/g" /etc/apache2/conf.d/nagios3.conf

echo "Alias /ganglia /usr/share/ganglia-webfrontend

<Directory /usr/share/ganglia-webfrontend>
        Options +FollowSymLinks
        AllowOverride None
        order allow,deny
        allow from all

        AddType application/x-httpd-php .php

        <IfModule mod_php5.c>
                php_flag magic_quotes_gpc Off
                php_flag short_open_tag On
                php_flag register_globals Off
                php_flag register_argc_argv On
                php_flag track_vars On
                # this setting is necessary for some locales
                php_value mbstring.func_overload 0
                php_value include_path .
        </IfModule>

        DirectoryIndex index.php
</Directory>" > /etc/apache2/conf.d/ganglia.conf

service apache2 restart

echo "###############################"
echo "#			Access Cacti		#"
echo "# http://your_ip/cacti		#"
echo "# Username: admin				#"
echo "# Password: admin				#"
echo "# Change password for the 	#"
echo "# login action				#"
echo "###############################"
echo "#			Access Nagios		#"
echo "# http://your_ip/nagios3		#"
echo "###############################"
echo "#			Access Ganglia		#"
echo "# http://your_ip/ganglia		#"
echo "###############################"