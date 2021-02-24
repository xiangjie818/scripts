#!/bin/bash
reposync -nd -p /media/zxj/zxj/repo/foreman -r foreman
reposync -nd -p /media/zxj/zxj/repo/foreman -r foreman-plugins
reposync -nd -p /media/zxj/zxj/repo/foreman -r foreman-rails
reposync -nd -p /media/zxj/zxj/repo/ -r puppet5
#reposync -nd -p /media/zxj/zxj/repo/ -r epel
reposync -nd -p /media/zxj/zxj/repo/ -r rh-ruby 

createrepo --update /media/zxj/zxj/repo/foreman/foreman
createrepo --update /media/zxj/zxj/repo/foreman/foreman-plugins
createrepo --update /media/zxj/zxj/repo/foreman/foreman-rails
createrepo --update /media/zxj/zxj/repo/puppet5
#createrepo --update /media/zxj/zxj/repo/epel
createrepo --update /media/zxj/zxj/repo/rh-ruby

