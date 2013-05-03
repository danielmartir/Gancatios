#!/bin/sh
cd /tmp
#install apr
wget http://mirror.bit.edu.cn/apache/apr/apr-1.4.6.tar.gz
tar zxf apr-1.4.6.tar.gz
cd apr-1.4.6
./configure --prefix=/usr/local;make;make install
cd ..
#install confuse
wget http://download.savannah.gnu.org/releases/confuse/confuse-2.7.tar.gz
tar zxf confuse-2.7.tar.gz
cd confuse-2.7
./configure --prefix=/usr/local CFLAGS=-fPIC --disable-nls ;make;make install 
cd ..
#install rrdtool
wget http://oss.oetiker.ch/rrdtool/pub/rrdtool-1.4.7.tar.gz
tar zxf rrdtool-1.4.7.tar.gz
cd rrdtool-1.4.7
./configure --prefix=/usr/local ;make;make install
cd ..
#install ganglia
tar zxf ganglia-3.5.0.tar.gz
cd ganglia-3.5.0
#server
./configure --prefix=/usr/local/ganglia --with-static-modules --enable-gexec --enable-status --with-gmetad --with-python=/usr --with-librrd=/usr/local --with-libexpat=/usr --with-libconfuse=/usr/local --with-libpcre=/usr \
			--enable-status
#client
#./configure --prefix=/usr --enable-gexec --enable-status --with-python=/usr --with-libapr=/usr/local/apr/bin/apr-1-config --with-libconfuse=/usr/local --with-libexpat=/usr --with-libpcre=/usr
make; make install
cd gmetad
cp gmetad.conf /usr/local/ganglia/etc
cp gmetad.init /etc/init.d/gmetad
sed -i "s/^GMETAD=\/usr\/sbin\/gmetad/GMETAD=\/usr\/local\/ganglia\/sbin\/gmetad/g" /etc/init.d/gmetad
chkconfig --add gmetad
ip route add 239.2.11.71 dev eth1
service gmetad start