#!/bin/bash
for i in {96..194} ; do
    /root/ssh.exp 10.3.2.$i DZS@3qgc
done
