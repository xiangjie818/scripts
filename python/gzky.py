#!/usr/bin/env python
from __future__ import division
import commands

def red(n):
    print "\033[36m%s\033[0m" % n

def green(n):
    print "\033[32m%s\033[0m" % n

def purple(n):
    print "\033[35m%s\033[0m" % n

def format(item1,item2,item3,item4):
    return item1 + ': ' + item2 + ' ' * 4 + item3 + ': ' + item4

def ceph(item,num1,*num2):
    ceph_status = commands.getoutput("ceph -s").split()
    num = ceph_status.index(item)
    if num2:
        a = '%s' % num2
        b = num + num1
        c = num + int(a)
        return ceph_status[b:c]
    else:
        b = num + num1
        return ceph_status[b]

def used(x,y,z,*item):
    if not item:
       item = "osd"
    else:
       item = '%s' % item

    if item == "Memory":
       item = "cache"
       lines=commands.getoutput(x).split('\n')
       for i in range(len(lines)):
           if item not in lines[i]:
               continue
           else:
               mem_usage=int(lines[i].split()[y])  / int(lines[i].split()[z]) * 100
               green('%.2f' % mem_usage + '%')
    else:
       lines=commands.getoutput(x).split('\n')
       for i in range(len(lines)):
           if item not in lines[i]:
               continue
           else:
               green(lines[i].split()[y] + ' ' * 4 + lines[i].split()[z])
