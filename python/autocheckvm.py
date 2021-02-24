#!/usr/bin/python
# coding=utf-8
from __future__ import division
__metaclass__ = type
import commands,sys,os

class Color:
    def black(self, para):
        print "\033[30m%s\033[0m" % para
    def red(self, para):
        print "\033[31m%s\033[0m" % para
    def green(self, para):
        print "\033[32m%s\033[0m" % para
    def yellow(self, para):
        print "\033[33m%s\033[0m" % para
    def blue(self, para):
        print "\033[34m%s\033[0m" % para
    def purple(self, para):
        print "\033[35m%s\033[0m" % para
    def azure(self, para):
        print "\033[36m%s\033[0m" % para 
    def white(self, para):
        print "\033[37m%s\033[0m" % para

color = Color()

os.system("ansible rhev -m script -a '/root/kvm_shutdown/domain_list.exp | grep running &> /tmp/vmcheck' -i /root/kvm_shutdown/hosts &> /dev/null")
os.system("ansible rhev -m fetch -a 'src=/tmp/vmcheck dest=/tmp/vmcheck_all' -i /root/kvm_shutdown/hosts &> /dev/null")

hosts = ['192.168.6.4', '192.168.6.5', '192.168.6.6', '192.168.6.7', '192.168.6.8', '192.168.6.9']
for host in hosts :
  ok_vm = []
  not_ok_vm = []
  VM = commands.getoutput("cat /tmp/vmcheck_all/%s/tmp/vmcheck | awk '{print $2}'" % host).split('\n')
  for vm in VM :
    IP = '192.168.6.' + vm.split('-')[-1]
    CMD = commands.getoutput('ansible all -i "%s," -m ping' % IP)
    if 'SUCCESS' in CMD :
      ok_vm.append(vm)
    else:
      not_ok_vm.append(vm)

  color.purple('#' * 20 + " 物理机 %s 的检测结果 " % host + '#' * 20)
  color.blue("正常运行的虚拟机")

  for vm in ok_vm :
    IP = '192.168.6.' + vm.split('-')[-1]
    LEN = len(vm) + len(IP)
    SPACE_LEN = 71 - LEN
    color.green(vm + ' ' * SPACE_LEN + IP)

  if not_ok_vm != []:
    color.blue("有异常的虚拟机")
    for vm in not_ok_vm :
      IP = '192.168.6.' + vm.split('-')[-1]
      LEN = len(vm) + len(IP)
      SPACE_LEN = 71 - LEN
      color.red(vm + ' ' * SPACE_LEN + IP)
