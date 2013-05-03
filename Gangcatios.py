#!/usr/bin/env python
#-*-coding:UTF-8 -*-
import os
import sys
import platform
import conf
if not has_imported('pexpect'):
	try:
		import pexpect
	except ImportError:
		installer = System.GetInstaller()
		if (installer == 'apt-get') or (installer == 'zypper'):
			cmd = '%s install python-pexpect' % (installer)
		elif installer == 'yum':
			cmd = '$s install pexpect' % (installer)
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
	print all

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

class Expect:
	def ssh(self, ip, user, passwd, cmd):
		ssh = pexpect.spawn('ssh %s@%s "%s"' % (user, ip, cmd))
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

	def scp(self, ip, user, passwd, file = "index.html"):
		ssh = pexpect.spawn('scp %s %s@%s:~/ ' % (file, user, ip))
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