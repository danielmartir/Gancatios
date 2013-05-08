#!/bin/sh
cd /tmp
yum install -y libpng libpng-devel libart_lgpl libart_lgpl-devel gcc-c++ make python-devel pcre python pcre-devel libxslt expat expat-devel freetype httpd php php-devel php-mysql php-gd automake autoconf libtool mysql mysql-devel mysql-server cairo cairo-devel pango pango-devel
#install apr
wget http://mirror.bit.edu.cn/apache/apr/apr-1.4.6.tar.gz
tar zxf apr-1.4.6.tar.gz
cd apr-1.4.6
./configure;make;make install
cd ..
#install confuse
wget http://download.savannah.gnu.org/releases/confuse/confuse-2.7.tar.gz
tar zxf confuse-2.7.tar.gz
cd confuse-2.7
./configure CFLAGS=-fPIC --disable-nls ;make;make install 
cd ..
#install rrdtool
wget http://oss.oetiker.ch/rrdtool/pub/rrdtool-1.4.7.tar.gz
tar zxf rrdtool-1.4.7.tar.gz
cd rrdtool-1.4.7
./configure --prefix=/opt/rrdtool;make;make install
cd ..
#install ganglia
wget http://downloads.sourceforge.net/project/ganglia/ganglia%20monitoring%20core/3.5.0/ganglia-3.5.0.tar.gz?r=http://sourceforge.net/projects/ganglia/files/ganglia/monitoring/core%2F3.5.0%2F&ts=1367578523&use_mirror=jaist
tar zxf ganglia-3.3.1.tar.gz
cd ganglia-3.3.1
#server
./configure --prefix=/opt/modules/ganglia --with-static-modules --enable-gexec --enable-status --with-gmetad --with-python=/usr --with-librrd=/opt/rrdtool-1.4.5 --with-libexpat=/usr --with-libconfuse=/usr/local --with-libpcre=/usr/local
#client
#./configure --prefix=/opt/modules/ganglia --enable-gexec --enable-status --with-python=/usr --with-libapr=/usr/local/apr/bin/apr-1-config --with-libconfuse=/usr/local --with-libexpat=/usr --with-libpcre=/usr
make; make install
cd gmetad
cp gmetad.conf /opt/modules/ganglia/etc/
cp gmetad.init /etc/init.d/gmetad
sed -i "s/^GMETAD=\/usr\/sbin\/gmetad/GMETAD=\/opt\/modules\/ganglia\/sbin\/gmetad/g" /etc/init.d/gmetad
chkconfig --add gmetad
ip route add 239.2.11.71 dev eth1
service gmetad start