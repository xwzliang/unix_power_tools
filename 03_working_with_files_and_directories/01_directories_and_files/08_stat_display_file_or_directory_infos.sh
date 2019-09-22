#!/usr/bin/env bash

# stat command lists almost everything in an inode.

stat 01_mkdir_dash_p_mkdir_with_parent_directories.bats
  # File: 01_mkdir_dash_p_mkdir_with_parent_directories.bats
  # Size: 222       	Blocks: 8          IO Block: 4096   regular file
# Device: 803h/2051d	Inode: 2367075     Links: 1
# Access: (0755/-rwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
# Access: 2019-09-18 10:33:25.469384953 +0800
# Modify: 2019-09-01 20:39:45.671454287 +0800
# Change: 2019-09-01 20:39:45.699453597 +0800
 # Birth: -

stat .
  # File: .
  # Size: 4096      	Blocks: 8          IO Block: 4096   directory
# Device: 803h/2051d	Inode: 2367530     Links: 2
# Access: (0755/drwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
# Access: 2019-09-22 11:00:08.356059705 +0800
# Modify: 2019-09-22 11:05:03.817299231 +0800
# Change: 2019-09-22 11:05:03.817299231 +0800
 # Birth: -
