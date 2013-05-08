#!/usr/bin/env python
#-*-coding:UTF-8 -*-
import os
import sys
import platform
import conf
import subprocess

class System:
	def GetBranch(self):
		Branch = platform.dist()[0]
		return Branch
	def GetRelease(self):
		Release = platform.dist()[1]
		return Release
	def GetInstaller(self):
		if self.GetBranch() in ['Ubuntu', 'debian']:
			installer = 'apt-get'
		elif self.GetBranch() in ['redhat', 'fedora', 'centos']:
			installer = 'yum'
		elif self.GetBranch() in ['SuSE']:
			installer = 'zypper'
		else:
			installer = 'unknown'
		return installer

try:
	import pexpect
except ImportError:
	installer = System()
	if (installer.GetInstaller() == 'apt-get') or (installer.GetInstaller() == 'zypper'):
		cmd = '%s install python-pexpect' % (installer.GetInstaller())
	elif installer.GetInstaller() == 'yum':
		cmd = '$s install pexpect' % (installer.GetInstaller())
	else:
		cmd = 'echo "Not support yet:)"';
	try:
		fd = subprocess.Popen( cmd, shell=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE )
		out = fd.stdout.readlines()
		err = fd.stderr.readlines()
		all = out+err
		all = "".join(all)
	except OSError,e:
		all = "Cannot run command, Exception:"+e+os.linesep
	import pexpect
#print all

class Expect:
	def ssh(self, ip, port, user, passwd, cmd):
		ssh = pexpect.spawn('ssh -p %s %s@%s "%s"' % (port, user, ip, cmd))
		r = ''
		try:
			i = ssh.expect(['password:', 'continue connecting (yes/no)?'], timeout=5)
			#print i
			if i == 0 :
				ssh.sendline(passwd)
			elif i == 1:
				ssh.sendline('yes')
				ssh.expect('password:')
				ssh.sendline(passwd)
		except pexpect.EOF:
			ssh.close()
		else:
			r = ssh.read()
			ssh.expect(pexpect.EOF)
			ssh.close()
		return r

	def scp(self, ip, port, user, passwd, file = "index.html"):
		ssh = pexpect.spawn('scp -P %s %s %s@%s:/tmp ' % (port, file, user, ip))
		r= ''
		try:
			i = ssh.expect(['password:', 'continue connecting (yes/no)?'], timeout=5)
			if i == 0:
				ssh.sendline(passwd)
			elif i == 1:
				ssh.senline('yes')
				ssh.expect('password:')
				ssh.sendline(passwd)
		except pexpect.EOF:
			ssh.close()
		else:
			r = ssh.read()
			ssh.expect(pexpect.EOF)
			ssh.close()
		return r

packages = conf.package_dir
logs = conf.log_dir
tmp = conf.tmp_dir
port = conf.ssh_port
scripts = conf.script_dir
nodes = conf.node_list
expect = Expect()

os.system("sh " + scripts + "dpkg_server_ubuntu_x.x86_64.sh")

for i in range(len(nodes)):
	ip = nodes[i]['ip']
	user = nodes[i]['user']
	passwd = nodes[i]['passwd']
	#r = ssh.scp 
	r = expect.ssh(ip, port, user, passwd, 'ls -la /')
	print r