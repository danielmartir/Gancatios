#-*-coding:UTF-8 -*-
package_dir = './packages/'
log_dir = './logs/'
client_tmp_dir = '/tmp/'
ssh_port = '22'
script_dir = './shells/'

node_list = [
	{'ip':'192.168.1.1', 'user':'root', 'passwd':'123456', 'cmd':'sh /tmp/dpkg_client_ubuntu_x.x86_64.sh'},
	{'ip':'192.168.1.2', 'user':'root', 'passwd':'123456', 'cmd':'sh /tmp/dpkg_client_ubuntu_x.x86_64.sh'},
]