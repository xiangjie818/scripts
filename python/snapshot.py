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


host = commands.getoutput("virsh list --all | awk 'NR!=1&&NR!=2 {print $2}'").split('\n')
host.remove('')

color.purple('可选主机:')
for i in host:
    color.blue(i)

while True:
    select_host = raw_input("\033[35m请选择主机：\033[0m")
    if select_host not in host:
        print "\033[31m主机 %s 不存在，请重新选择：\033[0m" % select_host
    else:
        break

class snapshot:
    def Snapshot_list(self):
        color.purple("可用快照：")
        self.snapshot_list = commands.getoutput("virsh snapshot-list %s | awk 'NR!=1&&NR!=2{print $0}'" % (select_host)).split('\n')
        self.snapshot_list.remove('')
        if self.snapshot_list == []:
            color.red("主机 %s 没有任何快照。程序退出……" % (select_host))
            sys.exit(0)

        for i in range(len(self.snapshot_list)):
            color.blue(self.snapshot_list[i].strip())

    def Create(self):
        snapshot_list = commands.getoutput("virsh snapshot-list %s | awk 'NR!=1&&NR!=2{print $1}'" % (select_host)).split('\n')
        snapshot_list.remove('')
        snapshot_name = raw_input("\033[35m请输入快照名称：\033[0m")
        if snapshot_name in snapshot_list:
            color.red("快照 %s 已经存在，无法重复创建。" % (snapshot_name))
            sys.exit(0)
        else:
            os.system("virsh snapshot-create-as %s %s > /dev/null" % (select_host,snapshot_name))
            return "快照 %s 创建成功。" % snapshot_name

    def Revert(self):
        revert_snapshot = raw_input("\033[35m请选择要进行恢复的快照：\033[0m")
        os.system("virsh snapshot-revert %s %s > /dev/null" % (select_host,revert_snapshot))
        return "快照 %s 恢复成功。" % revert_snapshot
         
    def Delete(self):
        delete_snapshot = raw_input("\033[35m请选择要进行删除的快照：\033[0m")
        os.system("virsh snapshot-delete %s %s > /dev/null" % (select_host,delete_snapshot))
        return "快照 %s 删除成功。" % delete_snapshot

    def Exit(self):
        return "程序退出……"


snap = snapshot()

width = 80
symbol="\033[35m*\033[0m"
print symbol * width
color.purple('以下是可供选择的操作选项： ')
print symbol * width
color.blue('1）创建快照')
color.blue('2）恢复快照')
color.blue('3）删除快照')
color.blue('4）退出')
print symbol * width

option = raw_input("\033[35m请选择你要进行的操作：\033[0m")

if option == '1':
   color.green(snap.Create())
elif option == '2':
   snap.Snapshot_list()
   color.green(snap.Revert())
elif option == '3':
   snap.Snapshot_list()
   color.green(snap.Delete())
else:
   color.green(snap.Exit())
