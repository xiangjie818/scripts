#!/usr/bin/env python
import os,shutil,string

def mkdir(dest_dir):
    a_z = string.ascii_lowercase
    for i in range(len(a_z)):
        file_dest_dir = os.path.join(dest_dir,a_z[i])
        if os.path.exists(file_dest_dir):
           continue
        else:
           os.mkdir(file_dest_dir)

def move(src_dir,dest_dir):
    os.chdir(src_dir)
    src_file = os.listdir(src_dir)
    for i in range(len(src_file)):
        file_dest_dir = os.path.join(dest_dir,src_file[i][0].lower())
        file_cwd = os.path.join(file_dest_dir,src_file[i])

        if os.path.exists(file_cwd):
           continue
        elif os.path.isdir(src_file[i]):
           continue
        else:
           shutil.move(src_file[i],file_dest_dir)

def copy(src_dir,dest_dir):
    os.chdir(src_dir)
    src_file = os.listdir(src_dir)
    for i in range(len(src_file)):
        file_dest_dir = os.path.join(dest_dir,src_file[i][0].lower())
        file_cwd = os.path.join(file_dest_dir,src_file[i])

        if os.path.isdir(src_file[i]):
           continue
        else:
           shutil.copyfile(src_file[i],file_dest_dir)

mkdir('/myrepo/')
move('/repo','/myrepo/')
