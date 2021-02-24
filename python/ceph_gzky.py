#!/usr/bin/env python
from __future__ import division
__metaclass__ = type
import commands

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


class Ceph:

    def command(self, item):
        self.item = item
        self.output = commands.getoutput(self.item).split('\n')
        return self.output
    
    def match(self, M, *N):
        color = Color()
        self.M = M
        len_output = len(self.output)
        for i in range(len_output) :
            if M not in self.output[i]:
                continue
            else:
                self.line = self.output[i].split()
                if N:
                   x = ''
                   a = [int(i) for i in N]
                   for i in a:
                       x = '%-10s%10s' % (x, self.line[i])
                       if i == a[-1]:
                          color.green(x.strip())
                else:
                   return self.line
 
    def skew(self, n1, *n2):
        N1 = self.line.index(self.M) + n1
        if n2:
            N2 = '%s' % n2
            N2 = N1 + int(N2)
            return self.line[N1:N2]
        else:
            return self.line[N1]
    
    def usage(self):
        if self.M == "Cpu":
           cpu_usage = self.line[1]
           return str(cpu_usage) + '%'
        elif self.M == "Mem:":
           Mem_used = self.line[2]
           Mem_total = self.line[1]
           Mem_usage = int(Mem_used) / int(Mem_total) * 100
           return '%.2f' % Mem_usage + '%'
        else:
           print "None"
